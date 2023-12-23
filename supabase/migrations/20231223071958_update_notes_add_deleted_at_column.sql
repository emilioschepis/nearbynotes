alter table notes add column deleted_at timestamp with time zone;

alter policy "everyone can select notes"
on public.notes
to anon, authenticated
using (deleted_at is null or profile_id = auth.uid());

create policy "authenticated users can update notes"
on public.notes
for update
to authenticated
using (profile_id = auth.uid() and deleted_at is null)
with check (profile_id = auth.uid());

CREATE OR REPLACE FUNCTION find_nearby_notes(lat double precision, lon double precision)
RETURNS SETOF notes AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM notes
    WHERE deleted_at is null and ST_DWithin(
        notes.location::geography,
        ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography,
        (select (metadata->>'find_nearby_notes_distance')::double precision from configurations limit 1)
    )
    ORDER BY notes.created_at DESC
    LIMIT (select (metadata->>'find_nearby_notes_limit')::integer from configurations limit 1);
END;
$$ LANGUAGE plpgsql;
