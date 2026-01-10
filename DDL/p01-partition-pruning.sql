-- 파티션 프루닝을 위한 테이블 생성

--CREATE TABLE yellow_trips (
--    vendorid INTEGER,
--    tpep_pickup_datetime TIMESTAMP,
--    tpep_dropoff_datetime TIMESTAMP,
--    passenger_count INTEGER,
--    trip_distance NUMERIC,
--    pickup_longitude NUMERIC,
--    pickup_latitude NUMERIC,
--    ratecodeid INTEGER,
--    store_and_fwd_flag VARCHAR(1),
--    dropoff_longitude NUMERIC,
--    dropoff_latitude NUMERIC,
--    payment_type INTEGER,
--    fare_amount NUMERIC,
--    extra NUMERIC,
--    mta_tax NUMERIC,
--    tip_amount NUMERIC,
--    tolls_amount NUMERIC,
--    total_amount NUMERIC
--) PARTITION BY RANGE (tpep_pickup_datetime);


-- 2015년 1월 파티션
--CREATE TABLE yellow_trips_2015_01 PARTITION OF yellow_trips
--FOR VALUES FROM ('2015-01-01') TO ('2015-02-01');

-- 2016년 1월 파티션
--CREATE TABLE yellow_trips_2016_01 PARTITION OF yellow_trips
--FOR VALUES FROM ('2016-01-01') TO ('2016-02-01');

-- 2016년 2월 파티션
--CREATE TABLE yellow_trips_2016_02 PARTITION OF yellow_trips
--FOR VALUES FROM ('2016-02-01') TO ('2016-03-01');

-- 2016년 3월 파티션
--CREATE TABLE yellow_trips_2016_03 PARTITION OF yellow_trips
--FOR VALUES FROM ('2016-03-01') TO ('2016-04-01');
