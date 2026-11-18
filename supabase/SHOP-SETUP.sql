-- Safekeeping Shop — inventory + orders
-- Paste this whole file into Supabase: SQL Editor -> New query -> Run.
-- Safe to run more than once.

-- ─── Inventory ──────────────────────────────────────────────────────────────
create table if not exists public.products (
  id               text primary key,            -- short url name, e.g. 'black-in-blues-1st'
  title            text not null,
  creator          text,                        -- author / artist / label
  year             text,                        -- '1974', 'c. 1970s'
  category         text not null default 'book' -- book | cd | magazine | decor | other
                   check (category in ('book','cd','magazine','decor','other')),
  ship_class       text not null default 'media'-- media = USPS Media Mail (books, CDs only)
                   check (ship_class in ('media','ground')),  -- ground = everything else
  ship_price_cents integer,                     -- optional: set a custom shipping price (e.g. the clock)
  price_cents      integer not null check (price_cents > 0),
  condition        text,                        -- 'Very good — light shelf wear'
  story            text,                        -- the "why this one matters" blurb
  images           text[] not null default '{}',-- image paths or URLs, first one is the cover
  status           text not null default 'available'
                   check (status in ('available','reserved','sold','hidden')),
  hold_token       text,                        -- set while someone is checking out
  reserved_until   timestamptz,
  sort             integer not null default 100,-- lower shows first
  created_at       timestamptz not null default now(),
  sold_at          timestamptz
);

create index if not exists products_status_idx on public.products (status, sort);

alter table public.products enable row level security;

-- The public page can READ items that aren't hidden. It cannot change anything.
drop policy if exists "public can read shop items" on public.products;
create policy "public can read shop items"
  on public.products for select to anon
  using (status <> 'hidden');

-- ─── Orders (private — only you see these, in the Table Editor) ─────────────
create table if not exists public.orders (
  id                 uuid primary key default gen_random_uuid(),
  created_at         timestamptz not null default now(),
  stripe_session_id  text unique not null,
  email              text,
  name               text,
  shipping_address   jsonb,
  product_ids        text[] not null,
  subtotal_cents     integer,
  shipping_cents     integer,
  tax_cents          integer,
  total_cents        integer,
  shipped            boolean not null default false,
  tracking           text,
  notes              text
);

alter table public.orders enable row level security;
-- Deliberately NO policies: the public key can't read or write orders.
-- Checkout writes them with the private server key.
