-- NutriBuddy Stage 9: evidence-linked RAG chat. Run once after Stage 8.
-- No prior tables are dropped or modified.
begin;
create schema if not exists extensions;
create extension if not exists vector with schema extensions;

create table if not exists public.dietitian_knowledge (
  id uuid primary key default gen_random_uuid(),
  source_key text not null unique check (length(source_key) between 3 and 90),
  title text not null check (length(title) between 3 and 180),
  source_url text not null check (source_url ~ '^https://'),
  content text not null check (length(content) between 40 and 2500),
  embedding extensions.vector(768),
  is_active boolean not null default true,
  updated_at timestamptz not null default now()
);
-- Bounded seed set is small: an index is unnecessary until the corpus grows.
alter table public.dietitian_knowledge enable row level security;
revoke all on public.dietitian_knowledge from public, anon, authenticated;
-- No client may read or edit the knowledge table directly. Retrieval is RPC-only.

create table if not exists public.dietitian_conversations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 90),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(id, user_id)
);
create index if not exists dietitian_conversations_user_idx
  on public.dietitian_conversations(user_id, updated_at desc);
alter table public.dietitian_conversations enable row level security;
revoke all on public.dietitian_conversations from public, anon, authenticated;
grant select, insert, update, delete on public.dietitian_conversations to authenticated;
create policy dietitian_conversations_self_select on public.dietitian_conversations
  for select to authenticated using (user_id = (select auth.uid()));
create policy dietitian_conversations_self_insert on public.dietitian_conversations
  for insert to authenticated with check (user_id = (select auth.uid()));
create policy dietitian_conversations_self_update on public.dietitian_conversations
  for update to authenticated using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
create policy dietitian_conversations_self_delete on public.dietitian_conversations
  for delete to authenticated using (user_id = (select auth.uid()));

create table if not exists public.dietitian_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  conversation_id uuid not null,
  role text not null check (role in ('user','assistant')),
  content text not null check (length(content) between 1 and 6000),
  sources jsonb not null default '[]'::jsonb
    check (jsonb_typeof(sources) = 'array'),
  created_at timestamptz not null default now(),
  foreign key (conversation_id, user_id)
    references public.dietitian_conversations(id, user_id) on delete cascade
);
create index if not exists dietitian_messages_conversation_idx
  on public.dietitian_messages(user_id, conversation_id, created_at desc);
alter table public.dietitian_messages enable row level security;
revoke all on public.dietitian_messages from public, anon, authenticated;
-- Users can read their history. The authenticated Edge Function writes messages.
-- Direct client inserts are intentionally disallowed; auth-scoped function uses
-- a carefully scoped SECURITY DEFINER insert RPC below.
grant select on public.dietitian_messages to authenticated;
create policy dietitian_messages_self_select on public.dietitian_messages
  for select to authenticated using (user_id = (select auth.uid()));

create table if not exists private.dietitian_usage_daily (
  user_id uuid not null references auth.users(id) on delete cascade,
  utc_day date not null,
  request_count integer not null default 0 check (request_count between 0 and 12),
  primary key (user_id, utc_day)
);
revoke all on private.dietitian_usage_daily from public, anon, authenticated;

-- Bounded atomic quota. Non-refundable when Gemini fails, discouraging retries.
create or replace function public.reserve_dietitian_request()
returns boolean language plpgsql security definer set search_path = '' as $$
declare v_user uuid := (select auth.uid());
begin
  if v_user is null then return false; end if;
  insert into private.dietitian_usage_daily(user_id, utc_day, request_count)
  values (v_user, (now() at time zone 'utc')::date, 1)
  on conflict (user_id, utc_day) do update
    set request_count = private.dietitian_usage_daily.request_count + 1
    where private.dietitian_usage_daily.request_count < 12;
  return found;
end; $$;
revoke all on function public.reserve_dietitian_request() from public, anon;
grant execute on function public.reserve_dietitian_request() to authenticated;

create or replace function public.search_dietitian_knowledge(
  query_embedding extensions.vector, match_count integer default 5)
returns table(source_key text, title text, source_url text, content text, similarity double precision)
language plpgsql security definer set search_path = '' as $$
begin
  if (select auth.uid()) is null then
    raise exception 'authentication_required';
  end if;
  if extensions.vector_dims(query_embedding) <> 768 then
    raise exception 'invalid_vector_dimensions';
  end if;
  return query
  select k.source_key, k.title, k.source_url, k.content,
    (1 - (k.embedding <=> query_embedding))::double precision as similarity
  from public.dietitian_knowledge k
  where k.is_active = true and k.embedding is not null
  order by k.embedding <=> query_embedding
  limit greatest(1, least(coalesce(match_count, 5), 5));
end; $$;
revoke all on function public.search_dietitian_knowledge(extensions.vector, integer) from public, anon;
grant execute on function public.search_dietitian_knowledge(extensions.vector, integer) to authenticated;

-- Atomic server-only write. Edge Function checks user ownership before invoking.
-- EXECUTE is granted only to service_role. Never expose service_role to Flutter.
create or replace function public.append_dietitian_exchange(
  p_user_id uuid, p_conversation_id uuid, p_question text,
  p_answer text, p_sources jsonb)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not exists (
    select 1 from public.dietitian_conversations
    where id = p_conversation_id and user_id = p_user_id
  ) then raise exception 'conversation_not_found'; end if;
  if char_length(p_question) not between 1 and 900
    or char_length(p_answer) not between 1 and 6000
    or jsonb_typeof(p_sources) <> 'array'
    or pg_catalog.octet_length(p_sources::text) > 6000 then
    raise exception 'invalid_exchange';
  end if;
  insert into public.dietitian_messages(user_id, conversation_id, role, content)
    values(p_user_id, p_conversation_id, 'user', p_question);
  insert into public.dietitian_messages(user_id, conversation_id, role, content, sources)
    values(p_user_id, p_conversation_id, 'assistant', p_answer, p_sources);
  update public.dietitian_conversations set updated_at = now()
    where id = p_conversation_id and user_id = p_user_id;
end; $$;
revoke all on function public.append_dietitian_exchange(uuid,uuid,text,text,jsonb)
  from public, anon, authenticated;
grant execute on function public.append_dietitian_exchange(uuid,uuid,text,text,jsonb)
  to service_role;

-- Seed short, human-curated paraphrases. The source URLs are not fetched at
-- runtime; verify these manually whenever medical guidance is updated.
insert into public.dietitian_knowledge(source_key,title,source_url,content) values
('who-balanced','WHO — Healthy diet: temel ilkeler',
 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
 'Dengeli beslenmede yeterlilik, denge, ölçülülük ve çeşitlilik önemlidir. Yetişkinlerde meyve ve sebze çeşitliliğini artırmak ve yüksek derecede işlenmiş, aşırı tuzlu ve serbest şeker içeriği yüksek ürünlerin tüketimini sınırlamak genel bir yaklaşımdır.'),
('who-fruitveg','WHO — Meyve, sebze ve lif',
 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
 'WHO, 10 yaşından büyükler için günde en az 400 gram meyve ve sebze; doğal besin lifi için de günde en az 25 gram hedefinden bahseder. Bu nüfus düzeyi önerileri kişiye özel tedavi reçetesi değildir.'),
('who-salt','WHO — Tuz tüketimi',
 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
 'WHO yetişkinlerin günlük toplam tuz tüketimini 5 gramın altında tutmayı önerir. Hazır yemekler, işlenmiş etler, soslar ve tuzlu atıştırmalıklar toplam tuz alımına katkıda bulunabilir.'),
('who-grains','WHO — Tam tahıllar ve baklagiller',
 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
 'Tam tahıllar, sebze ve meyveler ile mercimek, nohut ve fasulye gibi baklagiller karbonhidrat ve lif bakımından farklı seçenekler sunar. Öğün çeşitliliğini artırmak genel beslenme kalitesini destekleyebilir.'),
('cdc-weight','CDC — Kilo yönetimine bütüncül yaklaşım',
 'https://www.cdc.gov/healthy-weight-growth/losing-weight/index.html',
 'CDC sürdürülebilir kilo yönetiminde beslenme düzeninin yanında hareket, uyku ve stres yönetimine de dikkat çeker. Hızlı sonuç vaatleri yerine sürdürülebilir ve gerçekçi davranış değişiklikleri önemlidir.'),
('cdc-gradual','CDC — Kademeli kilo değişimi',
 'https://www.cdc.gov/healthy-weight-growth/losing-weight/index.html',
 'CDC, kilo vermeyi hedefleyen yetişkinler için kademeli ve istikrarlı ilerlemenin aşırı hızlı kilo kaybına göre korunmasının daha kolay olduğunu belirtir. Her bireyin sağlık durumu farklıdır; katı kalori kısıtlaması veya hızlı kilo kaybı kişisel öneri olarak verilmemelidir.'),
('nih-vitd','NIH ODS — D vitamini kaynakları',
 'https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional/',
 'NIH Office of Dietary Supplements kaynağı D vitamini içeren besinler arasında yağlı balıklar, güçlendirilmiş bazı süt ve bitkisel içecekler ile bazı mantar türlerini sayar. Takviye dozu ya da eksiklik tedavisi için kişisel tıbbi değerlendirme gerekir.'),
('who-variety','WHO — Besin çeşitliliği',
 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
 'Beslenme çeşitliliği farklı besin gruplarının zaman içinde dengeli dağılımına dayanır. Tek bir yiyecek veya tek bir günlük kayıt, genel sağlık durumunu veya besin eksikliğini teşhis etmek için yeterli değildir.')
on conflict(source_key) do nothing;
commit;
