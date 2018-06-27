-- 실습1)
SELECT INITCAP(e.ENAME)
  FROM emp e
;

-- 실습2)
SELECT LOWER(e.ENAME)
  FROM emp e
; 

-- 실습3)
SELECT UPPER(e.ENAME)
  FROM emp e
;

-- 실습4)
SELECT LENGTH('korea')
  FROM dual
;

SELECT LENGTHB('korea')
  FROM dual
  ;
  
-- 실습5)
SELECT LENGTH('윤홍식')
  FROM dual
;

SELECT LENGTHB('윤홍식')
  FROM dual
;

-- 실습6)
SELECT CONCAT('SQL','배우기')
  FROM DUAL
;

-- 실습7)
SELECT SUBSTR('SQL 배우기',5,2)
  FROM DUAL
;

-- 실습8)
SELECT LPAD('SQL',7,'$')
  FROM DUAL
;

-- 실습9)
SELECT RPAD('SQL',7,'$')
  FROM DUAL
;

-- 실습10)
SELECT LTRIM('   sql배우기 ')
  FROM DUAL
;

-- 실습11)
SELECT RTRIM('   sql배우기 ')
  FROM DUAL
;

-- 실습12)
SELECT TRIM('   sql배우기 ')
  FROM DUAL
;

-- 실습13)
SELECT NVL(e.COMM,0)
  FROM emp e
;

-- 실습14)
SELECT NVL2(e.COMM,SAL+COMM,0)
  FROM emp e
;

-- 실습15)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL AS "급여"
     , TO_CHAR(DECODE(e.JOB --expr
            ,'CLERK',300 
            ,'SALESMAN',450 
            ,'MANAGER', 600
            ,'ANALYST', 800
            ,'PRESIDENT', 1000 ),'$9999') as "자기 계발비"
  FROM emp e
;

SELECT*FROM EMP;