-- SQL day02
-------------------------------------------------------------------------------
--- IS NULL, IS NOT NULL 연산자
/*
IS NULL : 비교하려는 컬럼의 값이 NULL 이면 true, NULL이 아니면 false
IS NUT NULL : 비교하려는 커럶의 값이 NULL 이 아니면 true, NULL 이면 false

NULL 값의 컬럼은 비교 연산자와 연산이 불가능 하므로
NULL 값 비교 연산자가 따로 존재함

col1 = null   ==> NULL 값에 대해서는 = 비교 연산자 사용 불가능
col1 != null  ==> NULL 값에 대해서는 !=, <> 비교 연산자 사용 불가능
*/

--- 27) 어떤 직원의 mgr가 지정되지 않은 직원 정보 조회
SELECT e.EMPNO
     , e.ENAME
     , e.MGR
  FROM  emp e
WHERE e.MGR IS NULL  -- e.MGR = NULL을 쓸수 없다.
;
/*
EMPNO,  ENAME,    MGR
------------------------
7839	KING	
9999	J_JUNE	
8888	J	
7777	J%JONES	
*/

--- mgr이 배정된 직원 정보 조회
SELECT e.EMPNO
     , e.ENAME
     , e.MGR
  FROM  emp e
WHERE e.MGR IS NOT NULL 
;
-- e.MGR != NULL을 쓸수 없음 주의
-- e.MGR <> NULL을 쓸수 없음 주의

/*
EMPNO, ENAME,    MGR
7369	SMITH	7902
7499	ALLEN	7698
7521	WARD	7698
7566	JONES	7839
7654	MARTIN	7698
7698	BLAKE	7839
7782	CLARK	7839
7844	TURNER	7698
7900	JAMES	7698
7902	FORD	7566
7934	MILLER	7782
*/

---BETWEEN ~ AND ~ : 범위 비교 연산자 범위 포함
-- a <= sal <= b  : 이러한 범이ㅜ 연산과 동일
--- 28) 급여가 500~1200 사이인 직원 정보 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
WHERE e.SAL BETWEEN 500 AND 1200  
;
/*
EMPNO,  ENAME,  SAL
-----------------------
7369	SMITH	800
7900	JAMES	950
9999	J_JUNE	500
7777	J%JONES	500
*/

-- BETWEEN 500 AND 1200 과 같은 결과를 내는 비교연산자
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
WHERE e.SAL>=500
  AND e.SAL<=1200
;

-- IS NOT NULl 대신 <>, != 연산자를 사용한 경우의 조회 결과 비교
SELECT e.EMPNO
     , e.ENAME
     , e.MGR
  FROM emp e
 WHERE e.MGR <> NULL
 ;
 --> 인출된 모든 행 : 0
 --> 실행에 오류는 업싲만 올바른 결과가 아님
 --> 이런 경우는 오류를 찾기가 어렵기 때문에 NULL데이터는 항상 주의

--- EXISTS 연산자 : 조회한 결과가 1행 이상 있다.
--                 어떤 SELECT 구문을 실행했을 때 조회 결과가 1행 이상 있으면
--                 이 연산자의 결과가 true
--                 조회 결과 : <인출된 모든 행 : 0> 인 경우 false
--                 따라서 서브쿼리와 함께 사용됨

--- 29) 급여가 10000이 넘는 사람이 있는가?
--  (1) 급여가 1000이 넘는 사람을 찾는 구문을 작성
SELECT e.ENAME
  FROM emp e
 WHERE e.SAL > 10000
 ;
 
 /*
 위의 쿼리 실행 결과가 1행 이라도 존재하면 화면에
 "급여기 1000이 넘는 직원이 존재하지 않음" 이라고 출력
 */
 
 SELECT '급여가 3000이 넘는 직원이 존재함' as "시스템 메시지"
   FROM dual
 WHERE NOT EXISTS (SELECT e.ENAME
                  FROM emp e
                 WHERE e.SAL > 10000)
 ;
 
 -- (6) 연산자 : 결삽연산자(||)
 -- 오라클에만 존재, 문자열 결합(접합)
 -- 다른 자바 등의 프로그래밍 언어에서는 OR 논리 연산자로 사용되므로
 -- 혼동에 주의
 
 -- 오늘의 날짜를 화면에 조회
 SELECT sysdate
   FROM dual


-- 오늘의 날짜를 알려주는 문장을 만들려면
SELECT '오늘의 날짜는' || SYSDATE || ' 입니다.' as "오늘의 날짜"
  FROM dual
;

-- 직원의 사번을 알려주는 구문을 || 연산자를 사용하여 작성
SELECT '안녕하세요.' ||  e.ENAME || '씨, 당신의 사번은 '
                   || e.EMPNO  || ' 입니다.' as " 사번 아리미"
  FROM emp e
; 

-- (6) 연산자 : 6. 집합 연산자
-- 첫번째 쿼리 
SELECT *
  FROM dept d
;

-- 두번째 쿼리 : 부서번호가 10번인 부서정보만 조회
SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 1) UNION ALL : 두 집합의 중복데이터 허용하여 합집합
SELECT *
  FROM dept d
 UNION ALL
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 2)UNION 중복을 제거한 합집합
SELECT *
  FROM dept d
 UNION
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 3)INTERSECT : 중복된 데이터만 남김 (교집합)
SELECT *
  FROM dept d
 INTERSECT
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 4)MINUS : 첫번째 쿼리 실행 결과에서 두번째 쿼리 실행결과를 뺀 차집합
SELECT *
  FROM dept d
 MINUS
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 주의 ! : 각 쿼리 조회 결과의 컬럼 갯수, 데이터 타입이 서로 일치해야 함
-- (6) 연산자 : 6. 집합 연산자
-- 첫번째 쿼리 
SELECT *
  FROM dept d
;

-- 두번째 쿼리 : 부서번호가 10번인 부서정보만 조회
SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 1) UNION ALL : 두 집합의 중복데이터 허용하여 합집합
SELECT *
  FROM dept d
 UNION ALL
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 2)UNION 중복을 제거한 합집합
SELECT *
  FROM dept d
 UNION
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 3)INTERSECT : 중복된 데이터만 남김 (교집합)
SELECT *
  FROM dept d
 INTERSECT
 SELECT *
  FROM dept d
 WHERE d.DEPTNO = 10
;

-- 4)MINUS : 첫번째 쿼리 실행 결과에서 두번째 쿼리 실행결과를 뺀 차집합
SELECT *
  FROM dept d
 UNION ALL
SELECT d.DEPTNO
     , d.DNAME
  FROM dept d
 WHERE d.DEPTNO = 10
;
-- ORA-01789: query block has incorrect number of result columns

SELECT d.DNAME  --문자형 데이터
     , d.DEPTNO --숫자형 데이터
  FROM dept d
 UNION ALL
SELECT d.DEPTNO --숫자형 데이터
     , d.DNAME  --문자형 데이터
  FROM dept d
WHERE d.DEPTNO = 10
;

-- ORA-01790: expression must have same datatype as corresponding expression

-- 서로 다른 테이블에서 조회한 결과를 집합연산 가능
-- 첫번째 쿼리 : emp 테이블에서 조회
SELECT e.EMPNO --숫자
     , e.ENAME --문자
     , e.JOB   --문자
  FROM emp e
;

-- 두 번째 쿼리 : dept 테이블에서 조회
SELECT d.DEPTNO --숫자
     , d.DNAME  --문자
     , LOC --문자
  FROM dept d
;

-- 서로 다른 테이블의 조회 내용을 UNION
SELECT e.EMPNO --숫자
     , e.ENAME  --문자
     , e.JOB --문자
  FROM emp e
UNION
SELECT d.DEPTNO --숫자
     , d.DNAME  --문자
     , LOC --문자
  FROM dept d
;
/%
%/

-- 서로다른 테이블의 조회 내용을 MINUS
SELECT e.EMPNO --숫자
     , e.ENAME  --문자
     , e.JOB --문자
  FROM emp e
MINUS
SELECT d.DEPTNO --숫자
     , d.DNAME  --문자
     , LOC --문자
  FROM dept d
;

-- 서로다른 테이블의 조회 내용을 INTERSECT
SELECT e.EMPNO --숫자
     , e.ENAME  --문자
     , e.JOB --문자
  FROM emp e
INTERSECT
SELECT d.DEPTNO --숫자
     , d.DNAME  --문자
     , LOC --문자
  FROM dept d
;

-- 조회 결과 없음 : 인출된 모든 행 : 0
-- no rows selected

-- (6) 연산자 : 7. 연산자 우선순위
/*
주어진 조건 3가지
1. mgr = 7698
2. job = 'CLERK'
3. sal > 1300
*/

-- 1) 매니저가 7698 번이며, 직무는 CLERK 이거나 
--    급여가 1300이 넘는 조건을 만족하는 직원의 정보를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.MGR
  FROM emp e
WHERE e.MGR=7698 
  AND e.JOB='CLERK' 
  OR e.SAL>1300
;

/*
EMPNO,   ENAME,    JOB,     SAL,     MGR
--------------------------------------------
7499	ALLEN	SALESMAN	1600	7698
7566	JONES	MANAGER	    2975	7839
7698	BLAKE	MANAGER	    2850	7839
7782	CLARK	MANAGER	    2450	7839
7839	KING	PRESIDENT	5000	
7844	TURNER	SALESMAN	1500    7698
7900	JAMES	CLERK	    950	    7698
7902	FORD	ANALYST    	3000	7566
*/

-- 2) 매니저가 7698번인 직원중에서
--    직무가 CLERK 이거나 급여가 1300이 넘는 조건을 만족하는 직원 정보
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.MGR
  FROM emp e
WHERE MGR=7698 
  AND (e.JOB='CLERK' or e.SAL>1300) 
;

/*
EMPNO,   ENAME,    JOB,     SAL,    MGR
-----------------------------------------
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
*/

-- 3) 직무가 CLERK이거나 
--    급여가 1300이 넘으면서 매니저가 7698인 직원 정보 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.MGR
  FROM emp e
WHERE JOB = 'CLERK' 
   OR (e.SAL >1300 AND MGR=7698)
;
--AND연산자가 OR연산자 보다 우선순위가 높다
-- 두번째 처럼 괄호를 사용하지 않아도 수행 결과는 같아짐

/*
EMPNO,  ENAME,    JOB,       SAL,    MGR
--------------------------------------------
7369	SMITH	CLERK	    800	    7902
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7934	MILLER	CLERK	    1300	7782
9999	J_JUNE	CLERK	    500	
8888	J	    CLERK	    400	
7777	J%JONES	CLERK	    500	
*/

----------- 6. 함수
-- (2) dual 테이블 : 1행 1열로 구성된 시스템 테이블
DESC dual;  --> 문자데이터 1칸으로 구성된 dummy 컬럼을 가진 테이블
DESC emp; 

select *    --> dummy 컬럼에 X 값이 하나 들어있음을 확인할 수 있다.
  from dual
;

--dual 테이블을 사용하여 날짜 조회
SELECT sysdate
  FROM dual
;

-- (3) 단일행 함수
--- 1) 숫자함수 : 1. MOD(m, n) : m을 n으로 나눈 나머지 계산함수
SELECT mod(10,3) as "result"
  FROM dual
;

SELECT mod(10,3) as "result"
  FROM emp 
;

SELECT mod(10,3) as "result"
  FROM dept
;

-- 각 사원의 급여를 3으로 나눈 나머지를 조회 
SELECT e.EMPNO
     , e.ENAME
     , MOD(e.SAL, 3) as "RESULT"
  FROM emp e
;

-- 단일행 함수는 테이블 1행당 1번씩 적용

---- 2. ROUND(m, n) : 실수 m 을 소수점 n + 1 자리에서 반올림 한 결과를 계산
SELECT ROUND(1234.56, 1) FROM dual; -- 1234.6
SELECT ROUND(1234.56, 0) FROM dual; -- 1235
SELECT ROUND(1234.46, 0) FROM dual; -- 1234
-- ROUND(m) : n 값을 생략하면 소수점 이하 첫째자리 반올림 바로 수행
--            즉, n 값을 0으로 수행함
SELECT ROUND(1234.46) FROM dual; --1234
SELECT ROUND(1234.56) FROM dual; --1235

---- 3. TRUNC(m, n) : 실수 m을 n에서 지정한 자리 이하 소수점 버림
SELECT TRUNC(1234.56, 1) FROM dual; --1234.5
SELECT TRUNC(1234.56, 0) FROM dual; --1234
--      TRUNC(m)    : n을 생략하면 0으로 수행
SELECT TRUNC(1234.56) FROM dual; --1234

---- 4. CEIL(n) : 입력된 실수 n에서 같거나 가장 큰 가까운 정수
SELECT CEIL(1234.56) FROm dual;  -- 1235
SELECT CEIL(1234) FROM dual;     -- 1234
SELECT CEIL(1234.001) FROM dual; -- 1235

---- 5. FLOOR(n) : 입력된 실수 n에서 같거나 가장 가까운 작은 정수
SELECT FLOOR(1234.56) FROM dual; --1234
SELECT FLOOR(1234) FROM dual;    --1234
SELECT FLOOR(1235.56) FROM dual; --1235

---- 6. WIDTH_BUCKET(expr, min, max, buckets)
-- : min, max 값 사이를 buckets 개수만큼의 구간으로 나누고
-- expr이 출력하는 값이 어느 구간인지 위치를 숫자로 구해줌

-- 급여 범위를 0 ~ 5000 으로 잡고, 5개의 구간으로 나누어서
-- 각 지원의 급여가 어느 구간에 해당하는지 보고서를 출력해보자.
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , WIDTH_BUCKET(e.SAL, 0, 5000, 5) as "급여 구간"
  FROM emp e
ORDER BY "급여 구간" DESC
;

--- 2) 문자함수
