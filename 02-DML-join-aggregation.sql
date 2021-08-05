--------
-- JOIN
--------

-- 먼저 employees와 departments를 확인
DESC employees; -- 데이터 타입 확인해보자
DESC departments;

-- 두 테이블로부터 모든 레코드를 추출 : Cartision Product of Cross Join
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
ORDER BY first_name;

-- 테이블 조인을 위한 조건 부여할 수 있다.
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

-- 총 몇 명의 사원이 있는지 확인
SELECT COUNT(*) FROM employees; -- 107명

SELECT first_name, emp.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id; -- 106명

-- department_id가 null인 직원?
SELECT * FROM employees
WHERE department_id is null;

-- USING : 조인할 컬럼을 명시
SELECT first_name, department_name
FROM employees JOIN departments USING (department_id); -- USING(employees의 FK and departments의 PK)

-- ON : JOIN의 조건절
SELECT first_name, department_name
FROM employees emp JOIN departments dept
                    ON (emp.department_id = dept.department_id); -- JOIN의 조건
                    
-- Natural JOIN
-- 조건 명시하지 않고, 같은 이름을 가진 컬럼으로 JOIN 수행
SELECT first_name, department_name
FROM employees NATURAL JOIN departments; -- manager.id and departments_id
-- 잘못된 쿼리 : Natural Join

------------
-- OUTER JOIN
------------

-- 조건이 만족하는 짝이 없는 튜플도 NULL을 포함하여 결과를 출력
-- 모든 레코드를 출력할 테이블의 위치에 따라 LEFT, RIGHT, FULL OUTER JOIN으로 구분
-- ORACLE의 경우 NULL을 출력할 조건 쪽에 (+)를 명시

-- LEFT OUTER JOIN

-- ORACLE SQL
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+);
-- ANSI SQL
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name
FROM employees emp LEFT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;

                    
-- RIGHT OUTER JOIN 
-- 짝이 없는 오른쪽 레코드도 null을 포함하여 출력

-- ORACLE SQL
SELECT first_name, emp.department_id, dept.department_id, dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id;

-- ANSI SQL
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name
FROM employees emp RIGHT OUTER JOIN departments dept
ON emp.department_id = dept.department_id;

-- FULL OUTER JOIN
-- 양쪽 테이블 레코드 전부를 짝이 없어도 출력에 참여

-- ORACLE (+) 방식으로는 불가
-- SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name
-- FROM employees emp, departments dept
-- WHERE emp.department_id (+) = dept.department_id (+);

-- ANSI SQL
SELECT emp.first_name, emp.department_id, dept.department_name, dept.department_id
FROM employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-------------
-- SELF JOIN
-------------
-- 자기 자신과 JOIN
-- 자기 자신을 두 번 이상 호출 -> alias를 사용할 수 밖에 없는 JOIN
SELECT * FROM employees; -- 107명

-- 사원 정보, 매니저 이름을 함께 출력
-- 방법 1.
SELECT emp.employee_id, emp.first_name, emp.manager_id, man.employee_id, man.first_name
FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id
ORDER BY emp.employee_id;

-- 방법 2.
SELECT emp.employee_id, emp.first_name, emp.manager_id, man.employee_id, man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id (+) -- LEFT OUTER JOIN
ORDER BY emp.employee_id;

-------------
-- 집계 함수
-------------
-- 여러 레코드로부터 데이터를 수집, 하나의 결과 행을 반환

-- count(): 갯수 세기
SELECT count(*) FROM employees; -- 특정 컬럼이 아닌 레코드의 갯수를 센다

SELECT count(commission_pct) FROM employees; -- 해당 컬럼이 NULL이 아닌 갯수
SELECT count(*) FROM employees WHERE commission_pct IS NOT NULL; -- 위와 같다

-- sum(): 합계
-- 급여의 합계
SELECT sum(salary) FROM employees;

-- avg(): 평균
-- 급여의 평균
SELECT avg(salary) FROM employees;
-- avg 함수는 null 값은 집계에서 제외

-- 사원들의 평균 커미션 비율
SELECT avg(commission_pct) FROM employees; -- NULL 제외한 집계
SELECT avg(nvl(commission_pct, 0)) FROM employees; -- NULL = 0 으로 산입한 집계

-- min/max() : 최소/최대값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

-- 일반적 오류
SELECT department_id, AVG(salary)
FROM employees; -- ERROR

-- 수정 : 집계함수
SELECT department_id, AVG(salary)
FROM employees
GROUP by department_id
ORDER BY department_id;

-- 집계 함수를 사용한 SELECT 문의 컬럼 목록에는
-- Group by에 참여한 필드, 집계 함수만 올 수 있다.

-- 부서별 평균 급여를 출력,
-- 평균 급여가 7000 이상인 부서만 뽑아봅시다.
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 7000
GROUP BY department_id; -- ERROR
-- 집계 함수 실행 이전에 WHERE 절을 검사하기 때문에
-- 집계 함수는 WHERE 절에서 사용할 수 없다

SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id
HAVING AVG(salary) >= 7000
ORDER BY department_id;

------------
-- 분석 함수
-------------
-- ROLLUP
-- 그룹핑된 결과에 대해 상세 요약을 제공하는 기능
-- 일종의 ITEM Total
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- CUBE
-- Cross Table에 대한 Summary를 함께 추출
-- ROLLUP 함수에서 추출되는 Item Total과 함께
-- Column Total 값을 함께 추출
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

------------
-- SUBQUERY
------------
-- Single-Row SubQuery
-- 하나의 질의문 안에 다른 질의문을 포함하는 형태
-- 전체 사원 중, 급여의 중앙값보다 많이 받는 사원

-- 1. 급여의 중앙값?
SELECT MEDIAN(salary) FROM employees; 
-- 결과값인 6200은 하나의 Row이므로 Sing-Row SubQuery로 사용 가능

-- 2. 급여의 중앙값보다 많이 받는 사원?
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- 3. Den 보다 늦게 입사한 사원?
SELECT first_name, hire_date
FROM employees
WHERE hire_date >=
    (SELECT hire_date FROM employees WHERE first_name = 'Den');
    
-- Multi-Row SubQuery
-- 서브 쿼리의 결과 레코드가 둘 이상이 나올 때는 단일행 연산자를 사용할 수 없다.
-- IN, ANY, ALL, EXISTS 등의 집합 연산자를 활용해야 함
SELECT salary FROM employees WHERE department_id = 110; -- 2 ROW

SELECT first_name, salary FROM employees WHERE salary =
    (SELECT salary FROM employees WHERE department_id = 110); -- ERROR
    
-- 결과가 다중이면 집합 연산자를 활용
-- salary가 12,008 OR salary = 8,300
SELECT first_name, salary FROM employees WHERE salary IN
    (SELECT salary FROM employees WHERE department_id = 110);
    
-- ALL(AND)
-- salary > 12,008 AND salary > 8,300
SELECT first_name, salary FROM employees WHERE salary > ALL
    (SELECT salary FROM employees WHERE department_id = 110);
    
-- ANY(OR)
-- salary > 12,008 OR salary > 8,300
SELECT first_name, salary FROM employees WHERE salary > ANY
    (SELECT salary FROM employees WHERE department_id = 110);

-- 각 부서별로 최고 급여를 받는 사원을 출력
-- 1. 각 부서의 최고 급여 확인 쿼리
SELECT department_id, MAX(salary) FROM employees
GROUP BY department_id;

-- 2. 서브 쿼리의 결과 (department_id, MAX(salary))
SELECT department_id, employee_id, first_name, salary
FROM employees
WHERE (department_id, salary) 
    IN (SELECT department_id, MAX(salary) 
        FROM employees 
        GROUP BY department_id)
ORDER BY department_id;

-- 서브쿼리와 조인(임시 테이블 생성)
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e, (SELECT department_id, MAX(salary) salary FROM employees
                    GROUP BY department_id) sal
WHERE  e.department_id = sal.department_id AND
    e.salary = sal.salary
ORDER BY e.department_id;

-- Correalated Query
-- 외부 쿼리와 내부 쿼리가 연관관계를 맺는 쿼리
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e
WHERE e.salary = (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id)
ORDER BY e.department_id;

-- TOP-K Query
-- ROWNUM : 레코드의 순서를 가리키는 가상의 컬럼(Pseudo)

-- 2007년 입사자 중에서 급여순위 5위까지 출력
SELECT rownum, first_name
FROM (SELECT * FROM employees WHERE hire_date like '07%' ORDER BY salary DESC)
WHERE rownum <= 5;

-- 집합 연산 : SET
-- UNION : 합집합, UNION ALL : 합집합(중복 요소 소거하지 않음)
-- INTERSECT : 교집합, MINUS : 차집합

-- 05/01/01 이전 입사자 쿼리
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01';
-- 급여를 12000 초과 수령 사원
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION -- 합집합
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION ALL -- 합집합(중복 요소 제거하지 않음)
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
INTERSECT -- 교집합
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
MINUS -- 차집합
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

-- 순위 함수
-- RANK() : 중복순위 다음은 해당 개수만큼 건너뛰고 다음 순위를 반환
-- DENSE_RANK() : 중복순위 상관없이 다음 순위
-- ROW_NUMBER() : 순위 상관 없이 차례대로

SELECT salary, first_name,
    RANK() OVER (ORDER BY salary DESC) rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) dense_rank,
    ROW_NUMBER() OVER (ORDER BY salary DESC) row_number
FROM employees;

-- Hierarchical Query : 계층적 쿼리
-- Tree 형태의 구조 추출
-- LEVEL 가상 컬럼
SELECT level, employee_id, first_name, manager_id
FROM employees
START WITH manager_id IS NULL -- 트리 시작 조건
CONNECT BY PRIOR employee_id = manager_id
ORDER BY level;