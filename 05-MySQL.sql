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







