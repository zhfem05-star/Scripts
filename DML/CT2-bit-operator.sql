-- :SELECT: ID, 이메일, 이름, 성을 조회하는 SQL 문을 작성
-- :FROM: SKILLCODES, DEVELOPERS
-- :WHERE: Python C# 스킬을 가진 개발자
-- :ORDER: ID ASC
-- SKILLOCDES NAME, CATEGORY, CODE
-- DEVELOPERS ID, FIRST_NAME, LAST_NAME, EMAIL, SKILL_CODE
-- 비트연산자로 계산할 경우 해당 키에 해당하는 값을 2인수 바꿈
-- 그럼 파이썬하고 C#을 OR로 한 다음 & 하여 > 0 으로 구해보면 되나?

SELECT
    ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (
        SELECT SUM(CODE)
        FROM SKILLCODES
        WHERE NAME IN ('Python', 'C#')
    )
ORDER BY ID ASC;