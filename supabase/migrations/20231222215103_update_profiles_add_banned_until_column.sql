alter table profiles add column banned_until timestamp with time zone;

alter policy "authenticated users can create notes"
on public.notes
to authenticated
with check (
  profile_id = auth.uid()
  and
  (
    (select banned_until from profiles where id = profile_id) is null
    or 
    (select banned_until from profiles where id = profile_id) < now()
  )
);
