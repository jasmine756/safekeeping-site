-- Safekeeping — remove test rows before launch
-- Paste into Supabase: SQL Editor -> New query -> Run.
--
-- Three test rows were inserted while confirming the connection worked.
-- This deletes exactly those three and nothing else.

delete from public.submissions
where email in (
  'test@safekeeping.test',
  'verifier@test.invalid',
  'verifier-e2e@test.invalid'
);

-- Confirm the table is clean (should return 0 before you post the link):
select count(*) as remaining_rows from public.submissions;
