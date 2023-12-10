CREATE OR REPLACE FUNCTION find_nearby_notes(lat double precision, lon double precision)
RETURNS SETOF notes AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM notes
    WHERE ST_DWithin(
        notes.location::geography,
        ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography,
        1000
    );
END;
$$ LANGUAGE plpgsql;
