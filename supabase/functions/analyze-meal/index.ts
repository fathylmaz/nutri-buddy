// Supabase Edge Function: analyze-meal (Gemini Free Tier development adapter)
// Auth required (verify JWT ON). GEMINI_API_KEY stays in Supabase Secrets.
// For prototyping with non-sensitive food-only photos; no personal/health data.
import { withSupabase } from 'npm:@supabase/server@1';

const schema = {
  type: 'object',
  additionalProperties: false,
  properties: {
    name: { type: 'string' },
    portion_grams: { type: 'number' },
    calories_kcal: { type: 'integer' },
    protein_g: { type: 'number' },
    carbs_g: { type: 'number' },
    fat_g: { type: 'number' },
    fiber_g: { type: 'number' },
    foods: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          name: { type: 'string' }, grams: { type: 'number' },
          calories_kcal: { type: 'integer' }, protein_g: { type: 'number' },
          carbs_g: { type: 'number' }, fat_g: { type: 'number' },
        },
        required: ['name', 'grams', 'calories_kcal', 'protein_g', 'carbs_g', 'fat_g'],
      },
    },
    vitamin_c_mg: { type: ['number', 'null'] },
    vitamin_a_mcg: { type: ['number', 'null'] },
    vitamin_d_mcg: { type: ['number', 'null'] },
    vitamin_b12_mcg: { type: ['number', 'null'] },
    caution: { type: 'string' },
  },
  required: [
    'name', 'portion_grams', 'calories_kcal', 'protein_g', 'carbs_g',
    'fat_g', 'fiber_g', 'foods', 'vitamin_c_mg', 'vitamin_a_mcg',
    'vitamin_d_mcg', 'vitamin_b12_mcg', 'caution',
  ],
} as const;

const reply = (value: unknown, status = 200) => Response.json(value, {
  status,
  headers: { 'Cache-Control': 'no-store' },
});

// The schema constrains formatting, but estimates still need basic validation.
type NutritionAnalysis = {
  name: string; portion_grams: number; calories_kcal: number;
  protein_g: number; carbs_g: number; fat_g: number; fiber_g: number;
  foods: Array<{
    name: string; grams: number; calories_kcal: number;
    protein_g: number; carbs_g: number; fat_g: number;
  }>;
  vitamin_c_mg: number | null; vitamin_a_mcg: number | null;
  vitamin_d_mcg: number | null; vitamin_b12_mcg: number | null;
  caution: string;
};

const within = (x: unknown, max: number) =>
  typeof x === 'number' && Number.isFinite(x) && x >= 0 && x <= max;
const optionalWithin = (x: unknown, max: number) => x === null || within(x, max);
const textField = (x: unknown, max: number) => typeof x === 'string' && x.length <= max;

function isPlausibleAnalysis(a: unknown): a is NutritionAnalysis {
  if (typeof a !== 'object' || a === null) return false;
  const v = a as Record<string, unknown>;
  if (!textField(v.name, 120) || !textField(v.caution, 1500) ||
      !within(v.portion_grams, 5000) || !within(v.calories_kcal, 10000) ||
      !within(v.protein_g, 1000) || !within(v.carbs_g, 1000) ||
      !within(v.fat_g, 1000) || !within(v.fiber_g, 250) ||
      !optionalWithin(v.vitamin_c_mg, 10000) ||
      !optionalWithin(v.vitamin_a_mcg, 100000) ||
      !optionalWithin(v.vitamin_d_mcg, 10000) ||
      !optionalWithin(v.vitamin_b12_mcg, 100000) ||
      !Array.isArray(v.foods) || v.foods.length > 25) return false;
  return v.foods.every((item: unknown) => {
    if (typeof item !== 'object' || item === null) return false;
    const f = item as Record<string, unknown>;
    return textField(f.name, 120) && within(f.grams, 5000) &&
      within(f.calories_kcal, 10000) && within(f.protein_g, 1000) &&
      within(f.carbs_g, 1000) && within(f.fat_g, 1000);
  });
}

export default {
  fetch: withSupabase({ auth: 'user' }, async (request, ctx) => {
    if (request.method !== 'POST') return reply({ error: 'method_not_allowed' }, 405);
    if ((Number(request.headers.get('content-length') ?? '0')) > 7_500_000) {
      return reply({ error: 'payload_too_large' }, 413);
    }
    let input: Record<string, unknown>;
    try {
      input = await request.json();
    } catch {
      return reply({ error: 'invalid_json' }, 400);
    }
    const mime = input.mime_type;
    const b64 = input.image_base64;
    if (typeof mime !== 'string' ||
        !['image/jpeg', 'image/png', 'image/webp'].includes(mime) ||
        typeof b64 !== 'string' || b64.length < 100 || b64.length > 7_200_000 ||
        !/^[A-Za-z0-9+/]+={0,2}$/.test(b64)) {
      return reply({ error: 'invalid_image' }, 400);
    }
    const apiKey = Deno.env.get('GEMINI_API_KEY');
    if (!apiKey) return reply({ error: 'server_not_configured' }, 503);

    // This project's SQL migration reserves up to 10 attempts per user/day.
    const { data: reserved, error: quotaError } = await ctx.supabase
      .rpc('reserve_vision_request');
    if (quotaError) return reply({ error: 'quota_unavailable' }, 503);
    if (reserved !== true) return reply({ error: 'daily_quota_exceeded' }, 429);

    // Only the food image goes to Gemini: no user ID, health record, meal
    // history, allergies, weight, or account metadata are sent upstream.
    // Do not log image bodies, API keys, or model output.
    let upstream: Response;
    try {
      upstream = await fetch(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent',
        {
          method: 'POST',
          headers: {
            'x-goog-api-key': apiKey,
            'Content-Type': 'application/json',
          },
          signal: AbortSignal.timeout(35_000),
          body: JSON.stringify({
            systemInstruction: { parts: [{ text:
              'You estimate food nutrition from photos for user review. '
              + 'If not clearly food, return foods=[] and a Turkish caution. '
              + 'Identify visible food components and estimate edible grams and totals. '
              + 'Avoid precise claims. Never assume invisible ingredients or allergens. '
              + 'Vitamins are very uncertain: use null unless sufficiently supported. '
              + 'Do not provide medical advice. Answer in Turkish.'
            }] },
            contents: [{
              role: 'user',
              parts: [
                { text: 'Bu yemek fotoğrafını analiz et. Görünür bileşenleri, tahmini porsiyonları, kalorileri ve makroları belirle. Yalnızca gerekçelendirilebilen vitaminleri tahmin et; belirsizlikleri caution alanına yaz.' },
                { inlineData: { mimeType: mime, data: b64 } },
              ],
            }],
            generationConfig: {
              responseMimeType: 'application/json',
              responseJsonSchema: schema,
              temperature: 0.2,
              maxOutputTokens: 1800,
            },
          }),
        },
      );
    } catch {
      return reply({ error: 'ai_unavailable' }, 502);
    }

    // Log a *classified* provider error, never the raw provider response,
    // photo, user prompt, credential, or raw message. The response to Flutter
    // deliberately stays generic. Use the Edge Function Logs for diagnosis.
    if (!upstream.ok) {
      let providerStatus = 'UNKNOWN';
      let providerMessage = '';
      try {
        const body: unknown = await upstream.json();
        if (typeof body === 'object' && body !== null && 'error' in body) {
          const error = (body as { error?: unknown }).error;
          if (typeof error === 'object' && error !== null) {
            const value = error as { status?: unknown; message?: unknown };
            if (typeof value.status === 'string' &&
                /^[A-Z_]{3,40}$/.test(value.status)) {
              providerStatus = value.status;
            }
            if (typeof value.message === 'string') {
              providerMessage = value.message.slice(0, 2500);
            }
          }
        }
      } catch {
        // A non-JSON error response must not crash the Edge Function.
      }

      const msg = providerMessage.toLowerCase();
      let category = 'unknown_provider_failure';
      if (upstream.status === 400) {
        category = /schema|responsejsonschema|generation.config|invalid json payload|additionalproperties/i.test(msg)
          ? 'schema_or_generation_config_rejected'
          : /inline.data|mime|image|payload|size/i.test(msg)
          ? 'image_request_rejected'
          : 'invalid_request';
      } else if (upstream.status === 401) {
        category = 'api_authentication_failed';
      } else if (upstream.status === 403) {
        category = /location|country|region/i.test(msg)
          ? 'region_or_project_access_restricted'
          : /billing|quota|free tier/i.test(msg)
          ? 'billing_or_plan_restriction'
          : 'api_permission_denied';
      } else if (upstream.status === 404) {
        category = 'model_not_found_or_unavailable';
      } else if (upstream.status === 429) {
        category = 'gemini_rate_or_quota_limit';
      } else if (upstream.status >= 500) {
        category = 'gemini_server_error';
      }
      console.error('[analyze-meal] Gemini upstream rejected request', {
        upstreamHttpStatus: upstream.status,
        upstreamErrorStatus: providerStatus,
        category,
      });
      if (upstream.status === 429) {
        return reply({ error: 'provider_quota_exceeded' }, 429);
      }
      return reply({ error: 'ai_request_failed' }, 502);
    }

    try {
      const result = await upstream.json();
      const text = result?.candidates?.[0]?.content?.parts
        ?.filter((part: { text?: unknown }) => typeof part.text === 'string')
        ?.map((part: { text: string }) => part.text)
        ?.join('');
      if (typeof text !== 'string' || text.length > 30_000) {
        return reply({ error: 'analysis_unavailable' }, 422);
      }
      const analysis: unknown = JSON.parse(text);
      if (!isPlausibleAnalysis(analysis)) {
        return reply({ error: 'invalid_ai_result' }, 502);
      }
      if (analysis.foods.length === 0) {
        return reply({ error: 'food_not_recognized' }, 422);
      }
      return reply({ analysis }); // Flutter contract remains unchanged.
    } catch {
      return reply({ error: 'invalid_ai_result' }, 502);
    }
  }),
};
