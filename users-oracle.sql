CREATE TABLE users (
	no number PRIMARY KEY,
    name varchar(20) NOT NULL,
    email varchar(128) NOT NULL,
    password varchar(20) NOT NULL,
    gender char(1) DEFAULT 'M' check (gender in ('M', 'F')),
    joindate date DEFAULT sysdate
);

CREATE SEQUENCE seq_users_pk
    START WITH 1 INCREMENT BY 1 NOCACHE;