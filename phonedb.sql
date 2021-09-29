-- TABLE
DESC PHONE_BOOK;

CREATE TABLE PHONE_BOOK (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(10),
    hp VARCHAR2(20),
    tel VARCHAR2(20)
    );

CREATE SEQUENCE seq_phone_book
    START WITH 1
    INCREMENT BY 1 NOCACHE
    MAXVALUE 1000
    MINVALUE 1;
    
SELECT * FROM user_sequences;

DROP SEQUENCE seq_phone_book;

COMMIT;

SELECT * FROM PHONE_BOOK;

DROP TABLE phone_book;

-- 시퀀스 보는 구문 추가 할 것ㅎ