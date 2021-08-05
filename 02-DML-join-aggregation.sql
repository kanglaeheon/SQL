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

-- SUING : 조인할 컬럼을 명시
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

-----------
-- 연습문제 : 조인
-----------

-- 문제 1.
-- 직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을 조회
-- 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬

SELECT first_name, last_name, department_name, employee_id
FROM employees emp JOIN departments dept
ON emp.department_id = dept.department_id
ORDER BY department_name, employee_id DESC;

-- 문제 2.
-- employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다
-- 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현재업무(job_title)를
-- 사번(employee_id) 오름차순으로 정렬
-- 부서가 없는 Kimberely(사번178)은 표시하지 않습니다.
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp 
JOIN jobs jobs 
ON emp.job_id = jobs.job_id
JOIN departments dept
ON emp.department_id = dept.department_id
ORDER BY employee_id;

-- 문제 2-1.
-- 부서가 없는 Kimberly(사번 178)까지 표시해 보세요.
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp 
JOIN jobs jobs 
ON emp.job_id = jobs.job_id
LEFT OUTER JOIN departments dept
ON emp.department_id = dept.department_id
ORDER BY employee_id;

-- 문제 3.
-- 도시별로 위치한 부서 파악
-- 도시아이디, 도시명, 부서명, 부서아이디를
-- 도시아이디(오름차순) 정렬, 부서 없는 도시는 표시하지 않는다.
SELECT loc.location_id as 도시아이디, city 도시명, department_name 부서명, department_id 부서아이디
FROM departments dept
    JOIN locations loc ON dept.location_id = loc.location_id
ORDER BY loc.location_id;

-- 문제 3-1.
-- 문제 3의 부서가 없는 도시도 표현
SELECT loc.location_id as 도시아이디, city 도시명, department_name 부서명, department_id 부서아이디
FROM departments dept
    RIGHT OUTER JOIN locations loc ON dept.location_id = loc.location_id
ORDER BY loc.location_id;

-- 문제 4.
-- 지역(regions)에 속한 나라들을 
-- 지역이름(region_name), 나라이름(country_name)으로 출력 
-- 지역이름(오름차순), 나라이름(내림차순) 으로 정렬
SELECT region_name, country_name
FROM countries coun JOIN regions reg ON coun.region_id = reg.region_id
ORDER BY region_name, country_name DESC;

-- 문제 5.
-- 자신의 매니저보다 채용일(hire_date)이 빠른 사원의 
-- 사번(employee_id), 이름(first_name), 채용일(hire_date), 매니저이름(first_name), 매니저입사일(hire_date)을 조회
SELECT emp.employee_id as 사번, emp.first_name as 이름, emp.hire_date as 채용일, 
        man.first_name as 매니저이름, man.hire_date as 매니저입사일
FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id
WHERE emp.hire_date < man.hire_date;

-- 문제 6.
-- 나라별로 어떠한 부서들이 위치하고있는지 파악
-- 나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 
-- 나라명(오름차순)으로 정렬하여 출력. 값이 없는 경우 표시하지 않습니다.
SELECT country_name as 나라명, coun.country_id as 나라아이디,
    city as 도시명, loc.location_id as 도시아이디, 
    department_name as 부서명, department_id as 부서아이디
FROM countries coun
    JOIN locations loc ON coun.country_id = loc.country_id
    JOIN departments dept ON loc.location_id = dept.location_id
ORDER BY country_name;

-- 문제 7.
-- job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
-- 과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 
-- 사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력
-- 이름은 first_name과 last_name을 합쳐 출력
SELECT emp.employee_id, first_name || ' ' || last_name, jobhis.job_id, start_date, end_date
FROM employees emp JOIN job_history jobhis ON emp.employee_id = jobhis.employee_id 
WHERE jobhis.job_id = 'AC_ACCOUNT';

-- 문제 8.
-- 각 부서(department)에 대해서 
-- 부서번호(department_id), 부서이름(department_name), 
-- 매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 
-- 나라(countries)의 이름(countries_name) 그리고 
-- 지역구분(regions)의이름(resion_name)까지전부출력
SELECT dept.department_id, department_name, dept.manager_id, city, country_name, region_name
FROM departments dept 
    JOIN employees emp ON emp.department_id = dept.department_id
    JOIN locations loc ON loc.location_id = dept.location_id
    JOIN countries coun ON coun.country_id = loc.country_id
    JOIN regions reg ON reg.region_id = coun.region_id;

-- 문제 9.
-- 각 사원(employee)에 대해 
-- 사번(employee_id), 이름(first_name), 부서명(department_name), 매니저(manager)의이름(first_name)을 조회 
-- 부서가 없는 직원(Kimberely)도 표시합니다
SELECT emp.employee_id as 사번, emp.first_name as 이름, department_name as 부서명, man.first_name as 매니저이름
FROM employees emp
    JOIN employees man ON emp.manager_id = man.employee_id
    JOIN departments dept ON emp.department_id = dept.department_id;