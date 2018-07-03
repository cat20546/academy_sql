---DML---------------------------
-- 실습1)
INSERT INTO "CUSTOMER" (USERID, NAME, BIRTHYEAR, REGDATE, ADDRESS)
VALUES('C001', '김수현', TO_DATE('1988','YYYY') , SYSDATE ,'경기');

INSERT INTO "CUSTOMER" (USERID, NAME, BIRTHYEAR, REGDATE, ADDRESS)
VALUES('C002', '이효리', TO_DATE('1979','YYYY') , SYSDATE ,'제주');

INSERT INTO "CUSTOMER" (USERID, NAME, BIRTHYEAR, REGDATE, ADDRESS)
VALUES('C003', '원빈', TO_DATE('1977','YYYY') , SYSDATE ,'강원');

DESC CUSTOMER;

-- 실습2)
UPDATE CUSTOMER c
   SET c.name = '차태현'
 WHERE c.userid = 'C001'
 ;

-- 실습3) 
 UPDATE CUSTOMER c
    SET c.address = '서울'
;

-- 실습4)
DELETE 
  FROM CUSTOMER c
 WHERE c.userid = 'C003'
;

-- 실습5)
DELETE
  FROM CUSTOMER c
;

-- 실습6)
TRUNCATE TABLE CUSTOMER;

--- SEQUENCE
-- 실습1)

CREATE SEQUENCE "seq_cust_userid"
start with 1
maxvalue 99
minvalue 1
nocycle
;

-- 실습2)
SELECT c.SEQUENCE_NAME
     , c.MAX_VALUE
     , c.MIN_VALUE
     , c.CYCLE_FLAG
  FROM user_sequences c
   WHERE c.SEQUENCE_NAME = 'seq_cust_userid'
;

-- 실습3)
CREATE INDEX idx_cust_userid
ON customer(userid)
;

DESC IDX_CUST_USERID;

-- 실습4)
desc user_indexes;

-- 실습5)
desc user_ind_columns;

-- 실습6)
SELECT i.INDEX_NAME  
  FROM USER_IND_COLUMNS i
;  

-- 실습7)
DROP index idx_cust_userid;

-- 실습8)
SELECT i.InDEX_NAME
     , i.Table_name
  FROM USER_IND_COLUMNS i
;






-- 실습4)

SHOW SERVEROUTPUT;
SET SERVEROUTPUT ON
;

-- 실습1)
BEGIN
     Dbms_Output.Put_Line('Hello, PL/SQL World!');
END;
/

-- 실습2)
DECLARE
    PL varchar2(50) := 'Hello, PL/SQL World';
BEGIN
    Dbms_Output.Put_Line(PL);
END;
/

-- 실습3)
-- 1. log_table 테이블 생성
create table log_table(
  userid    VARCHAR2(20)
 ,log_date   DATE
);

-- 2. 프로시저 생성
CREATE OR REPLACE PROCEDURE log_execution
IS
 v_userid VARCHAR2(20) := 'myid';
BEGIN
    INSERT into log_table
    values(v_userid, sysdate);
END log_execution;
/

-- 3. EXECUTE 실행
EXEC log_execution;

-- 실습4)
-- 1. 프로시저 생성
CREATE OR REPLACE PROCEDURE log_execution
 (v_log_user     IN   VARCHAR2
 , v_log_date    OUT  VARCHAR2
 )
IS

BEGIN
        v_log_date := SYSDATE;
     DBMS_OUTPUT.PUT_LINE(v_log_user||v_log_date);
END log_execution;
/

-- 2) 실행을 위해
--- a. BIND 변수를 선언 : SQL*PLUS 의 변수
--     VAR(IABLE] 바인드변수이름 타입
VAR v_log_result VARCHAR2
--- b. EXECUTE 로 SP 실행
EXECUTE log_execution('유재성', :v_log_result);

---- c. PRINT로 BIND 변수를 출력
PRINT v_log_result