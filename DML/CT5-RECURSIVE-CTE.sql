WITH SECOND_PARENT AS(
    SELECT *
    FROM ECOLI_DATA AS E
    WHERE E.PARENT_ID IN (
        SELECT ID
        FROM ECOLI_DATA
        WHERE PARENT_ID IS NULL
    )
)
SELECT E.ID
FROM ECOLI_DATA AS E
    JOIN SECOND_PARENT AS S
        ON E.PARENT_ID = S.ID
ORDER BY E.ID ASC

WITH RECURSIVE generations AS (
    -- 1단계: 1세대 (앵커/초기값)
    SELECT 
        ID,
        PARENT_ID,
        1 AS generation  -- 세대 번호 추가
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL
    
    UNION ALL
    
    -- 2단계: 재귀 - 이전 세대의 자식들 찾기
    SELECT 
        e.ID,
        e.PARENT_ID,
        g.generation + 1  -- 세대 번호 증가
    FROM ECOLI_DATA AS e
        JOIN generations AS g ON e.PARENT_ID = g.ID
)
SELECT ID
FROM generations
WHERE generation = 3  -- 3세대만 선택
ORDER BY ID ASC