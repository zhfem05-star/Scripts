# EXPLAIN(Analyze, Buffers) 읽는 법

EXPLAIN은 하나의 트리구조로 들여쓰기 되어 있을수록 먼저 시행됨

**또한 앞에 인자로 ANALYZE를 주면 비용이 나가게 됨**

원래는 그냥 통계적 예측으로 비용과 값을 보여주는 방식이라 비용이 안 나오지만

ANALAYZE를 쓰면 비용이 나올 수 밖에 없음

'''
Limit  (cost=390615.02..390616.19 rows=10 width=118) (actual time=621.835..636.614 rows=10 loops=1)
  Buffers: shared hit=2320 read=221043
  ->  Gather Merge  (cost=390615.02..1450931.22 rows=9087790 width=118) (actual time=620.248..635.025 rows=10 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        Buffers: shared hit=2320 read=221043
        ->  Sort  (cost=389615.00..400974.74 rows=4543895 width=118) (actual time=602.707..602.709 rows=10 loops=3)
              Sort Key: yellow_trips.tpep_dropoff_datetime
              Sort Method: top-N heapsort  Memory: 29kB
              Buffers: shared hit=2320 read=221043
              Worker 0:  Sort Method: top-N heapsort  Memory: 29kB
              Worker 1:  Sort Method: top-N heapsort  Memory: 29kB
              ->  Parallel Seq Scan on yellow_trips_2016_01 yellow_trips  (cost=0.00..291423.06 rows=4543895 width=118) (actual time=2.058..423.289 rows=3635619 loops=3)
                    Filter: ((tpep_pickup_datetime >= '2016-01-01 00:00:00'::timestamp without time zone) AND (tpep_pickup_datetime < '2016-02-01 00:00:00'::timestamp without time zone))
                    Buffers: shared hit=2208 read=221043
Planning Time: 0.136 ms
JIT:
  Functions: 7
  Options: Inlining false, Optimization false, Expressions true, Deforming true
  Timing: Generation 0.641 ms, Inlining 0.000 ms, Optimization 0.489 ms, Emission 7.138 ms, Total 8.268 ms
Execution Time: 636.859 ms
'''

'''
Limit  (cost=390615.02..390616.19 rows=10 width=118) (actual time=621.835..636.614 rows=10 loops=1)
'''

cost는 PostgreSQL이 예상한 비용 (임의 단위)

앞 숫자(390615.02): 첫 번째 row를 얻는데 드는 비용

뒷 숫자(390616.19): 모든 row를 얻는데 드는 총 비용

차이가 작음 = 10개만 가져오니까 추가 비용이 거의 없음


rows=10: 예상 반환 row 개수

width=118: 각 row의 예상 크기 (바이트)

actual time=621.835..636.614:


실제 측정된 시간 (밀리초)

621.835ms: 첫 row 반환 시작

636.614ms: 10개 모두 반환 완료


rows=10: 실제로 반환된 row 개수

loops=1: 이 작업이 1번 실행됨

'''
Buffers: shared hit=2320 read=221043
'''

Buffers: 얼마나 많은 데이터 블록을 읽었는가? (1 블록 = 8KB)

shared hit=2320:

메모리(RAM)에 캐시되어 있어서 바로 읽은 블록 수

2,320 블록 × 8KB = 약 18MB

빠름! (메모리 읽기)

read=221043:

디스크에서 읽어야 했던 블록 수

221,043 블록 × 8KB = 약 1.7GB

느림! (디스크 읽기)

총 읽은 데이터: 18MB + 1.7GB = 약 1.72GB

햇갈리면 안됨! 레코드 != 블록

**블록**은 레코드가 저장되어 있는 최소단위로 약 8kb에 해당함

'''
Gather Merge  (cost=390615.02..1450931.22 rows=9087790 width=118) (actual time=620.248..635.025 rows=10 loops=1)
'''

Gather Merge:

SQL이 데이터를 처리할 때 worker는 병렬로 작업하는데

이를 Gather Merge에서 합침

"Merge"는 이미 정렬된 결과들을 합친다는 뜻

rows=9087790:

병렬 작업 전체에서 예상되는 총 row 수

실제로는 10개만 가져옴 (Limit 때문)

actual time=620.248..635.025 rows=10:

실제로 10개의 row를 반환함

약 620~635ms 소요

'''
Workers Planned: 2
Workers Launched: 2

'''

Workers Planned: 2: PostgreSQL이 병렬 처리를 위해 2개의 작업자를 계획

Workers Launched: 2: 실제로 2개의 작업자가 실행됨

즉, 메인 프로세스 1개 + 작업자 2개 = 총 3개의 프로세스가 동시에 일함!

'''
Sort  (cost=389615.00..400974.74 rows=4543895 width=118) (actual time=602.707..602.709 rows=10 loops=3)
'''

Sort: 데이터를 정렬 (ORDER BY tpep_dropoff_datetime 때문)

rows=4543895: 각 작업자가 예상하는 정렬할 row 수

actual time=602.707..602.709 rows=10:

실제로는 10개만 정렬 (Limit 때문에 조기 종료)

loops=3:

이 정렬이 각각의 작업자에 의해 3번 실행됨

메인 프로세스 1번 + 작업자 2번 = 3번

각 프로세스가 독립적으로 정렬

'''
Sort Key: yellow_trips.tpep_dropoff_datetime
Sort Method: top-N heapsort  Memory: 29kB
'''

메인 프로세스가 작업하는 내용

'''
Buffers: shared hit=2208 read=221043
Worker 0:  Sort Method: top-N heapsort  Memory: 28kB
Worker 1:  Sort Method: top-N heapsort  Memory: 29kB
'''

나머지 워커 둘이 작업하는 내용

'''
Parallel Seq Scan on yellow_trips_2016_01 yellow_trips  (cost=0.00..291423.06 rows=4543895 width=118) (actual time=2.058..423.289 rows=3635619 loops=3)
Filter: ((tpep_pickup_datetime >= '2016-01-01 00:00:00'::timestamp without time zone) AND (tpep_pickup_datetime < '2016-02-01 00:00:00'::timestamp without time zone))
Buffers: shared hit=2208 read=221043
'''

파티션 프루닝하여 작업되는 데이터들을 모아놓은 정보



'''
JIT:
  Functions: 7
  Options: Inlining false, Optimization false, Expressions true, Deforming true
  Timing: Generation 0.641 ms, Inlining 0.000 ms, Optimization 0.489 ms, Emission 7.138 ms, Total 8.268 ms
'''

JIT (Just-In-Time Compilation):

PostgreSQL이 쿼리를 더 빠르게 실행하기 위해 코드를 컴파일

대부분 무시해도 됨 (고급 최적화)

Total 8.268 ms: JIT 컴파일에 8ms 소요 (전체 실행 시간에 비하면 미미)

'''
Execution Time: 636.859 ms
'''

실제 모든 작업에 걸린 시간을 나타냄