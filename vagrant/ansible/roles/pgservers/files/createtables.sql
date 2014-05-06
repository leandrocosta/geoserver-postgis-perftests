DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables WHERE table_name = 'multipolygons'
    ) THEN
        CREATE TABLE multipolygons (
            id SERIAL NOT NULL,
            attr_integer INTEGER NOT NULL,
            CONSTRAINT multipolygons_pkey PRIMARY KEY (id)
        );
        PERFORM AddGeometryColumn('multipolygons', 'the_geom', 4326, 'MULTIPOLYGON', 2);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.sequences WHERE sequence_name = 'seq_attr_integer'
    ) THEN
        CREATE SEQUENCE seq_attr_integer START 1;
    END IF;
END$$;
