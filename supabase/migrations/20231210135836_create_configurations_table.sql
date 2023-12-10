create table configurations (
  id uuid primary key default gen_random_uuid(),
  metadata jsonb not null
);

alter table configurations enable row level security;

create policy "everyone can select configurations"
on public.configurations
for select
to anon, authenticated
using (true);
