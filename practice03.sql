-----------
-- 연습문제 : 조인
-----------

-- 문제 1.
-- 직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을 조회
-- 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬

SELECT employee_id as 사번,
    first_name as 이름,
    last_name as 성, 
    department_name as 부서명
FROM employees emp INNER JOIN departments dept
    ON emp.department_id = dept.department_id
ORDER BY department_name, employee_id DESC;

-- 문제 1의 다른 풀이
SELECT employee_id as 사번,
    first_name as 이름,
    last_name as 성, 
    department_name as 부서명
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id
ORDER BY department_name, employee_id DESC;

-- 문제 2.
-- employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다
-- 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현재업무(job_title)를
-- 사번(employee_id) 오름차순으로 정렬
-- 부서가 없는 Kimberely(사번178)은 표시하지 않습니다.
-- ANSI
SELECT employee_id as 사번,
    first_name as 이름,
    salary as 급여,
    department_name as 부서명,
    job_title as 현재업무
FROM employees emp 
INNER JOIN jobs jobs 
    ON emp.job_id = jobs.job_id
INNER JOIN departments dept
    ON emp.department_id = dept.department_id
ORDER BY employee_id;

-- 문제 2의 다른 풀이
SELECT employee_id as 사번,
    first_name as 이름,
    salary as 급여,
    department_name as 부서명,
    job_title as 현재업무
FROM employees emp, jobs jobs, departments dept
WHERE emp.department_id = dept.department_id AND
    emp.job_id = jobs.job_id
ORDER BY employee_id;

-- 문제 2-1.
-- 부서가 없는 Kimberly(사번 178)까지 표시해 보세요.
-- ANSI
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp 
INNER JOIN jobs jobs 
    ON emp.job_id = jobs.job_id
LEFT OUTER JOIN departments dept
    ON emp.department_id = dept.department_id
ORDER BY employee_id;

-- 문제 2-1의 다른 풀이
SELECT employee_id as 사번,
    first_name as 이름,
    salary as 급여,
    department_name as 부서명,
    job_title as 현재업무
FROM employees emp, jobs jobs, departments dept
WHERE emp.department_id = dept.department_id (+) AND
    emp.job_id = jobs.job_id
ORDER BY employee_id;

-- 문제 3.
-- 도시별로 위치한 부서 파악
-- 도시아이디, 도시명, 부서명, 부서아이디를
-- 도시아이디(오름차순) 정렬, 부서 없는 도시는 표시하지 않는다.
-- ANSI
SELECT loc.location_id as 도시아이디, city 도시명, department_id 부서아이디, department_name 부서명
FROM departments dept
    INNER JOIN locations loc 
        ON dept.location_id = loc.location_id
ORDER BY loc.location_id;

-- 다른 풀이
SELECT loc.location_id as 도시아이디, city 도시명, department_id 부서아이디, department_name 부서명
FROM locations loc RIGHT OUTER JOIN departments dept
    ON loc.location_id = dept.location_id
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
-- ANSI
SELECT region_name, country_name
FROM countries coun JOIN regions reg ON coun.region_id = reg.region_id
ORDER BY region_name, country_name DESC;

-- WHERE 문
SELECT region_name, country_name
FROM countries coun, regions reg
WHERE coun.region_id = reg.region_id
ORDER BY region_name, country_name DESC;

-- 문제 5.
-- 자신의 매니저보다 채용일(hire_date)이 빠른 사원의 
-- 사번(employee_id), 이름(first_name), 채용일(hire_date), 매니저이름(first_name), 매니저입사일(hire_date)을 조회
-- ANSI
SELECT emp.employee_id as 사번, emp.first_name as 이름, emp.hire_date as 채용일, 
        man.first_name as 매니저이름, man.hire_date as 매니저입사일
FROM employees emp JOIN employees man 
    ON emp.manager_id = man.employee_id
WHERE emp.hire_date < man.hire_date;

-- WHERE 문
SELECT emp.employee_id as 사번, emp.first_name as 이름, emp.hire_date as 채용일, 
        man.first_name as 매니저이름, man.hire_date as 매니저입사일
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id
    AND emp.hire_date < man.hire_date;

-- 문제 6.
-- 나라별로 어떠한 부서들이 위치하고있는지 파악
-- 나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 
-- 나라명(오름차순)으로 정렬하여 출력. 값이 없는 경우 표시하지 않습니다.
-- ANSI
SELECT country_name as 나라명, coun.country_id as 나라아이디,
    city as 도시명, loc.location_id as 도시아이디, 
    department_name as 부서명, department_id as 부서아이디
FROM countries coun
    JOIN locations loc ON coun.country_id = loc.country_id
    JOIN departments dept ON loc.location_id = dept.location_id
ORDER BY country_name;

-- WHERE 문
SELECT country_name as 나라명, coun.country_id as 나라아이디,
    city as 도시명, loc.location_id as 도시아이디, 
    department_name as 부서명, department_id as 부서아이디
FROM countries coun, locations loc, departments dept
WHERE coun.country_id = loc.country_id 
    AND loc.location_id = dept.location_id
ORDER BY country_name;

-- 문제 7.
-- job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
-- 과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 
-- 사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력
-- 이름은 first_name과 last_name을 합쳐 출력
-- ANSI
SELECT emp.employee_id as 업무아이디, first_name || ' ' || last_name as "이름(풀네임)",
        jobhis.job_id as 업무아이디, start_date as 시작일, end_date as 종료일
FROM employees emp JOIN job_history jobhis 
    ON emp.employee_id = jobhis.employee_id 
WHERE jobhis.job_id = 'AC_ACCOUNT';

-- WHERE 문
SELECT emp.employee_id as 업무아이디, first_name || ' ' || last_name as "이름(풀네임)",
        jobhis.job_id as 업무아이디, start_date as 시작일, end_date as 종료일
FROM employees emp, job_history jobhis 
WHERE emp.employee_id = jobhis.employee_id AND jobhis.job_id = 'AC_ACCOUNT';

-- 문제 8.
-- 각 부서(department)에 대해서 
-- 부서번호(department_id), 부서이름(department_name), 
-- 매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 
-- 나라(countries)의 이름(countries_name) 그리고 
-- 지역구분(regions)의이름(resion_name)까지전부출력
-- WHERE 문
SELECT dept.department_id as 부서번호, department_name as 부서명,
        emp.first_name as 매니저, city as 도시, country_name as 나라, region_name as 지역
FROM departments dept, employees emp, locations loc, countries coun, regions reg
WHERE dept.manager_id = emp.employee_id
    AND loc.location_id = dept.location_id
    AND coun.country_id = loc.country_id
    AND reg.region_id = coun.region_id
ORDER BY dept.department_id;

-- 문제 9.
-- 각 사원(employee)에 대해 
-- 사번(employee_id), 이름(first_name), 부서명(department_name), 매니저(manager)의이름(first_name)을 조회 
-- 부서가 없는 직원(Kimberely)도 표시합니다
SELECT emp.employee_id as 사번, emp.first_name as 이름, department_name as 부서명, man.first_name as 매니저이름
FROM employees emp
    LEFT OUTER JOIN departments dept 
        ON emp.department_id = dept.department_id;
    JOIN employees man ON emp.manager_id = man.employee_id
    