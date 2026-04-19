CREATE TABLE async_test (
    id SERIAL PRIMARY KEY,
    data TEXT NOT NULL
);

CREATE TABLE sync_test (
    id SERIAL PRIMARY KEY,
    data TEXT NOT NULL
);

INSERT INTO async_test (data)
SELECT 'Async test ' || i
FROM generate_series(1, 100000) AS i;

INSERT INTO sync_test (data)
SELECT 'Sync test ' || i
FROM generate_series(1, 100000) AS i;

CREATE OR REPLACE FUNCTION async_benchmark()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    PERFORM * FROM async_test;
    RAISE NOTICE 'Async benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_benchmark()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    FOR i IN SELECT * FROM sync_test LOOP
        PERFORM i;
    END LOOP;
    RAISE NOTICE 'Sync benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

SELECT async_benchmark();
SELECT sync_benchmark();

CREATE OR REPLACE FUNCTION async_benchmark_concurrent()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    PERFORM * FROM async_test WHERE id % 2 = 0;
    PERFORM * FROM async_test WHERE id % 2 = 1;
    RAISE NOTICE 'Async concurrent benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_benchmark_concurrent()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    FOR i IN SELECT * FROM sync_test WHERE id % 2 = 0 LOOP
        PERFORM i;
    END LOOP;
    FOR i IN SELECT * FROM sync_test WHERE id % 2 = 1 LOOP
        PERFORM i;
    END LOOP;
    RAISE NOTICE 'Sync concurrent benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

SELECT async_benchmark_concurrent();
SELECT sync_benchmark_concurrent();

CREATE OR REPLACE FUNCTION async_benchmark_parallel()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    PERFORM * FROM async_test WHERE id % 4 = 0;
    PERFORM * FROM async_test WHERE id % 4 = 1;
    PERFORM * FROM async_test WHERE id % 4 = 2;
    PERFORM * FROM async_test WHERE id % 4 = 3;
    RAISE NOTICE 'Async parallel benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_benchmark_parallel()
RETURNS VOID AS $$
DECLARE
    t TIMESTAMP;
BEGIN
    t := clock_timestamp();
    FOR i IN SELECT * FROM sync_test WHERE id % 4 = 0 LOOP
        PERFORM i;
    END LOOP;
    FOR i IN SELECT * FROM sync_test WHERE id % 4 = 1 LOOP
        PERFORM i;
    END LOOP;
    FOR i IN SELECT * FROM sync_test WHERE id % 4 = 2 LOOP
        PERFORM i;
    END LOOP;
    FOR i IN SELECT * FROM sync_test WHERE id % 4 = 3 LOOP
        PERFORM i;
    END LOOP;
    RAISE NOTICE 'Sync parallel benchmark: %', clock_timestamp() - t;
END;
$$ LANGUAGE plpgsql;

SELECT async_benchmark_parallel();
SELECT sync_benchmark_parallel();