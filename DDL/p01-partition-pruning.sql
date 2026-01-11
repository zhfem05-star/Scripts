EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM yellow_trips
order by tpep_pickup_datetime
LIMIT 100;

--EXPLAIN (ANALYZE, BUFFERS) 
--SELECT * FROM yellow_trips
--where tpep_pickup_datetime >= '2016-01-01'
--and tpep_pickup_datetime < '2016-02-01'
--order by tpep_pickup_datetime
--LIMIT 100;
