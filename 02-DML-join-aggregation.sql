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