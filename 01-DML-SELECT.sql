-- DML: SELECT

---------
-- SELECT ~ FROM
---------

-- 전체 데이터의 모든 컬럼 조회
-- 컬럼의 출력 순서는 정의에 따른다
SELECT * FROM employees;
SELECT * FROM departments;

-- 특정 컬럼만 선별 Projection
-- 사원의 이름, 입사일, 급여 출력
SELECT first_name, hire_date, salary FROM employees;

-- 산술연산: 기본적인 산술연산 가능
-- dual: oracle의 가상 테이블(샌드박스로 생각하자)
-- 특정 테이블에 속한 데이터가 아닌 오라클 시스템에서 값을 구한다
SELECT 10 * 10 * 3.14159 FROM dual; -- 결과 : 1개
SELECT 10 * 10 * 3.14159 FROM employees; -- 결과 : 테이블의 레코드 수만큼

SELECT first_name, job_id * 12
FROM employees; -- ERROR : 수치데이터 아니면 산술연산 오류
DESC employees;

SELECT first_name + ' ' + last_name
FROM employees; -- ERROR : first_name, last_name은 문자열

-- 문자열 연결은 || 로 연결
SELECT first_name || ' ' || last_name
FROM employees;

-- NULL과 NVL
SELECT first_name, salary, salary * 12 FROM employees;
SELECT first_name, salary, commission_pct FROM employees;

-- NULL이 포함된 산술식은 NULL이므로 NVL 사용
-- commission_pct가 null이면 0으로 치환
SELECT first_name, salary, salary + salary * NVL(commission_pct, 0) FROM employees;

-- ALIAS : 공백, 특수문자가 포함된 별칭은 (" ")로 묶어준다
SELECT first_name || ' ' || last_name 이름, phone_number as 전화번호, salary "급 여" FROM employees;

-- 연습
SELECT first_name || ' ' || last_name 이름, hire_date 입사일, phone_number 전화번호, salary 급여, salary * 12 연봉 FROM employees;


--------------
-- WHERE
--------------

-- 비교연산
-- 급여가 15000 이상인 사원의 목록
SELECT first_name, salary FROM employees WHERE salary >= 15000;

-- 날짜도 대소 비교 가능
-- 입사일이 07/01/01 이후인 사원의 목록
SELECT first_name, hire_date FROM employees WHERE hire_date >= '07/01/01';

-- 이름이 Lex인 사원의 이름, 급여, 입사일 출력
SELECT first_name, salary, hire_date FROM employees WHERE first_name = 'Lex';

-- 논리연산자
-- 급여가 14000 이하이거나 17000 이상인 사원
SELECT first_name, salary FROM employees WHERE salary <= 10000 OR salary >= 17000;

-- 급여가 14000 이상, 17000 이하인 사원의 목록
SELECT first_name, salary FROM employees WHERE salary >= 14000 AND salary <= 17000;
SELECT first_name, salary FROM employees WHERE salary BETWEEN 14000 and 17000;

-- NULL 체크
-- = NULL, != NULL 하면 안됨
-- 반드시 IS NULL, IS NOT NULL 사용
-- 커미션을 받지 않는 사원의 목록
SELECT first_name, commission_pct FROM employees WHERE commission_pct IS NULL;

-- 연습문제:
-- 담당 매니저가 없고, 커미션을 받지 않는 사원의 목록
SELECT first_name, manager_id, commission_pct FROM employees WHERE commission_pct IS NULL AND manager_id IS NULL;

-- 집합 연산자
-- 부서 번호가 10, 20, 30인 사원들의 목록
SELECT first_name, department_id FROM employees WHERE department_id = 10 OR department_id = 20 OR department_id = 30;

-- IN 연산자
SELECT first_name, department_id FROM employees WHERE department_id IN (10, 20, 30);

-- ANY 연산자
SELECT first_name, department_id FROM employees WHERE department_id = ANY (10, 20, 30);

-- ALL : 뒤에 나오는 집합 전부 만족
SELECT first_name, salary FROM employees WHERE Salary >= ALL(12000, 17000);

-- LIKE 연산자 : 부분 검색
-- %: 0글자 이상의 정해지지 않은 문자열
-- _: 1글자의 정해지지 않은 문자
-- 이름에 am을 포함한 사원의 이름과 급여를 출력
SELECT first_name, salary FROM employees WHERE first_name LIKE '%am%';

-- 연습문제:
-- 이름의 두 번째 글자가 a인 사원의 이름과 연봉
SELECT first_name, salary * 12 연봉 FROM employees WHERE first_name LIKE '_a%';

-- ORDER BY
-- 연습문제:
-- 부서 번호 오름차순 정렬, 부서번호, 급여, 이름 출력
SELECT department_id, salary, first_name FROM employees ORDER BY department_id;

-- 연습문제:
-- 급여가 10,000 이상인 직원의 이름을 급여 내림차순으로 출력
SELECT first_name, salary FROM employees WHERE salary >= 10000 ORDER BY salary DESC;

-- 연습문제:
-- 부서번호, 급여, 이름 순으로 출력하되, 부서번호 오름차순, 급여 내림차순으로 정렬
SELECT department_id, salary, first_name FROM employees ORDER BY department_id, salary DESC;

--------------
-- 단일행 함수
--------------

-- 한 개의 레코드를 입력으로 받는 함수
-- 문자열 단일행 함수 연습
SELECT first_name, last_name, 
    CONCAT(first_name, CONCAT(' ', last_name)), -- 연결
    INITCAP(first_name || ' ' || last_name), -- 각 단어의 첫 글자만 대문자
    LOWER(first_name), -- 모두 소문자
    UPPER(first_name), -- 모두 대문자
    LPAD(first_name, 10, '*'), -- 왼쪽 채우기
    RPAD(first_name, 10, '*') -- 오른쪽 채우기
FROM employees;

SELECT LTRIM('      Oracle      '), -- 왼쪽 공백지우기
    RTRIM('      Oracle      '), -- 오른쪽 공백지우기
    TRIM('*' FROM '******Database******'), -- 양쪽의 * 제거
    SUBSTR('Oracle Database', 8, 4), -- 부분 문자열 추출
    SUBSTR('Oracle Database', -8, 8) -- 부분 문자열 오른쪽 기준 추출
FROM dual;

-- 수지형 단일행 함수 연습
SELECT ABS(-3.14), -- 절대값
    CEIL(3.14), -- 소수점 올림
    FLOOR(3.14), -- 소수점 내림
    MOD(7, 3), -- 나머지 함수 '7%3'
    POWER(2, 4), -- 제곱: 2의 4승
    ROUND(3.5), -- 소수점 반올림
    ROUND(3.14159, 3), -- 소수점 세번째 자리까지 반올림하여 표현
    TRUNC(3.5), -- 소수점 버림
    TRUNC(3.14159, 3), -- 소수점 세번째 자리까지 버림하여 표현
    SIGN(-10) -- 부호 혹은 0
FROM dual;

--------------
-- DATE FORMAT
--------------

-- 현재 날짜와 시간
SELECT SYSDATE FROM DUAL; -- 1행
SELECT SYSDATE FROM employees; -- employees의 레코드 개수만큼

-- 날짜 관련 단일행 함수
SELECT sysdate,
    ADD_MONTHS(sysdate, 2), -- 2개월 후
    LAST_DAY(sysdate), -- 이번 달의 마지막 날
    MONTHS_BETWEEN(sysdate, '99/12/31'), -- 1999/12/31 이후 몇 달 지났나?
    NEXT_DAY(sysdate, 4),
    ROUND(sysdate, 'MONTH'),
    ROUND(sysdate, 'YEAR'),
    TRUNC(sysdate, 'MONTH'),
    TRUNC(sysdate, 'YEAR')
FROM dual;

--------------
-- 변환 함수
--------------

-- TO_NUMBER(s, fmt) : 문자열을 포맷에 맞게 수치형으로 변환
-- TO_DATE(s, fmt) : 문자열을 포맷에 맞게 날짜형으로 변환
-- TO_CHAR(o, fmt) : 숫자 or 날짜를 포맷에 맞게 문자형로 변환

-- TO_CHAR
SELECT first_name, hire_date, 
    TO_CHAR(hire_date, 'YYYY-MM-DD'),
    TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')
FROM employees;
    
SELECT TO_CHAR(3000000, 'L999,999,999') FROM dual;

SELECT first_name, TO_CHAR(salary * 12, '$999,999,999') SAL 
FROM employees;

-- TO_NUMBER
SELECT TO_NUMBER('2021'),
    TO_NUMBER('$1,450.13', '$999,999.99')
FROM dual;

-- TO_DATE
SELECT TO_DATE('1999-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

-- 날짜 연산
-- Date + (-) Number : 날짜에 일수 더하기(빼기)
-- Date - Date : 두 Date 사이의 차이 일수
-- Date + (-) Number / 24 : 특정 날짜에 특정 시간 더하기
SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI'),
    SYSDATE + 1, -- 1일 뒤
    SYSDATE - 1, -- 1일 전
    SYSDATE - TO_DATE('19991231'),
    TO_CHAR(SYSDATE + 13/24, 'YY/MM/DD HH24:MI') -- 13시간 후
FROM dual;

--------------
-- NULL 관련
--------------

-- NVL 함수
SELECT first_name,
    salary,
    commission_pct,
    salary * nvl(commission_pct, 0) commission
FROM employees;

-- NVL2 함수
SELECT first_name,
    salary,
    commission_pct,
    nvl2(commission_pct, salary * commission_pct, 0) commission
FROM employees;

-- CASE 함수
-- AD 관련 직원에게는 20%, SA 관련 직원에게는 10%
-- IT 관련 직원에게는 8%, 나머지는 5% 지급
SELECT first_name,
    job_id,
    salary,
    SUBSTR(job_id, 1, 2),
    CASE SUBSTR(job_id, 1, 2) WHEN 'AD' THEN salary * 0.2
                                WHEN 'SA' THEN salary * 0.1
                                WHEN 'IT' THEN salary * 0.08
                                ELSE salary * 0.05
    END bonus
FROM employees;

-- DECODE 함수
SELECT first_name,
    job_id,
    salary,
    SUBSTR(job_id, 1, 2),
    DECODE(SUBSTR(job_id, 1, 2),
        'AD', salary * 0.2,
        'SA', salary * 0.1,
        'IT', salary * 0.08,
        salary * 0.05)   --  ELSE
    bonus
FROM employees;

-- 연습문제:
-- 직원의 이름, 부서, 팀을 출력
-- 팀
--      부서 코드 : 10 ~ 30 -> A-Group
--      부서 코드 : 40 ~ 50 -> B-Group
--      부서 코드 : 60 ~ 100 -> C-Group
--      부서 코드 : 나머지 부서 -> REMAINER

SELECT first_name,
        department_name