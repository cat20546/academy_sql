-- 실습1)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
  FROM EMP e
ORDER BY SAL DESC;

-- 실습2)
SELECT e.EMPNO
     , e.ENAME
     , e.HIREDATE
  FROM emp e
ORDER BY HIREDATE ASC;

-- 실습3)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
ORDER BY COMM ASC;

-- 실습4)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
ORDER BY COMM DESC;
