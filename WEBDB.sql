/* GUESTBOOK */

CREATE TABLE guestbook (
	no number primary key,
    name varchar(20) NOT NULL,
    password varchar(20) NOT NULL,
    content varchar(255) NOT NULL,
    regdate date DEFAULT sysdate
);
​
CREATE SEQUENCE seq_guestbook_no 
    START WITH 1 INCREMENT BY 1 NOCACHE;
​
insert into guestbook (no, name, password, content)
values (seq_guestbook_no.NEXTVAL, '방문자', 'test', '테스트 방명록입니다.');
​
SELECT no, name, password, content FROM guestbook ORDER BY regdate DESC;
commit;

SELECT no,
    name,
    password,
    content,
    regdate as regDate
FROM guestbook
ORDER BY regdate DESC;

insert into guestbook (no, name, password, content)
values (seq_guestbook_no.nextval, '홍길동', '1234', '왔다갑니다');

DELETE FROM guestbook
WHERE no=2 AND password='1234';


/* USERS */

CREATE TABLE users (
	no number PRIMARY KEY,
    name varchar(20) NOT NULL,
    email varchar(128) UNIQUE NOT NULL,
    password varchar(20) NOT NULL,
    gender char(1) DEFAULT 'M' check (gender in ('M', 'F')),
    joindate date DEFAULT sysdate
);

CREATE SEQUENCE seq_users_pk
    START WITH 1 INCREMENT BY 1 NOCACHE;