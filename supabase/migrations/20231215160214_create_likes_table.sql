create table likes (
  note_id uuid not null references notes(id) on delete cascade,
  profile_id uuid not null,
  created_at timestamp with time zone not null default now(),

  primary key (note_id, profile_id)
);

alter table likes enable row level security;

create policy "everyone can select likes"
on likes
for select
to anon, authenticated
using (true);

create policy "authenticated users can create likes"
on likes
for insert
to authenticated
with check (profile_id = auth.uid());

create policy "authenticated users can delete likes"
on likes
for delete
to authenticated
using (profile_id = auth.uid());
