CREATE INDEX idx_datetime_payment 
ON yellow_trips(tpep_pickup_datetime, payment_type);

EXPLAIN ANALYZE
SELECT *
FROM yellow_trips
WHERE tpep_pickup_datetime = '2016-01-01'
LIMIT 100;