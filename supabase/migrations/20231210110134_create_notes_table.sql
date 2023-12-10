create extension postgis with schema extensions;

create table notes (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id),
  created_at timestamp with time zone not null default now(),
  content text not null,
  location geometry(POINT, 4326) not null
);

create index notes_profile_id_idx on notes(profile_id);
create index notes_location_idx on notes using gist(location);

alter table notes enable row level security;

create policy "everyone can select notes"
on public.notes
for select
to anon, authenticated
using (true);
