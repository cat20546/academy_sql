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
---- 1. INITCAP(str) : str 의 첫 글자를 대문자화 (영문인 경우)
SELECT INITCAP('the soap') FROM dual ; -- The Soap
SELECT INITCAP('안녕하세요, 하하') FROM dual ; -- 안녕하세요, 하하

---- 2. LOWER(str) : str 을 소문자화(영문인 경우)
SELECT LOWER('MR. SCOTT MCMILLAN')as "소문자로 변경" FROM dual;

---- 3. UPPER(str) : str 을 대문자화(영문인 경우)
SELECT UPPER('lee') as "성을 대문자로 변경" FROM dual;
SELECT UPPER('sql is coooooooooooooooooool~!!') as "씐나" FROM dual;

---- 4. LENGTH(str), LENGTHB(str) : str의 글자길이를 계산, 글자의 byte를 계산
SELECT LENGTH('hello, sql') FROM dual;
SELECT 'hello, sql의 글자 길이는 ' || LENGTH('hello, sql') || '입니다' as "길자 길이" FROM dual;

-- oracle에서 한글은 3byte로 계산
SELECT LENGTHB('hello, sql') as "글자 byte" FROM dual;
SELECT LENGTHB('오라클') as "글자 byte" FROM dual;

---- 5. CONCAT(str1, str2)
SELECT CONCAT('안녕하세요, ', 'SQL')FROM DUAL;
SELECT '안녕하세요, ' || 'SQL' FROM dual;

---- 6. SUBSTR(str, i, n) : str 에서 i번째 위치에서 n개의 글자를 추출
--      SQL에서 문자열 인덱스를 나타내는 i는 1부터 시작에 주의함!
SELECT SUBSTR('sql is coooooooooool!!', 3, 4) FROM dual;
--      SUBSTR(str, i) : i번째 위치에 문자열 끝까지 추출
SELECT SUBSTR('sql is coooooooooool!!', 3, 4) FROM dual;

--- 7. INSTR(str1, str2) : 2번째 문자열이 1번째 문자열 어디에 위치하는가
--                        등장하는 위치를 계싼
SELECT INSTR('sql is cooooooooooooooooooooool~','is') From dual;
SELECT INSTR('sql is cooooooooooooooooooooool~','ia') From dual;
-- 2번째 문장이 등장하지 않으면 0으로 계산

---- 8. LAD, RPAD(str, n c)
-- : 입력된 str 에 대해서, 전체 글자의 자릿수를 n으로 잡고
--   남는 공간에 왼쪽, 혹은 오른쪽으로 c의 문자를 채워넣는다.
SELECT LPAD('sql is coooooool', 20, '!') FROM dual;
SELECT LPAD('sql is coooooool', 25, '!') FROM dual;

---- 9. LTRIM, RTRIM, TRIM : 입력된 문자열의 왼쪽, 오른쪽, 양쪽 공백 제거
SELECT '>' || LTRIM('     sql is cool    ') || '<' FROM dual;
SELECT '>' || RTRIM('     sql is cool    ') || '<' FROM dual;
SELECT '>' || TRIM('     sql is cool    ') || '<' FROM dual;

----10. NVL(expr1, expr2), NVL2(expr1, expr2, expr3), NULLIF(expr1, expr2)
-- nvl(expr1, expr2) : 첫번째 식의 값이 NULL 이면 두번째 식으로 대체하여 출력
-- mgr 가 배정안된 직원의 경우 '매니저 없음' 으로 변경해서 출력
SELECT e.EMPNO
     , e.ENAME
     , nvl(e.MGR, '매니저 없음') -- mgr 숫자 데이터, 변경 출력이 문자
  From emp e                   -- 타입 불일치로 실행이 안됨
;

SELECT e.EMPNO
     , e.ENAME
     , nvl(e.MGR ||'', '매니저 없음')
     -- || 결합연산자로 빈문자를 붙여서 형변환
  From emp e                   
;

-- nvl2(expr1, expr2, expr3)
--  : 첫번째 식의 값이 NOT NULL이면 두 번째 식의 값으로 대체하여 출력
--                  NULL 이면 세 번째 식의 값으로 대체하여 출력

SELECT e.EMPNO
     , e.ENAME
     , nvl2(e.MGR ||'', '매니저 있음','매니저 없음')
     -- || 결합연산자로 빈문자를 붙여서 형변환
  From emp e                   
;

-- nullif(expr1, expr2)
--  : 첫 번째 식, 두 번째 식의 값이 동일하면 NULL을 출력
--    식의 값이 다르면 첫 번째 식의 값을 출력
SELECT NULLIF('AAA', 'BBB')
  FROM DUAL
;

-- 조회된 결과 1행이 NULL 인 결과를 얻게 됨
-- 1행이라도 NULL이 조회된 결과는 인출된 모든 행 : 0 과는 상태가 다름!


---3) 날짜함수 : 날짜 출력 패턴 조합으로 다양하게 출력 가능
SELECT sysdate FROM dual;

-- TO_CHAR() : 숫자나 날짜를 문자형으로 변환
SELECT TO_CHAR(sysdate,'YYYY') FROM dual;
SELECT TO_CHAR(sysdate,'YY') FROM dual;
SELECT TO_CHAR(sysdate,'MM') FROM dual;
SELECT TO_CHAR(sysdate,'MONTH') FROM dual;
SELECT TO_CHAR(sysdate,'MON') FROM dual;
SELECT TO_CHAR(sysdate,'DD') FROM dual;
SELECT TO_CHAR(sysdate,'D') FROM dual;
SELECT TO_CHAR(sysdate,'DAY') FROM dual;
SELECT TO_CHAR(sysdate,'DY') FROM dual;

-- 패턴을 조합
SELECT TO_CHAR(sysdate,'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate,'FMYYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate,'YY-MONTH-DD') FROM dual;
SELECT TO_CHAR(sysdate,'YY-MONTH-DD DAY') FROM dual;
SELECT TO_CHAR(sysdate,'YYYY-MM-DD DY') FROM dual;

/* 시간 패턴 :
     HH : 시간을 두자리로 표기
     MI : 분을 두자리로 표기
     SS : 초를 두자리로 표기
     HH24 : 시간을 24시간 체계로 표기
     AM : 오전인지 오후인지 표기
*/

SELECT TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD AM HH24:MI:SS') FROM dual;

-- 날짜 값과 숫자의 연산 : +, - 연산 가능
-- 10일 후
SELECT sysdate + 10 FROM dual;
-- 10일 전
SELECT sysdate - 10 FROM dual;
-- 10시간 후
SELECT sysdate + (10/24) FROM dual;
SELECT TO_CHAR(sysdate + (10/24), 'YY-MM-DD HH24:MI:SS') FROM dual;

---- 1. MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이의 달의 차이 
SELECT MONTHS_BETWEEN(SYSDATE, hiredate) FROM emp;

---- 2. ADD_MONTHS(날짜1, 숫자) : 날짜1에 숫자 만큼 더한 후의 날짜를 구함
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

---- 3. NEXT_DAY, LAST_DAY : 다음 요일에 해당하는 날짜 구함, 이 달의 마지막 날짜
SELECT NEXT_DAY(SYSDATE, '목요일') FROM DUAL; -- 요일을 문자로 입력했을 때
SELECT NEXT_DAY(SYSDATE, 1) FROM DUAL;       -- 요일을 숫자로 입력해도 작동
SELECT LAST_DAY(SYSDATE) FROM dual;
 
---- 4. ROUND, TRUNC :  날짜 관련 반올림, 버림
SELECT ROUND(SYSDATE) FROM dual;
SELECT TO_CHAR(ROUND(SYSDATE),'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TRUNC(SYSDATE) FROM dual;
SELECT TO_CHAR(TRUNC(SYSDATE),'YYYY-MM-DD HH24:MI:SS') FROM dual;

--- 4) 데이터 타입 변환 함수
/*
 TO_CHAR()    : 숫자, 날짜      ===> 문자
 TO_DATE()    : 날짜 형식의 문자 ===> 날짜
 TO_NUMBER()  : 숫자로만 구성된 문자데이터 ===> 숫자
*/

---- 1. TO_CHAR() : 숫자패턴 적용
--     숫자패턴 : 9 ==> 한자리 숫자
SELECT TO_CHAR(12345, '9999') FROM dual;

-- 앞에 빈칸을 0으로 채우기
SELECT TO_CHAR(12345, '0999999') FROM dual;

-- 소수점 이하 표현
SELECT TO_CHAR(12345, '9999999.999') FROM dual;

-- 숫자 패턴에서 3자리씩 끊어 읽기 + 소수점 이하 표현
SELECT TO_CHAR(12345, '9,999,999.99') FROM dual;

---- 2. TO_DATE() : 날짜 패턴에 맞는 문자 값을 날짜 데이터로 변경
SELECT TO_DATE('2018-06-27','YYYY-MM-DD') as "TODAY" FROM dual;
SELECT '2018-06-27' TODAY FROM DUAL;

SELECT TO_DATE('2018-06-27','YYYY-MM-DD') + 10 as "TODAY" FROM dual;
-- 10일 후의 날짜 연산 결과 얻음 : 18/07/07
SELECT '2018-06-27' + 10 TODAY FROM DUAL;
-- ORA-01722: invalid number ==> 2018-06-27 '문자 + 숫자 10의 연산 불가능

---- 3. TO_NUMBER() : 오라클이 자동 형변환을 제공하므로 자주 사용은 안됨
SELECT '1000' + 10 as "result" FROM dual;
SELECT TO_NUMBER('1000') + 10 AS "RESULT" FROM DUAL;

--- 5) DECODE(expr, search, result [,search, result]..[, default]) 
/*
    만약에 default 가 설정이 안되었고
    expr 과 일치하는 search가 없는 경우 null 을 리턴
*/
SELECT DECODE('YES'  --expr
             ,'YES', '입력값이 YES 입니다.'  --search, result 세트 1
             ,'NO', '입력값이 NO 입니다.'    --search, result 세트 2
             ) as "result"
  FROM DUAL;

SELECT DECODE('NO'  --expr
             ,'YES', '입력값이 YES 입니다.'  --search, result 세트 1
             ,'NO', '입력값이 NO 입니다.'    --search, result 세트 2
             ) as "result"
  FROM DUAL;
  
SELECT DECODE('예'  --expr
             ,'YES', '입력값이 YES 입니다.'  --search, result 세트 1
             ,'NO', '입력값이 NO 입니다.'    --search, result 세트 2
             ) as "result"
  FROM DUAL;  
-- >> expr 과 일치하는 search 가 없고, default 설정도 안되었을 때
-- 결과가 <인출된 모든 행 : 0> 이 아닌 NULL 이라는 것 확인

SELECT DECODE('예'  --expr
             ,'YES', '입력값이 YES 입니다.'  --search, result 세트 1
             ,'NO', '입력값이 NO 입니다.'    --search, result 세트 2
             ,'입력값이 YES/NO 중 어느것도 아닙니다.') as "result"
  FROM DUAL;
  
-- EMP 테이블의 HIREDATE의 입사년도를 추출하여 몇년 근무했는지를 계산
-- 장기근속 여부를 판단
-- 1) 입사년도 추출 : 날짜 패턴
SELECT e.EMPNO
     , e.ENAME
     , TO_CHAR(e.HIREDATE, 'YYYY') as "hireyear"
  FROM emp e
  ;
-- 2) 몇년근무 판단 : 오늘 시스템 날짜와 연산
SELECT e.EMPNO
     , e.ENAME
     , TO_CHAR(sysdate, 'YYYY') - TO_CHAR(e.HIREDATE,'YYYY') as "근무햇수"
  FROM emp e
  ;

--3) 37년 이상 된 직원을 장기 근속으로 판단
SELECT a.EMPNO
     , a.ENAME
     , a.workingyear
     , DECODE(a.workingyear
             ,37, '장기 근속자 입니다.'  -- search, result 1
             ,38, '장기 근속자 입니다.'  -- search, result 2
             ,'장기 근속자가 아닙니다.')  as "장기 근속 여부" -- default1   
  FROM (SELECT e.EMPNO
     , e.ENAME
     , TO_CHAR(sysdate, 'YYYY') - TO_CHAR(e.HIREDATE,'YYYY')  workingyear
  FROM emp e) a
;


-- job별로 경조사비를 일정 비율로 지급하고 있다.
-- 각 직원들의 경조사비 지원금을 구하자
/*  
    CLERK     : 5%
    SALESMAN  : 4%
    MANAGER   : 3.7%
    ANALYST   : 3%
    PRESIDENT : 1.5%
*/

SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , DECODE(e.JOB --expr
            ,'CLERK',e.SAL * 0.05
            ,'SALESMAN',e.SAL * 0.04
            ,'MANAGER', e.SAL * 0.037
            ,'ANALYST', e.SAL * 0.03
            ,'PRESIDENT', e.SAL * 0.015 ) as "경조사비 지원금"
  FROM emp e
;

-- 출력 결과에 숫자 패턴 적용
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , TO_CHAR(DECODE(e.JOB --expr
            ,'CLERK',e.SAL * 0.05
            ,'SALESMAN',e.SAL * 0.04
            ,'MANAGER', e.SAL * 0.037
            ,'ANALYST', e.SAL * 0.03
            ,'PRESIDENT', e.SAL * 0.015 ),'$999.99') as "경조사비 지원금"
  FROM emp e
;




commit;



