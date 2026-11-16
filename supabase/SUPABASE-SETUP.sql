-- Safekeeping — subscriber collection
-- Paste this whole file into Supabase: SQL Editor -> New query -> Run.

create table if not exists public.submissions (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  form        text not null,          -- which form: waitlist / estate co / tip / custody
  email       text,
  phone       text,                   -- optional, for the text list later
  city        text,
  region      text,                   -- state, or markets for estate companies
  payload     jsonb not null          -- every field verbatim, incl. UTMs + referrer
);

-- Fast lookups when the list grows.
create index if not exists submissions_created_at_idx on public.submissions (created_at desc);
create index if not exists submissions_form_idx       on public.submissions (form);

-- Row Level Security ON. This is the important part:
-- the public key in the page can INSERT a row, but cannot read anything back.
-- Nobody can pull your subscriber list from the browser.
alter table public.submissions enable row level security;

drop policy if exists "public can insert submissions" on public.submissions;
create policy "public can insert submissions"
  on public.submissions
  for insert
  to anon
  with check (true);

-- Deliberately NO select/update/delete policy for anon.
-- You still see every row in the Supabase Table Editor, which bypasses RLS.
