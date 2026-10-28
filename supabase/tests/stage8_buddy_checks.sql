-- Run in Supabase SQL Editor to inspect migration results (read-only).
select to_regclass('public.buddy_reward_claims') as reward_ledger;
select to_regprocedure('public.claim_buddy_rewards()') as reward_rpc;
select to_regprocedure('public.buy_buddy_item(uuid)') as purchase_rpc;
select to_regprocedure('public.equip_buddy_item(uuid)') as equip_rpc;
select sku, name, gold_price from public.items
where sku like 'buddy_%' order by gold_price;
select relrowsecurity as ledger_rls_enabled
from pg_class where oid = 'public.buddy_reward_claims'::regclass;
-- Avoid manually calling reward RPC from the admin SQL Editor:
-- it relies on auth.uid() from an authenticated app session.
