create policy "authenticated users can create notes"
on public.notes
for insert
to authenticated
with check (profile_id = auth.uid());
