
-----------
-- 연습문제 : 집계
-----------
-- 문제 1.
-- 매니저가 있는 직원은 몇 명 ?
SELECT COUNT(manager_id) as "HaveMngCnt" FROM employees
WHERE manager_id IS NOT NULL;

-- 문제 2.
-- 최고임금(salary)과 최저임금을 "최고임금", "최저임금" 프로젝션 타이틀로 출력
-- 두 임금의 차이는? "최고임금 - 최저임금" 타이틀로 출력
SELECT MAX(salary) as "최고임금", MIN(salary) as "최저임금", MAX(salary) - MIN(salary) as "최고임금 - 최저임금"
FROM employees;

-- 문제 3.
-- 마지막 신입사원 들어온 날?
SELECT TO_CHAR(MAX(hire_date), 'YYYY"년 "MM"월 "DD"일 "') as 입사일
FROM employees;

-- 문제 4.
-- 부서별 평균임금, 최고임금, 최저임금을
-- 부서아이디(department_id)와 함꼐 출력
-- 정렬순서는 부서번호(department_id) 내림차순
SELECT department_id as 부서번호,
    ROUND(MAX(salary), 2) as 평균임금, 
    MAX(salary) 최고임금, 
    MIN(salary) 최저임금
FROM employees
GROUP BY department_id
ORDER BY department_id DESC;

-- 문제 5.
-- job_id 별로 평균임금, 최고임금, 최저임금을 업무아이디(job_id)와 함께 출력
-- 정렬순서 최저임금 내림차순, 평균임금(소수점 반올림) 오름차순
-- 정렬순서는 최소임금 2500 구간일 때 확인해볼 것
SELECT job_id as 업무아이디, ROUND(AVG(salary), 0) as 평균임금, MAX(salary) 최고임금, MIN(salary) 최소임금
FROM employees
GROUP BY job_id
ORDER BY 최소임금 DESC, 평균임금;

-- 문제 6.
-- 가장 오래 근속한 직원의 입사일? 
SELECT TO_CHAR(MIN(hire_date), 'YYYY-MM-DD day') as 입사일 FROM employees;

-- 문제 7.
-- 평균임금과 최저임금의 차이가 2000 미만인,
-- 부서(department_id), 평균임금, 최저임금, (평균 - 최저임금)을 출력
-- (평균 - 최저임금) 내림차순 정렬
SELECT department_id as "부서", 
    ROUND(AVG(salary), 1) as "평균임금", 
    MIN(salary) as "최저임금",
    ROUND(AVG(salary), 1) -  MIN(salary) as "평균임금 - 최저임금"
FROM employees
GROUP BY department_id
    HAVING ROUND(AVG(salary), 1) -  MIN(salary) < 2000
ORDER BY ROUND(AVG(salary), 1) -  MIN(salary) DESC;

-- 문제 8.
-- 업무(JOBS)별로 최고임금과 최저임금의 차이를 출력
-- 차이를 확인할 수 있도록 내림차순으로 정렬
SELECT job_id, MAX(salary) - MIN(salary) as diff
FROM employees
GROUP BY job_id
ORDER BY diff DESC;

-- 문제 9.
-- 2005년 이후 입사자 중에서 관리자별로 평균급여, 최소급여, 최대급여를 알아보려고 한다.
-- 출력은 관리자별로 평균급여가 5000 이상 중에 평균급여, 최소급여, 최대급여를 출력
-- 평균급여의 내림차순 정렬, 평균급여는 소수점 첫째자리에서 반올림
SELECT manager_id, ROUND(AVG(salary)), MIN(salary), MAX(salary)
FROM employees
WHERE hire_date >= '2005/01/01'
GROUP BY manager_id
    HAVING ROUND(AVG(salary), 0) >= 5000
ORDER BY ROUND(AVG(salary)) DESC;

-- 문제 10.
-- 보너스 지급을 위해 입사일 기준으로 나누기
-- 02/12/31 이전 입사자는 '창립멤버'
-- 03년 입사자 '03년입사', 04년 입사자 '04년입사', 이후 입사자 '상장이후입사'
-- optDate 컬럼의 데이터로 출력
-- 정렬은 입사일로 오름차순
SELECT employee_id, salary,
    CASE WHEN hire_date <= '02/12/31' THEN '창립멤버'
        WHEN hire_date <= '03/12/31' THEN '03년 입사'
        WHEN hire_date <= '04/12/31' THEN '04년 입사'
        ELSE '상장 이후 입사'
    END optDate, hire_date
FROM employees
ORDER BY hire_date;