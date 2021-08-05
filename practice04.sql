-- 문제 1.
-- 평균 급여보다 적은 급여를 받는 직원은 몇 명인지?
SELECT COUNT(*) as 평균미만급여자 FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

-- 문제 2.
-- 평균 급여 이상, 최대 급여 이하의 월급을 받는 사원의 
-- 직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를
-- 급여의 오름차순으로 정렬
SELECT employee_id as 직원번호, first_name as 이름, salary as 급여, e.AVG(salary) as 평균급여, e.MAX(salary) as 최대급여
FROM employees e
WHERE 
    salary > (SELECT AVG(salary) FROM employees) as 'avg' AND 
    salary < (SELECT MAX(salary) FROM employees) as 'max'
ORDER BY salary;
