DROP INDEX idx_datetime_payment;

EXPLAIN ANALYZE
SELECT *
FROM yellow_trips
WHERE tpep_pickup_datetime = '2016-01-01'
LIMIT 100;