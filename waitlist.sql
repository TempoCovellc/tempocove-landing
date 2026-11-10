-- TempoCove waitlist: the public can add themselves, nobody can read the list
-- except you in the Supabase dashboard (Table Editor > waitlist).
create table if not exists public.waitlist (
  id         uuid primary key default gen_random_uuid(),
  role       text not null check (role in ('artist', 'client')),
  name       text not null check (length(name) between 1 and 80),
  email      text not null unique check (length(email) <= 200 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  what       text check (length(what) <= 200),
  link       text check (length(link) <= 300),
  created_at timestamptz not null default now()
);
alter table public.waitlist enable row level security;
create policy "anyone can join the waitlist" on public.waitlist
  for insert to anon, authenticated with check (true);
grant insert on public.waitlist to anon, authenticated;
