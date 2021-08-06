-------------
-- DCL
-------------
-- CREATE : 데이터베이스 객체 생성
-- ALTER : 데이터베이스 객체 수정
-- DROP : 데이터베이스 객체 삭제

-- System 계정으로 수행

-- 사용자 생성 : CREATE USER
CREATE USER c##bituser IDENTIFIED BY bituser;

-- SQLPLUS에서 새로 만든 사용자로 접속
-- 사용자 삭제 : DROP USER
DROP USER c##bituser CASCADE; -- CASCADE 연결된 모든 것을 함께 삭제

-- 다시 생성
CREATE USER c##bituser IDENTIFIED BY bituser;

-- 사용자 정보 확인
-- USER_ : 현재 사용자 관련
-- ALL_ : 전체의 객체
-- DBA_ : DBA 전용, 객체의 모든 정보
SELECT * FROM USER_USERS;
SELECT * FROM ALL_USERS;
SELECT * FROM DBA_USERS;

-- 새로 만든 사용자 확인
SELECT * FROM DBA_USERS WHERE username = 'C##BITUSER';

-- 권한(Privilege)과 역할(ROLE)
-- 특정 작업 수행을 위해 적절한 권한을 가져야 한다.
-- CREATE SESSION

-- 시스템 권한을 부여 : GRANT 권한 TO 사용자
-- C##BITUSER에게 CREATE SESSION 권한을 부여
GRANT create session TO C##BITUSER;

-- 일반적으로 CONNECT, RESOURCE 롤을 부여하면 일반사용자의 역할 수행 가능
GRANT connect, resource TO C##BITUSER;

-- Oracle 12 이후로는 임의로 TABLESPACE를 할당 하여야 함
ALTER USER C##BITUSER               -- 사용자 정보 수정
    DEFAULT TABLESPACE USERS        -- 기본 테이블 스페이스를 USERS에 지정
    QUOTA UNLIMITED ON USERS;       -- 사용 용량 지정
    
-- 객체 권한 부여
-- C##BITUSER 사용자에게 HR.employees를 SELECT 할 수 있는 권한 부여
GRANT select ON HR.EMPLOYEES TO C##BITUSER;
-- 객체 권한 회수
REVOKE select ON HR.EMPLOYEES FROM C##BITUSER;
GRANT select ON HR.EMPLOYEES TO C##BITUSER;
-- 전체 권한 부여시
-- GRANT all privileges ... 

-------------
-- DDL
-------------
-- 이후 C##BITUSER로 진행

-- 현재 내가 소유한 테이블 목록 확인
SELECT * FROM tab;
-- 현재 나에게 주어진 ROLE을 조회
SELECT * FROM USERS_ROLE PRIVS;

-- CREATE TABLE: 테이블 생성
CREATE TABLE book (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT SYSDATE
);

SELECT * FROM tab;
DESC book;

-- 서브퀘리를 이용한 테이블 생성
-- HR 스키마의 employees 테이블의 일부 데이터를 추출, 새 테이블 생성
SELECT * FROM HR.employees;

-- job_id가 IT_ 관련 직원들만 뽑아내어 새 테이블 결정
CREATE TABLE it_emps AS (
    SELECT * FROM HR.employees WHERE job_id LIKE 'IT_%'
);
    
DESC IT_EMPS;
SELECT * FROM IT_EMPS; -- 삭제

-- author 테이블 추가
-- 테이블 제약은 모든 컬렁 정의가 끝난 다음에 뒤쪽에다가 붙인다
-- author_id를 PK로 지정
CREATE TABLE author (
    author_id NUMBER(10),
    author_name VARCHAR2(50) NOT NULL, -- 컬럼 제약
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id) -- 테이블 제약
    );
DESC author;    
-- book 테이블의 author 컬럼 지우기
-- 나중에 author 테이블과 FK 연결
DESC book;
ALTER TABLE book DROP COLUMN author;

-- author 테이블 참조를 위한 컬럼 author_id 추가
ALTER TABLE book
ADD (author_id NUMBER(10));

-- book 테이블의 book_id도 NUMBER(10)으로 변경
ALTER TABLE book MODIFY (book_id NUMBER(10));