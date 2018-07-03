-- 실습3)
SELECT e.ename
  FROM emp e, dept d
 WHERE e.deptno = d.deptno(+) and mgr is null 
;

-- 실습4)
SELECT e.ename
  FROM emp e, dept d
 WHERE e.deptno = d.deptno(+) and e.job = 'CLERK'
;

-- 실습5)
 SELECT e.ename
   FROM emp e
  WHERE e.job = (SELECT e.job
                 FROM emp e 
                WHERE ename = 'JAMES')
   ;
---DDL-----------------------------------------

-- 실습1)
CREATE TABLE CUSTOMER(
  userid     varchar2(50)
, name       varchar2(50)
, birthyear  date
, regdate    date
, address    varchar2(50)
);

-- 실습2)
DESC CUSTOMER;

-- 실습3)
CREATE TABLE NEW_CUST
AS
SELECT *
  FROM CUSTOMER
 WHERE 1=0
;

-- 실습4)
DESC NEW_CUST;

-- 실습5)
CREATE TABLE salesman
AS
SELECT *
  FROM emp
 WHERE JOB='SALESMAN'
;

-- 실습6)
SELECT*
  FROM SALESMAN
;

-- 실습7)
ALTER TABLE CUSTOMER ADD phone number;
ALTER TABLE CUSTOMER ADD grade char;

-- 실습8)
ALTER TABLE CUSTOMER DROP COLUMN grade;

-- 실습9)
ALTER TABLE CUSTOMER MODIFY phone char(10);
ALTER TABLE CUSTOMER MODIFY userid VARchar2(40);