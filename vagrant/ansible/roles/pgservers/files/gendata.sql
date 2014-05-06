DO $$
    DECLARE p1_lat FLOAT;
    DECLARE p1_lon FLOAT;
    DECLARE p2_lat FLOAT;
    DECLARE p2_lon FLOAT;
    DECLARE count INTEGER;
    DECLARE points INTEGER;
    DECLARE wkt TEXT;
BEGIN
    SELECT COUNT(1) INTO count FROM multipolygons;
    PERFORM SETVAL('seq_attr_integer', (SELECT COALESCE(MAX(attr_integer)+1, 1) FROM multipolygons), FALSE);

    FOR i IN (count+1)..10000 LOOP
        p1_lat := RANDOM()*180-90;
        p1_lon := RANDOM()*360-180;

        SELECT (normal_rand^17+70)::INTEGER INTO points FROM NORMAL_RAND(1, 1, .2);

        IF points >= 4 AND points <= 103227 THEN
            wkt := 'MULTIPOLYGON(((' || p1_lon || ' ' || p1_lat;

            FOR p IN 2..(points-1) LOOP
                p2_lat := RANDOM()*180-90;
                p2_lon := RANDOM()*360-180;

                wkt := wkt || ', ' || p2_lon || ' ' || p2_lat;
            END LOOP;
            wkt := wkt || ', ' || p1_lon || ' ' || p1_lat || ')))';

            INSERT INTO multipolygons (attr_integer, the_geom) VALUES (NEXTVAL('seq_attr_integer'), ST_GeomFromText(wkt, 4326));
        END IF;
    END LOOP;
END$$;
