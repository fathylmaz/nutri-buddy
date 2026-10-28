// NutriBuddy Stage 6 — AI meal suggestions, explicit consent in Flutter.
// Keep GEMINI_API_KEY in Supabase Secrets. Leave Edge Function JWT check ON.
import { withSupabase } from 'npm:@supabase/server@1';

const schema = {
  type: 'object',
  additionalProperties: false,
  properties: {
    recipes: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          name: { type: 'string' },
          description: { type: 'string' },
          prep_minutes: { type: 'integer' },
          calories_kcal: { type: 'integer' },
          protein_g: { type: 'number' },
          carbs_g: { type: 'number' },
          fat_g: { type: 'number' },
          fiber_g: { type: 'number' },
          caution: { type: 'string' },
          ingredients: {
            type: 'array', items: {
              type: 'object',
              additionalProperties: false,
              properties: {
                name: { type: 'string' },
                quantity: { type: 'string' },
                grams: { type: 'number' },
              },
              required: ['name', 'quantity', 'grams'],
            },
          },
          steps: { type: 'array', items: { type: 'string' } },
        },
        required: [
          'name', 'description', 'prep_minutes', 'calories_kcal',
          'protein_g', 'carbs_g', 'fat_g', 'fiber_g', 'caution',
          'ingredients', 'steps',
        ],
      },
    },
  },
  required: ['recipes'],
} as const;

const respond = (payload: unknown, status = 200) => Response.json(payload, {
  status,
  headers: { 'Cache-Control': 'no-store' },
});

function stringList(value: unknown, max: number): string[] | null {
  if (!Array.isArray(value) || value.length > max ||
      value.some((x) => typeof x !== 'string' ||
        x.trim().length < 1 || x.trim().length > 60)) {
    return null;
  }
  return value.map((s: string) => s.trim());
}
function target(x: unknown, cap: number) {
  return typeof x === 'number' && Number.isFinite(x) && x >= 0 && x <= cap;
}
function text(x: unknown, cap: number) {
  return typeof x === 'string' && x.trim().length > 0 && x.length <= cap;
}
function goodRecipe(raw: unknown): boolean {
  if (typeof raw !== 'object' || raw === null) return false;
  const r = raw as Record<string, unknown>;
  if (!text(r.name, 120) || !text(r.description, 500) ||
      typeof r.caution !== 'string' || r.caution.length > 500 ||
      !target(r.prep_minutes, 360) || !target(r.calories_kcal, 5000) ||
      !target(r.protein_g, 500) || !target(r.carbs_g, 500) ||
      !target(r.fat_g, 500) || !target(r.fiber_g, 200) ||
      !Array.isArray(r.ingredients) || r.ingredients.length < 1 ||
      r.ingredients.length > 20 || !Array.isArray(r.steps) ||
      r.steps.length < 1 || r.steps.length > 12) return false;
  return r.ingredients.every((i: unknown) => {
    if (typeof i !== 'object' || i === null) return false;
    const v = i as Record<string, unknown>;
    return text(v.name, 100) && text(v.quantity, 90) && target(v.grams, 3000);
  }) && r.steps.every((s: unknown) => text(s, 400));
}
function normalize(value: string) {
  return value.toLocaleLowerCase('tr-TR').normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .replaceAll('ı', 'i').replaceAll('ş', 's').replaceAll('ğ', 'g')
    .replaceAll('ü', 'u').replaceAll('ö', 'o').replaceAll('ç', 'c');
}
function explicitExclusion(recipe: Record<string, unknown>, excludes: string[]) {
  const ingredients = recipe.ingredients as Array<{ name: string; quantity: string }>;
  const values = [recipe.name as string, ...ingredients.map((v) => v.name),
    ...ingredients.map((v) => v.quantity), ...(recipe.steps as string[])].map(normalize);
  return excludes.some((word) => {
    const normalized = normalize(word);
    return normalized.length >= 2 && values.some((v) => v.includes(normalized));
  });
}

export default {
  fetch: withSupabase({ auth: 'user' }, async (request, ctx) => {
    if (request.method !== 'POST') return respond({ error: 'method_not_allowed' }, 405);
    if (Number(request.headers.get('content-length') ?? '0') > 15_000) {
      return respond({ error: 'payload_too_large' }, 413);
    }
    let input: Record<string, unknown>;
    try {
      const raw = await request.text();
      if (raw.length > 15_000) return respond({ error: 'payload_too_large' }, 413);
      const data: unknown = JSON.parse(raw);
      if (data === null || typeof data !== 'object' || Array.isArray(data)) {
        return respond({ error: 'invalid_json' }, 400);
      }
      input = data as Record<string, unknown>;
    } catch {
      return respond({ error: 'invalid_json' }, 400);
    }
    const pantry = stringList(input.pantry, 15);
    const exclusions = stringList(input.exclusions, 15);
    const avoidNames = stringList(input.avoid_names, 5);
    const mealType = input.meal_type;
    const dietStyle = input.diet_style;
    const count = input.count;
    if (!pantry || !exclusions || !avoidNames ||
        !['breakfast', 'lunch', 'dinner', 'snack'].includes(mealType as string) ||
        !['any', 'vegan', 'vegetarian'].includes(dietStyle as string) ||
        !Number.isInteger(count) || (count as number) < 1 || (count as number) > 3 ||
        !target(input.remaining_kcal, 10000) ||
        !target(input.remaining_protein_g, 1000) ||
        !target(input.remaining_carbs_g, 1000) ||
        !target(input.remaining_fat_g, 1000) ||
        !target(input.target_kcal, 10000)) {
      return respond({ error: 'invalid_request' }, 400);
    }
    const key = Deno.env.get('GEMINI_API_KEY');
    if (!key) return respond({ error: 'server_not_configured' }, 503);
    const { data: reserved, error: quotaError } = await ctx.supabase
      .rpc('reserve_recipe_request');
    if (quotaError) return respond({ error: 'quota_unavailable' }, 503);
    if (reserved !== true) return respond({ error: 'daily_quota_exceeded' }, 429);

    // Explicitly avoid sending a user's identity, body measurements, diagnoses,
    // account metadata or meal log history. Only submitted preferences/targets.
    const prompt = {
      meal_type: mealType,
      diet_style: dietStyle,
      pantry,
      excluded_ingredients: exclusions,
      avoid_these_previous_recipes: avoidNames,
      count,
      remaining_today_kcal: input.remaining_kcal,
      target_this_meal_kcal: input.target_kcal,
      remaining_today_protein_g: input.remaining_protein_g,
      remaining_today_carbs_g: input.remaining_carbs_g,
      remaining_today_fat_g: input.remaining_fat_g,
    };
    let upstream: Response;
    try {
      upstream = await fetch(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent',
        {
          method: 'POST',
          headers: { 'x-goog-api-key': key, 'Content-Type': 'application/json' },
          signal: AbortSignal.timeout(40_000),
          body: JSON.stringify({
            systemInstruction: { parts: [{ text:
              'Sen Türkçe tarif fikirleri üreten bir yardımcı sistemsin. '
              + 'Sadece tarif öner, tıbbi tavsiye verme. Kullanıcının bildirdiği '
              + 'dışlanan malzemeleri ve olası türevlerini kesinlikle tariflere koyma. '
              + 'Çapraz bulaşmanın ve gizli alerjenlerin kontrol edilemeyeceğini '
              + 'her caution içinde belirt. Besin değerlerini yaklaşık hesapla, '
              + 'hedefleri mümkünse aşma, sıfır kalan hedefte zorunlu yemek önerme. '
              + 'Ev malzemelerini mümkün oldukça kullan; eksik malzemeyi ayrı belirt. '
              + 'Tam olarak belirtilen sayıda farklı tarif, somut ölçüler, hazırlama '
              + 'adımları, makro tahminleri üret. Asla alerjen güvenliği garantisi verme.'
            }] },
            contents: [{ role: 'user', parts: [{ text: JSON.stringify(prompt) }] }],
            generationConfig: {
              responseMimeType: 'application/json',
              responseJsonSchema: schema,
              temperature: 0.4,
              maxOutputTokens: 3600,
            },
          }),
        },
      );
    } catch {
      return respond({ error: 'ai_unavailable' }, 502);
    }
    if (!upstream.ok) {
      let status = 'UNKNOWN';
      try {
        const data: unknown = await upstream.json();
        if (data && typeof data === 'object' && 'error' in data) {
          const err = (data as { error?: { status?: unknown } }).error;
          if (typeof err?.status === 'string' && /^[A-Z_]{3,40}$/.test(err.status)) {
            status = err.status;
          }
        }
      } catch { /* Redact provider response, it may reflect request content. */ }
      console.error('[build-meals] Gemini request failed', {
        upstreamHttpStatus: upstream.status, upstreamErrorStatus: status,
      });
      return respond({ error: upstream.status === 429
        ? 'provider_quota_exceeded' : 'ai_request_failed' },
        upstream.status === 429 ? 429 : 502);
    }
    try {
      const json = await upstream.json();
      const generated = json?.candidates?.[0]?.content?.parts
        ?.filter((part: { text?: unknown }) => typeof part.text === 'string')
        ?.map((part: { text: string }) => part.text).join('');
      if (typeof generated !== 'string' || generated.length > 45000) {
        return respond({ error: 'invalid_ai_result' }, 502);
      }
      const body: unknown = JSON.parse(generated);
      if (body === null || typeof body !== 'object' || !('recipes' in body)) {
        return respond({ error: 'invalid_ai_result' }, 502);
      }
      const recipes = (body as { recipes?: unknown }).recipes;
      if (!Array.isArray(recipes) || recipes.length < 1 ||
          recipes.length > (count as number) || !recipes.every(goodRecipe)) {
        return respond({ error: 'invalid_ai_result' }, 502);
      }
      if (recipes.some((r: Record<string, unknown>) => explicitExclusion(r, exclusions))) {
        return respond({ error: 'excluded_ingredient_detected' }, 422);
      }
      return respond({ recipes });
    } catch {
      return respond({ error: 'invalid_ai_result' }, 502);
    }
  }),
};
