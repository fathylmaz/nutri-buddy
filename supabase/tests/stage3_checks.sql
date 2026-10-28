-- Adım 3: sadece OKUMA, hiçbir tabloda değişiklik yapmaz.
-- Auth trigger ve kullanıcı sütun izinlerinin varlığını doğrula.
select tgname as auth_trigger
from pg_trigger
where tgrelid = 'auth.users'::regclass
  and tgname = 'nutri_buddy_auth_user_created';

select
  has_column_privilege('authenticated', 'public.users', 'weight_kg', 'UPDATE') as authenticated_update_weight,
  has_column_privilege('authenticated', 'public.users', 'allergies', 'UPDATE') as authenticated_update_allergies,
  has_column_privilege('anon', 'public.users', 'weight_kg', 'UPDATE') as anonymous_update_weight,
  (select relrowsecurity from pg_class where oid = 'public.users'::regclass) as user_table_rls;
-- Beklenti: authenticated_update_* true, anonymous_update_weight false, user_table_rls true.
-- Bu sorgular gerçek hesaplar arası RLS izolasyon testinin yerine geçmez.
