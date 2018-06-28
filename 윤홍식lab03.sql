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

-- 실습 16)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , CASE e.JOB WHEN 'CLERK' THEN 300
                  WHEN 'SALESMAN' THEN 450
                  WHEN 'MANAGER' THEN 600
                  WHEN 'ANALYST' THEN 800
                  WHEN 'PRESIDENT' THEN 1000
        END as "자기 계발비"
  FROM emp e
;

-- 실습 17)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     ,CASE WHEN e.JOB = 'CLERK'    THEN 300
            WHEN e.JOB = 'SALESMAN' THEN 450
            WHEN e.JOB = 'MANAGER'  THEN 600
            WHEN e.JOB = 'ANALYST'  THEN 800
            WHEN e.JOB = 'PRESIDENT'THEN 1000
            else 0
        end as "자기 계발비"
  FROM emp e  
;

-- 실습 18)
SELECT count(*)
  FROM emp
;

-- 실습 19)
SELECT count(DISTINCT(e.job)) 
  FROM emp e
;

-- 실습 20)
SELECT COUNT(COMM)
  FROM emp e
;

-- 실습 21)
SELECT SUM(SAL)
  FROM emp e
;

-- 실습 22)
SELECT AVG(SAL)
  FROM emp e
;

-- 실습 23)
SELECT SUM(sal)  
     , AVG(sal)
     , MAX(sal)
     , MIN(sal)
  FROM emp e
GROUP BY DEPTNO
HAVING DEPTNO = 20
;

-- 실습 24)
SELECT STDDEV(SAL)
     , VARIANCE(SAL)
  FROM emp d
;
select*from emp;

-- 실습 25)
SELECT STDDEV(SAL)
     , VARIANCE(SAL)
  FROM emp e
 WHERE JOB = 'SALESMAN'
;

select*from emp;
-- 실습 26)
SELECT e.deptno
     , sum(DECODE(e.job
            ,'CLERK',300 
            ,'SALESMAN',450 
            ,'MANAGER', 600
            ,'ANALYST', 800
            ,'PRESIDENT', 1000)) as "자기 계발비"
  FROM emp e
  group by e.deptno
;

-- 실습 27)
SELECT e.deptno
     , e.job
     , sum(DECODE(e.job
            ,'CLERK',300 
            ,'SALESMAN',450 
            ,'MANAGER', 600
            ,'ANALYST', 800
            ,'PRESIDENT', 1000)) as "자기 계발비"
  FROM emp e
  group by e.deptno, e.job
  order by e.deptno asc, e.job desc 
;

-----------------------조인-------------------
-- 실습 1)
SELECT *
  FROM emp e NATURAL JOIN dept d
;

-- 실습 2)
SELECT *
  FROM emp e JOIN dept d USING (deptno)
;
