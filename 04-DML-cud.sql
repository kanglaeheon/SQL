-----------
-- CUD
-----------

-- INSERT : 묵시적 방법
DESC author;
INSERT INTO author -- (컬럼명 생략)
VALUES (1, '박경리', '토지 작가');

-- INSERT : 명시적 방법
INSERT INTO author (author_id, author_name)
VALUES (2, '김영하');

-- DML은 트랜잭션의 대상
-- 취소: ROLLBACK
-- 변경사항 반영: COMMIT
ROLLBACK; -- 취소
COMMIT; -- 변경사항 반영

SELECT * FROM author;

-- UPDATE
-- 기존 레코드의 내용 변경
UPDATE author
SET author_desc = '소설가';

SELECT * FROM author;
ROLLBACK;

-- UPDATE, DELETE 쿼리 작성시
-- 조건절을 부여하지 않으면 전체 레코드가 영향을 받는다. !! 주의 !!
UPDATE author
SET author_desc = '소설가'
WHERE author_name = '김영하';

COMMIT;

-- 연습
-- HR.employees -> department_id가 10, 20, 30
-- 새테이블 생성
CREATE TABLE emp123 AS
    SELECT * FROM HR.employees;
    
DESC emp123;

-- 부서가 30인 사원들의 급여를 10% 인상
UPDATE emp123
SET salary = salary + salary * 0.1
WHERE department_id = 30;

COMMIT;

-- DELETE : 테이블에서 레코드 삭제
SELECT * FROM emp123;

-- job_id가 MK_사원들 삭제
DELETE FROM emp123
WHERE job_id LIKE 'MK_%';

-- 현재 급여 평균보다 높은 사람을 모두 삭제
DELETE FROM emp123
WHERE salary > (SELECT AVG(salary) FROM emp123);

SELECT * FROM emp123;
COMMIT;

-- TRUNCATE와 DELETE
-- DELETE는 ROLLBACK의 대상, TRUNCATE는 ROLLBACK의 대상이 아니다
DELETE FROM emp123;
SELECT * FROM emp123;
ROLLBACK;
SELECT * FROM emp123;

TRUNCATE TABLE emp123;
SELECT * FROM emp123;
ROLLBACK;