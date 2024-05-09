-- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터비이스 사용 선언
USE sakila;

-- 데이터베이스 내에 어떤 테이블이 있는가?
SHOW TABLES;

-- 테이블 구조 확인
DESCRIBE actor;

-- 간단한 쿼리 실행
SELECT VERSION(), CURRENT_DATE;
SELECT version(), current_date FROM dual; -- dual : 시스템 정보 가상 테이블

-- 특정 테이블 데이터 조회alter
SELECT * FROM actor;

-- 데이터베이스 생성
-- webdb 데이터베이스 생성
CREATE database webdb;
-- 시스템 설정에 좌우되는 경우가 많음
-- 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋다
drop database webdb;
create database webdb charset utf8mb4
	collate utf8mb4_unicode_ci;
show databases;

-- 사용자 만들기
create user 'dev'@'localhost' identified by 'dev';
-- 사용자 비밀번호 변경
-- alter user 'dev'@'localhost' identified by 'new_password'; 
-- 사용자 삭제
-- drop user 'dev'@'localhost'; 

-- 권한 부여
-- GRANT 권한 목록 ON 객채 TO '계정'@'접속호스트';
-- 권한 회수
-- REVOKE 권한 목록 ON 객채 FROM '계정'@'접속호스트';

-- 'dev'@'localhost'에게 webdb 데이터베이스의 모든 객체에 대한 모든 권한 허용
GRANT ALL privileges ON webdb.* TO 'dev'@'localhost';
-- revoke all privileges on webdb.* FROM 'dev'@'localhost';

-- 데이터베이스 확인
show databases;

use webdb;

-- author 테이블 생성
create table author (
	author_id int primary key,
    author_name varchar(50) not null,
    author_desc varchar(500)
);

show databases;
desc author;

-- 테이블 생성 정보
show create table author;

-- book 테이블 생성
create table book (
	book_id int primary key,
    title varchar(100) not null,
    pubs varchar(100),
    pub_date datetime default now(),
    author_id int,
    constraint fk_book foreign key(author_id)
    references author(author_id)
);

show tables;
desc book;

-- INSERT : 새로운 레코드 삽입
-- 묵시적 방법 : 컬럼 목록 제공하지 않음 -> 선언된 컬럼의 순서대로
insert into author values (1, '박경리', '토지 작가');

-- 명시적 방법 : 컬럼 목록 제공, 컬럼 목록의 숫자, 순서, 타입이
-- 값목록의 숫자, 순서, 타입과 일치해야 함
insert into author (author_id, author_name)
values (2, '김영하');

select * from author;
-- MYSQL은 기복적으로 자동 커밋이 활성화
-- autocommit을 비활성화 autocommit 옵션을 0으로 설정
set autocommit = 0;

-- MySQL은 명시적 트래ㅑㄴ잭션을 수행
start transaction;
select * from author;

-- update author;
-- set author_desc = '알쓸신잡 출연';	--	WHERE 절이 없으면 전체 레코드 변경

update author
set author_desc = '알쓸신잡 출연'
where author_id = 2;

select * from author;

commit; -- 변경사항 영구 반영
-- rollback; -- 변경사항 반영 취소

select * from author;

-- AUTO_INVREMENT 속성
-- 연속된 순차정보, 주로 PK 속성에 사용

-- author 테이블의 PK에 autho_increment 속성 부여
alter table author modify 
	author_id int auto_increment primary key;

-- 1. 외래 키 정보 확인
SELECT * 
FROM information_schema.KEY_COLUMN_USAGE;

select constraint_name
from information_schema.KEY_COLUMN_USAGE
where table_name = 'book';

-- 2. 외래 키 삭제 : book 테이블의 FK (fk_book)
alter table book drop foreign key fk_book;

-- 3. author의 PK에 AUTO_INCREMENT 속성 부여
-- 기존 PK 삭제 
alter table author drop primary key;
-- AUTO_INVREMENT 속성이 부여된 새로운 PRIMARY KEY 생성
alter table author modify author_id int auto_increment primary key;

-- 4. book의 author_id에 FOREIGN KEY 다시 연결
alter table book 
add constraint fk_book 
foreign key (author_id) references author(author_id);

-- autocommit 다시 켜주기
set autocommit = 1;

select * from author;

-- 새로운 AUTO_INCREMENT값을 부여하기 위해 PK 최댓값을 구함
SELECT MAX(author_id) FROM author;

-- 새로 생성되는 AUTO_INCREMENT 시작 값을 변경
alter table author AUTO_INCREMENT = 3;	--	3부터 시작함

-- 테이블 구조 확인
desc author;

select * from author;

insert into author (author_name) values('스티븐 킹');
insert into author (author_name, author_desc) values('박상수', '안압 환자');

select * from author;

-- 테이블 생성시 AUTO_INCREMENT 속성을 부여하는 방법

-- 1	박경리	토지 작가
-- 2	김영하	알쓸신잡 출연
-- 3	스티븐 킹	
-- 4	박상수	안압 환자

drop table book cascade;

create table book (
	book_id int auto_increment primary key,
    title varchar(100) not null,
    pubs varchar(100),
    pub_date datetime default now(),
    author_id int,
    constraint book_fk foreign key (author_id)
						references author(author_id)
);

insert into book (title, pub_date, author_id) 
values ('토지', '1994-03-04', 1);
insert into book (title, author_id) 
value ('살인자의 기억법', 2);
insert into book (title, author_id) 
value ('쇼생크 탈출', 3);
insert into book (title, author_id) 
value ('베트남 10년 후회만 남았다', 4);

select * from book;

-- JOIN 
select title 제목, pub_date 출판일, author_name 저자명, author_desc '저자 상세'
from book b JOIN author a ON a.author_id = b.author_id;



