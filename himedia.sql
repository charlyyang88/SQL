DESC author;
DESC book;

SELECT * FROM author;

SELECT * FROM user_objects WHERE OBJECT_TYPE = 'SEQUENCE';

DELETE FROM author;
COMMIT;

SELECT * FROM author;

-- JAVA : author DTO(VO객체) 생성

-- LIST
SELECT author_id, author_name, author_desc FROM author;



-- oracle 미니 프로젝트
-- TABLE 
CREATE TABLE PHONE_BOOK (
    phone_id NUMBER(10) PRIMARY KEY,
    phone_name VARCHAR2(10),
    phone_hp VARCHAR2(20),
    phone_tel VARCHAR2(20)
);

drop table PHONE_BOOK;

CREATE SEQUENCE id_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

drop SEQUENCE id_seq;
