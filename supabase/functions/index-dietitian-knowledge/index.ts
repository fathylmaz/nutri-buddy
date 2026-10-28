// NutriBuddy stage 9: operator-only knowledge indexer.
// Deploy with verify_jwt = false; withSupabase({auth:'secret'}) requires the
// project's named "default" Supabase SECRET key in the apikey header.
// NEVER call this function from Flutter or ship a secret key to the client.
import { withSupabase } from 'npm:@supabase/server@1';

const MODEL = 'gemini-embedding-001';
const DIMENSIONS = 768;
const reply = (data: unknown, status = 200) =>
  Response.json(data, { status, headers: { 'Cache-Control': 'no-store' } });

async function embedDocument(apiKey: string, title: string, content: string): Promise<number[]> {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:embedContent`,
    {
      method: 'POST',
      headers: { 'x-goog-api-key': apiKey, 'Content-Type': 'application/json' },
      signal: AbortSignal.timeout(18000),
      body: JSON.stringify({
        model: `models/${MODEL}`,
        content: { parts: [{ text: `${title}\n${content}` }] },
        // REST request's top-level fields match Google's documented curl examples.
        // Some provider versions ignore embedContentConfig and return 3072 values.
        taskType: 'RETRIEVAL_DOCUMENT',
        title,
        outputDimensionality: DIMENSIONS,
      }),
    },
  );
  if (!response.ok) {
    console.warn('[dietitian-index] embedding_provider_failed', response.status);
    throw new Error(`embedding_provider_http_${response.status}`);
  }
  const data = await response.json();
  const values: unknown = data?.embedding?.values;
  // Only log metadata about an embedding, never the vector, source text or key.
  const length = Array.isArray(values) ? values.length : null;
  if (!Array.isArray(values) || ![DIMENSIONS, 3072].includes(values.length) ||
      values.some((value: unknown) => typeof value !== 'number' || !Number.isFinite(value))) {
    console.warn('[dietitian-index] invalid_embedding_shape', {
      dimension: length,
      hasValues: Array.isArray(values),
      expected: DIMENSIONS,
    });
    throw new Error('invalid_embedding');
  }
  if (values.length !== DIMENSIONS) {
    // gemini-embedding-001 uses Matryoshka vectors; the first 768 values
    // may be used as a lower-dimensional representation.
    console.warn('[dietitian-index] embedding_truncated', {
      received: values.length, stored: DIMENSIONS,
    });
  }
  const reduced = (values as number[]).slice(0, DIMENSIONS);
  // Google recommends normalizing reduced gemini-embedding-001 vectors.
  const norm = Math.sqrt(reduced.reduce((sum, value) => sum + value * value, 0));
  if (!Number.isFinite(norm) || norm <= 0) {
    console.warn('[dietitian-index] invalid_embedding_norm');
    throw new Error('invalid_embedding');
  }
  return reduced.map(value => value / norm);
}

export default {
  fetch: withSupabase({ auth: 'secret' }, async (request, ctx) => {
    if (request.method !== 'POST') return reply({ error: 'method_not_allowed' }, 405);
    const apiKey = Deno.env.get('GEMINI_API_KEY');
    if (!apiKey) return reply({ error: 'gemini_secret_missing' }, 503);
    // Never index user chats or user profiles: knowledge is public material only.
    const { data: rows, error: queryError } = await ctx.supabaseAdmin
      .from('dietitian_knowledge')
      .select('id,title,content')
      .is('embedding', null)
      .eq('is_active', true)
      .limit(8);
    if (queryError) return reply({ error: 'knowledge_read_failed' }, 503);
    let indexed = 0;
    for (const row of rows ?? []) {
      try {
        const vector = await embedDocument(apiKey, String(row.title), String(row.content));
        const { error: updateError } = await ctx.supabaseAdmin
          .from('dietitian_knowledge')
          .update({ embedding: `[${vector.join(',')}]` })
          .eq('id', row.id)
          .is('embedding', null);
        if (updateError) throw new Error('knowledge_update_failed');
        indexed++;
      } catch (error) {
        console.warn('[dietitian-index] indexing_stopped',
          error instanceof Error ? error.message : 'unknown');
        return reply({ error: 'indexing_failed', indexed, remaining: (rows?.length ?? 0) - indexed }, 502);
      }
    }
    return reply({ indexed, complete: (rows ?? []).length < 8 || indexed === 8 });
  }),
};
