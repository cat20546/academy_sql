-- sql day01
-- 1. SCOTT ���� Ȱ��ȭ : sys �������� �����Ͽ� ��ũ��Ʈ ����
@:C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
-- 2. ���� ���� Ȯ�� ���
show user
-- 3. HR ���� Ȱ��ȭ : sys  �������� �����Ͽ� 
--                   �ٸ� ����� Ȯ�� �� HR ������
--                   �������, ��й�ȣ ���� ���� ����
--------------------------------------------------------------


-- 01. EMP ���̺� ���� ��ȸ
select *
from emp
;
/* ----------------------------------------------------------------
EMPNO   ENAME    JOB         MGR    HIREDATE    SAL    COMM   DEPTNO
7369	SMITH	CLERK	    7902	80/12/17	800		20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	    30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	    30
7566	JONES	MANAGER	    7839	81/04/02	2975		    20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10
7839	KING	PRESIDENT		    81/11/17	5000		    10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	    30
7900	JAMES	CLERK	    7698	81/12/03	950		30
7902	FORD	ANALYST	    7566	81/12/03	3000		    20
7934	MILLER	CLERK	    7782	82/01/23	1300		    10
------------------------------------------------------------------*/

-- 02. DEPT ���̺� ���� ��ȸ
SELECT *
  FROM dept
;
/* ----------------------------------------------------------------
DEPTNO    DNAME       LOC
  10	ACCOUNTING	NEW YORK
  20	RESEARCH	DALLAS
  30	SALES	    CHICAGO
  40	OPERATIONS	BOSTON
----------------------------------------------------------------- */

-- 03. SALGRADE ���̺� ���� ��ȸ
SELECT *
  FROM salgrade
;
/* ----------------------------------------------------------------
 GRADE  LOSAL   HISAL
   1	700	    1200
   2	1201	1400
   3	1401	2000
   4	2001	3000
   5	3001	9999
----------------------------------------------------------------- */

-- 01. DQL
-- (1) SELECT ����
-- emp ���̺��� ���, �̸�, ������ ��ȸ
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
  FROM emp e --�ҹ��� e �� alias(��Ī)
 ;
 
-- emp ���̺��� ������ ��ȸ
SELECT e.job
  FROM emp e
;
/*
CLERK
SALESMAN
SALESMAN
MANAGER
SALESMAN
MANAGER
MANAGER
PRESIDENT
SALESMAN
CLERK
ANALYST
CLERK 
*/ 

-- (2) DISTINCT �� : SELECT �� ���� �ߺ��� �����Ͽ� ��ȸ
-- emp ���̺��� job �÷��� �ߺ��� �����Ͽ� ��ȸ
SELECT DISTINCT e.job 
  FROM emp e
;
/*
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST
*/

-- * SQL SELECT ������ �۵� ���� : ���̺��� �� ���� �⺻ ������ ������.
--                              ���̺� ���� ������ŭ �ݺ� ����.
SELECT 'Hello, SQL~' 
  FROM emp e
 ;

-- 3) emp ���̺��� job, deptno �� ���� �ߺ��� �����Ͽ� ��ȸ
SELECT DISTINCT
       e.Job
    ,  e.deptno
    from emp e 
    ;
    
-- 4) ORDER BY �� : ����
-- 5) emp ���̺��� job �� �ߺ������Ͽ� ��ȸ�ϰ� ����� �ù��������� ����
SELECT DISTINCT
       e.JOB
  FROM emp e
  order by e.job
;

-- 6) emp ���̺��� job �� �ߺ������Ͽ� ��ȸ�ϰ� ������������ ����
SELECT DISTINCT
       e.JOB
  FROM emp e
  ORDER BY e.JOB DESC
  ;
  
  /*
  SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
*/

-- 7) emp ���̺��� comm �� ���� ���� �޴� ������� ���
--    ���, �̸�, ����, �Ի���, Ŀ�̼� ������ ��ȸ

SELECT e.empno
     , e.ename
     , e.job
     , e.HIREDATE
     , e.comm
  FROM EMP E
  order by e.COMM DESC
;

-- 8) emp ���̺��� comm �� ���� �������, ������ ��������, �̸��� ������������ ��ȸ
-- ���, �̸�, ����, �Ի���, Ŀ�̼��� ��ȸ
SELECT e.EMPNO      
     , e.ENAME
     , e.JOB
     , e.HIREDATE
     , e.COMM
  FROM emp e
  ORDER BY e.COMM, e.JOB, e.ENAME
;

-- 9) emp ���̺��� comm �� ���� �������, ������ ��������, �̸��� ������������ ����
-- ���, �̸�, ����, �Ի���, Ŀ�̼��� ��ȸ
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.HIREDATE
     , e.COMM
  FROM emp e
ORDER BY e.COMM, e.JOB, e.ENAME DESC
;

