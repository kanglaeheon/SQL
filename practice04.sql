-- 문제 1.
-- 평균 급여보다 적은 급여를 받는 직원은 몇 명인지?
SELECT COUNT(*) as 평균미만급여자 FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

-- 문제 2.
-- 평균 급여 이상, 최대 급여 이하의 월급을 받는 사원의 
-- 직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를
-- 급여의 오름차순으로 정렬

-- 서브쿼리
SELECT MAX(salary) FROM employees;
SELECT ROUND(AVG(salary)) FROM employees;

-- 테이블조인
SELECT employee_id as 직원번호, first_name as 이름, salary as 급여,  maxavg.av as 평균급여, maxavg.mx as 최대급여
FROM employees, (SELECT MAX(salary) mx, AVG(salary) av FROM employees) maxavg
WHERE salary >= maxavg.av
ORDER BY salary;

-- GROUP BY 활용 -- 질문필요
SELECT employee_id as 직원번호, first_name as 이름, salary as 급여,  AVG(salary) as 평균급여, MAX(salary) as 최대급여
FROM employees
WHERE salary >= (SELECT avg(salary) from employees)
    AND salary <= (SELECT MAX(salary) from employees)
GROUP BY employee_id, salary, first_name;

-- 문제 3.
-- Steven(first_name), king(last_name)이 
-- 소속된 부서(departments)가 있는곳의 주소를 알아보려고한다.
-- 도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 
-- 도시명(city), 주(state_province), 나라아이디(country_id)출력
SELECT location_id as 도시아이디, street_address as 거리명, postal_code as 우편번호,
    city as 도시명, state_province as 주, country_id as 나라아이디
FROM locations
WHERE location_id IN (SELECT location_id FROM employees WHERE first_name = 'Steven');

-- 문제 4.
-- job_id가 'ST_MAN'인 직원의 급여보다 작은 직원의 
-- 사번, 이름, 급여를 급여의 내림차순 으로 출력-ANY연산자사용
SELECT employee_id as 사번, first_name as 이름, salary as 급여
FROM employees
WHERE salary < ANY (SELECT salary FROM employees WHERE job_id = 'ST_MAN');

-- 문제 5.
-- 각 부서별로 최고의 급여를 받는 사원의 
-- 직원번호(employee_id), 이름(first_name), 급여(salary), 부서번호(department_id) 조회
-- 단, 조회결과는 급여의 내림차순으로 정렬

--서브쿼리
SELECT department_id, MAX(salary) FROM employees GROUP BY department_id;

-- 조건절비교
SELECT employee_id 직원번호, first_name 이름, salary 급여, department_id 부서번호
FROM employees
WHERE (department_id, salary) 
    IN (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY salary DESC;

-- 테이블조인
SELECT employee_id 직원번호, first_name 이름, e.salary 급여, e.department_id 부서번호
FROM employees e, (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) s
WHERE e.department_id = s.department_id
    AND e.salary = s.salary
ORDER BY e.salary DESC;

-- 문제 6.
-- 각 업무(job)별로 연봉(salary)의 총합을 구하고자 합니다.
-- 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉총합을 조회하시오

-- 서브쿼리
(SELECT job_id, SUM(salary) FROM employees GROUP by job_id);

SELECT job_title 업무명, jobsal.sum 업무별연봉총합
FROM jobs j,(SELECT job_id, SUM(salary) sum FROM employees GROUP by job_id) jobsal
WHERE j.job_id = jobsal.job_id
ORDER BY jobsal.sum DESC;

-- 문제 7.
-- 자신의 부서 평균급여보다 연봉(salary)이 많은 직원의 
-- 직원번호(employee_id), 이름(first_name), 급여(salary)을 조회하세요

-- 서브쿼리
(SELECT department_id, AVG(salary) FROM employees GROUP BY department_id);

SELECT employee_id 직원번호, first_name 이름, salary 급여
FROM employees e, 
    (SELECT department_id, AVG(salary) sal FROM employees GROUP BY department_id) avgSalDep -- 부서 평균급여
WHERE salary > avgSalDep.sal AND e.department_id = avgsaldep.department_id;

-- 문제 8. 
-- 직원 입사일이 11번째에서 15번째의 직원의 
-- 사번, 이름, 급여, 입사일을 입사일 순서로 출력

-- 서브쿼리
SELECT hire_date, ROW_NUMBER() OVER (ORDER BY hire_date) FROM employees; -- 입사일 오름차순

SELECT employee_id 사번, first_name 이름, salary 급여, e.hire_date 입사일
FROM employees e, (SELECT hire_date hd, RANK() OVER (ORDER BY hire_date) rn FROM employees) tt -- tt = Temporary Table
WHERE tt.hd = e.hire_date AND tt.rn <= 15 AND tt.rn >= 11;