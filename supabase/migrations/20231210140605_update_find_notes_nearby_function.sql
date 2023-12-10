CREATE OR REPLACE FUNCTION find_nearby_notes(lat double precision, lon double precision)
RETURNS SETOF notes AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM notes
    WHERE ST_DWithin(
        notes.location::geography,
        ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography,
        (select (metadata->>'find_nearby_notes_distance')::double precision from configurations limit 1)
    )
    ORDER BY notes.created_at DESC
    LIMIT (select (metadata->>'find_nearby_notes_limit')::integer from configurations limit 1);
END;
$$ LANGUAGE plpgsql;
