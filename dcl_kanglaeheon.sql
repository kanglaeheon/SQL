-- kanglaeheon 계정 DCL

-- 사용자 생성
CREATE USER C##kanglaeheon IDENTIFIED BY 4307;

-- 로그인에 필요한 세션 권한 부여
GRANT create session to C##KANGLAEHEON;

--  테이블 스페이스 할당
ALTER USER C##KANGLAEHEON
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

--  전체 권한 부여    
GRANT all privileges TO C##KANGLAEHEON;

SELECT * FROM tab;

-- DB restaurants 테이블 생성
CREATE TABLE restaurants ( 
    rest_no NUMBER PRIMARY KEY,
    rest_name VARCHAR2(100),
    rest_score_y NUMBER(10),
    rest_score_k NUMBER(10),
    rest_address VARCHAR2(500),
    rest_tel VARCHAR2(50),
    rest_open_day VARCHAR2(50),
    rest_comment VARCHAR2(500),
    rest_create_date DATE DEFAULT SYSDATE );
    
SELECT * FROM restaurants;

COMMIT;

CREATE SEQUENCE seq_restaurants_pk
	START WITH 1
	INCREMENT BY 1;
    
INSERT INTO restaurants (
    rest_no,
    rest_name,
    rest_score_y,
    rest_score_k,
    rest_address,
    rest_tel,
    rest_open_day,
    rest_comment)
VALUES (
    seq_restaurants_pk.NEXTVAL,
    '래헌이 집',
    5,
    5,
    '서울특별시 강남구 논현로117길 24, 꿈꾸지오 403호',
    '010-4554-4307',
    '일월화수목금토',
    '밥먹자!'
    );