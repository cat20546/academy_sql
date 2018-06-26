-- 실습1)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
  FROM EMP e
ORDER BY e.SAL DESC;

-- 실습2)
SELECT e.EMPNO
     , e.ENAME
     , e.HIREDATE
  FROM emp e
ORDER BY e.HIREDATE ASC;

-- 실습3)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
ORDER BY e.COMM ASC;

-- 실습4)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
ORDER BY e.COMM DESC;

-- 실습5)
SELECT e.EMPNO    as "사번"
     , e.ENAME    as "이름"
     , e.SAL      as "급여"
     , e.HIREDATE as "입사일"
  FROM EMP e
  ;
  
-- 실습6)
SELECT *
  FROM emp
;

-- 실습7)
SELECT *
  FROM emp
WHERE ENAME = 'ALLEN'
;

-- 실습8)
SELECT e.EMPNO
     , e.ENAME
     , e.DEPTNO
  FROM emp e
WHERE DEPTNO = 20
;

-- 실습9)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , e.DEPTNO
  FROM emp e
WHERE DEPTNO = 20 AND SAL <3000
;  

-- 실습10)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL + e.COMM
  FROM emp e
;

-- 실습11)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL*12
  FROM emp e
;

-- 실습12)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.COMM
  FROM emp e
WHERE ename = 'MARTIN' 
   OR ename = 'BLAKE'
;

-- 실습13)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL + nvl(e.COMM,0)
  FROM emp e
WHERE ename = 'MARTIN' or ename = 'BLAKE'
;

-- 실습14)
SELECT *
  FROM emp e 
WHERE comm <> 0
;

SELECT *
  FROM emp e 
WHERE comm != 0
;

SELECT *
  FROM emp e 
WHERE comm > 0
;

-- 실습15)
SELECT *
  FROM emp e
WHERE COMM is not null
;
-- 커미션에 0 포함됨

-- 실습16)
SELECT *
  FROM emp e
WHERE e.deptno=20 
  and e.sal > 2500
;

-- 실습17)
SELECT *
  FROM emp e
WHERE e.job = 'MANAGER' 
   or e.deptno = 10
;

-- 실습18)
SELECT *
  FROM emp e
WHERE e.JOB IN('MANAGER', 'CLERK', 'SALESMAN')
;


-- 실습19)
SELECT *
  FROM emp e
WHERE ENAME LIKE 'A%'
;

-- 실습20)
SELECT *
  FROM emp e
WHERE ENAME LIKE '%A%'
;

-- 실습21)
SELECT *
  FROM emp e
WHERE ENAME LIKE '%S'
;


-- 실습22)
SELECT *
  FROM emp e
WHERE ENAME LIKE '%E_'
;

-- 실습23)
SELECT *
  FROM emp e
WHERE e.SAL between 2500
  AND 3000
;

-- 실습24)
SELECT *
  FROM emp e
WHERE e.COMM 
is NULL
;

-- 실습25)
SELECT *
  FROM emp e
WHERE e.COMM 
is NOT NULL
;

-- 실습26)
SELECT e.EMPNO as "사번"
     , e.ENAME || '의 월급은 $' || e.SAL || ' 입니다.' as "월급여"
  FROM emp e
WHERE e.ENAME = 'SMITH'
   OR e.ENAME = 'ALLEN'
   OR e.ENAME = 'WARD'
   OR e.ENAME = 'JONES'
;

select*from emp;


