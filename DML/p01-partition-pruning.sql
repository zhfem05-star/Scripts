-- 우선 파티션 프루닝 한 방법 부터 쓰기
-- scripts 다 작성하면 DB train에 따로 저장
-- 메모장에 정리하기

EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM yellow_trips 
WHERE tpep_pickup_datetime >= '2016-01-01' 
  AND tpep_pickup_datetime < '2016-02-01'
LIMIT 100;