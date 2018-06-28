-- job별로 경조사비를 일정 비율로 지급하고 있다.
-- 각 직원들의 경조사비 지원금을 구하자
/*  
    CLERK     : 5%
    SALESMAN  : 4%
    MANAGER   : 3.7%
    ANALYST   : 3%
    PRESIDENT : 1.5%
*/

-- 1.Simple CASE 구문으로 구해보자 : DECODE와 거의 유사, 동일비교만 가능
--                               괄호가 없고, 콤마 대신 키워드 WHEN, THEN, ELSE 등을 사용
 
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , CASE e.JOB WHEN 'CLERK' THEN e.SAL*0.05
                  WHEN 'SALESMAN' THEN e.SAL*0.04
                  WHEN 'MANAGER' THEN e.SAL*0.037
                  WHEN 'ANALYST' THEN e.SAL*0.03
                  WHEN 'PRESIDENT' THEN e.SAL*0.015
        END as "경조사 지원금"
  FROM emp e
;

-- 2. Searched CASE 구문으로 구해보자
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , CASE WHEN e.JOB = 'CLERK' THEN e.SAL *0.05
            WHEN e.JOB = 'SALESMAN' THEN e.SAL *0.04
            WHEN e.JOB = 'MANAGER' THEN e.SAL *0.037
            WHEN e.JOB = 'ANALYST' THEN e.SAL *0.03
            WHEN e.JOB = 'PRESIDENT' THEN e.SAL *0.015
            ELSE 10
        END as "경조사 지원금"
  FROM emp e
;

-- CASE 결과에 숫자 통화 패턴 씌우기 : $기호, 숫자 세자리 끊어 읽기, 소수점 이하 2자리
SELECT e.EMPNO
     , e.ENAME
     , nvl(e.JOB, '미지정') as "job"
     , TO_CHAR(CASE WHEN e.JOB = 'CLERK' THEN e.SAL *0.05
            WHEN e.JOB = 'SALESMAN' THEN e.SAL *0.04
            WHEN e.JOB = 'MANAGER' THEN e.SAL *0.037
            WHEN e.JOB = 'ANALYST' THEN e.SAL *0.03
            WHEN e.JOB = 'PRESIDENT' THEN e.SAL *0.015
            ELSE 10
        END, '$9,999.99') as "경조사 지원금"
  FROM emp e
;

/* SALGRADE 테이블의 내용 : 이 회사의 급여 등급 기준 값
GRADE, LOSAL,   HISAL
----------------------------
1	   700	    1200
2	   1201	    1400
3	   1401    	2000
4	   2001   	3000
5	   3001   	9999
*/

-- 제공되는 급여 등급을 바탕으로 각 사원들의 급여 등급을 구해보자
-- CASE를 사용하여

SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , CASE WHEN e.SAL >= 700 AND e.SAL <=1200 THEN 1
            WHEN e.SAL >= 1200 AND e.SAL <=1400 THEN 2
            WHEN e.SAL >= 1400 AND e.SAL <=2000 THEN 3
            WHEN e.SAL >= 2000 AND e.SAL <=3000 THEN 4
            WHEN e.SAL >= 3000 AND e.SAL <=9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
 ORDER BY "급여 등급" DESC
;

--WHEN 안의 구문을 BETWEEN ~ AND 으로 변경하여 작성
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , CASE WHEN e.SAL BETWEEN 700 AND 1200  THEN 1
            WHEN e.SAL BETWEEN 1201 AND 1400 THEN 2
            WHEN e.SAL BETWEEN 1401 AND 2000 THEN 3
            WHEN e.SAL BETWEEN 2001 AND 3000 THEN 4
            WHEN e.SAL BETWEEN 3001 AND 9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
 ORDER BY "급여 등급" DESC
;

---------- 2. 그룹함수 (복수행 함수)
-- 1) COUNT(*) : 특정 테이블의 행의 개수(데이터의 개수)를 세어주는 함수
--               NULL 을 처리하는 <유일한> 그룹함수

-- COUNT(expr) : expr 으로 등장한 값을 NULL 제외하고 세어주는 함수

-- dept, salgrade 테이블의 전체 데이터 개수 조회
SELECT COUNT(*) as "부서 개수"
  FROM dept d
;

/*
DEPTNO,  DNAME,    LOC
------------------------------
10	  ACCOUNTING	NEW YORK ====>
20	  RESEARCH	    DALLAS   ====>  COUNT(*) ====> 4
30  	SALES	    CHICAGO  ====>
40	  OPERATIONS	BOSTON   ====>
*/
SELECT *
  FROM dept d
;

SELECT COUNT(*) as "급여 등급 개수"
  FROM  salgrade s
;

/*
GRADE, LOSAL,   HISAL
---------------------
1	  700	    1200
2	  1201	    1400
3	  1401	    2000
4	  2001  	3000
5	  3001  	9999
*/

---emp 테이블에서 job 컬럼의 데이터 개수를 카운트
SELECT COUNT(e.JOB)
  FROM emp e
;

/*
EMPNO,  ENAME,   JOB
------------------------
7369	SMITH	CLERK       =======>
7499	ALLEN	SALESMAN    =======>
7521	WARD	SALESMAN    =======>
7566	JONES	MANAGER     =======>    COUNT(e.JOB) ====> 15
7654	MARTIN	SALESMAN    =======>
7698	BLAKE	MANAGER     =======>
7782	CLARK	MANAGER     =======>
7839	KING	PRESIDENT   =======>
7844	TURNER	SALESMAN    =======>
7900	JAMES	CLERK       =======>
7902	FORD	ANALYST     =======>
7934	MILLER	CLERK       =======>
9999	J_JUNE	CLERK       =======>
8888	J	    CLERK       =======>
7777	J%JONES	CLERK       =======>
6666	JJ      (null)      =======>   개수를 세는 기준 컬럼인 job 이 null 이 이 한행은 처리 안함
*/

-- 회사에 매니저가 배정된 직원이 몇명인가

SELECT COUNT(e.MGR) as "상사가 있는 직원 수"
  FROM emp e
;

-- 매니저 직을 맡고 있는 직원이 몇명인가
--- 1.mgr 컬럼을 중복제거 하여 조회
SELECT DISTINCT e.MGR
  FROM emp e
;
--- 2. 그때의 결과를 카운트
SELECT COUNT(DISTINCT e.MGR) as "매니저 수"
  FROM emp e
;

-- 부서가 배정된 직원이 몇명이나 있는가 
SELECT COUNT(e.DEPTNO) as "부서 배정 인원"
  FROM emp e;
  
-- COUNT(*) 가 아닌 COUNT(expr)를 사용한 경우에는
SELECT e.DEPTNO
  FROM emp e
 WHERE e.DEPTNO IS NOT NULL
 ;
--을 수행한 결과를 카운트 한 것으로 생각할 수 있다.

SELECT COUNT(e.DEPTNO) as "부서 배정 인원"
     , COUNT(*)-COUNT(e.DEPTNO)as "부서 미배정 인원" 
  FROM emp e
;

-- 2)SUM() : NULL 항목 제외하고
--           합산 가능한 행을 모두 더한 결과를 출력
-- SALESMAN 들의 수당 총합을 구해보자
SELECT SUM(e.COMM)
  FROM emp e
 WHERE e.JOB = 'SALESMAN' 
;

/*
COMM
-------
(NULL)
300     ====>
500     ====>
(NULL)
1400    ====>  SUM(e.COMM) ====> 2200 : comm 컬럼이 NULL인 것들은 합산에서 제외
(NULL)
(NULL)
(NULL)
0       ====>
(NULL)
(NULL)
(NULL)
(NULL)
(NULL)
(NULL)
(NULL)
*/

-- 수당 총합 결과에 숫자 출력 패턴 별칭
SELECT TO_CHAR(SUM(e.COMM), '$9,999')as "수당 총합"
  FROM emp e
 WHERE e.JOB = 'SALESMAN'
;

-- 3) AVG(expr) : NULL 값 제외하고 연산 가능한 항목의 산술 평균을 구함

-- 수당 평균을 구해보자
SELECT TO_CHAR(AVG(e.COMM),'$9,999') as "수당 평균"
  FROM emp e
;

-- 4) MAX(expr) : expr에 등장한 값 중 최댓값을 구함
--                expr 이 문자인 경우 알파벳순 뒷쪽에 위치한 글자를 최댓값으로 계산
-- 이름이 가장 나중인 직원
SELECT MAX(e.ENAME)
  FROM emp e
;

--------3. GROUP BY 절의 사용
--1) emp 테이블에서 각 부서별로 급여의 총합을 조회

-- 총합을 구하기 위하여 SUM()을 사용
-- 그룹화 기준을 부서번호(deptno)를 사용
-- 그룹화 기준으로 잡은 부서번호가 GROUP BY 절에 등장해야 함

-- a) 먼저 emp 테이블에서 급여 총합 구하는 구문을 작성
SELECT SUM(e.SAL)
  FROM emp e
;

-- b) 부서번호를 기준으로 그룹화를 진행
-- SUM()은 그룹함수이므로 GROUP BY 절에 조합하면 그룹화 가능
-- 그룹화를 하려면 기준 컬럼을 GROUP BY 절에 명시
SELECT e.DEPTNO
     , SUM(e.SAL) "급여 총합"
  FROM emp e
 GROUP BY e.DEPTNO
;

-- GROUP BY 절에 등장하지 않은 컬럼이 SELECT 에 등장하면 오류, 실행 불가
SELECT e.DEPTNO, e.JOB
     , SUM(e.SAL) "급여 총합"
  FROM emp e
 GROUP BY e.DEPTNO
;

---- ORA-00979: not a GROUP BY expression

-- 부서별 급여의 총합, 평균, 최대급여, 최소급여
SELECT TO_CHAR(SUM(e.SAL),'9,999.00') as "급여 총합"
     , TO_CHAR(AVG(e.SAL),'9,999.00') as "급여 평균"
     , TO_CHAR(MAX(e.SAL),'9,999.00') as "최대 급여"
     , TO_CHAR(MIN(e.SAL),'9,999.00') as "최소 급여"
  FROM emp e
GROUP BY e.DEPTNO
;
-- 위의 쿼리는 수행되지만 정확하게 어느 부서의 결과인지 
-- 알 수가 없다는 단점이 존재
/*-----------------------------------------------------
 GROUP BY 절에 등장하는 그룹화 기준 컬럼은 반드시 SELECT 절에 똑같이 등장해야 한다.
 
 하지만 위의 쿼리가 실행되는 이유는
 SELECT 절에 나열된 컬럼 중에서 그룹함수가 사용되지 않은 컬럼이 없기 때문
 즉, 모두다 그룹함수가 사용된 컬럼들이기 때문
 -----------------------------------------------------*/

SELECT SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
GROUP BY e.DEPTNO
ORDER BY e.DEPTNO
;

-- 부서 지정 안되어서 (null) 로 표현되는 값을 "부서 미지정"으로 출력되도록
SELECT DECODE(nvl(e.deptno,0)
            , e.DEPTNO, e.DEPTNO || ''
            , '미배정')
     , SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
 GROUP BY e.deptno
;


SELECT nvl(e.deptno||'','부서미지정')
     , SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
 GROUP BY e.deptno
;



select*from emp;

SELECT SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
GROUP BY e.DEPTNO, e.JOB
ORDER BY e.DEPTNO, e.JOB
;
-- 그룹함수가 적용되지 않았고, GROUP BY 절에도 등장하지 않은 JOB 컬럼이
-- SELECT 절에 있기 때문에 오류가 발생


-- 오류코드 ORA-00937: not a single-group group function
SELECT e.DEPTNO as "부서번호"
     , e.JOB as "직무"            -- SELECT 에는 등장
     , SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
--GROUP BY e.DEPTNO                -- GROUP BY 에는 누락된 컬럼 JOB
;
-- 그룹함수가 적용되지 않았고, GROUP Y 절에도 등장하지 않은 JOB 컬럼이
-- SELECT 절에 있기 때문에 오류가 발생

-- job 별 급여의 총합, 평균, 최대, 최소를 구해보자

SELECT e.JOB
     , SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
 GROUP BY e.JOB
;

SELECT nvl(e.JOB,'직무미지정')
     , SUM(e.SAL) as "급여 총합"
     , AVG(e.SAL) as "급여 평균"
     , MAX(e.SAL) as "최대 급여"
     , MIN(e.SAL) as "최소 급여"
  FROM emp e
 GROUP BY e.JOB
;

---- 4. HAVING 절의 사용
-- GROUP BY 결과에 조건을 걸어서
-- 결과를 제한(필터링) 할 목적으로 사용되는 절

-- 문제 ) 부서별 급여 평균이 2500이상인 부서
-- a) 우선 부서별 급여 평균을 구한다
-- b) a의 결과에서 2500이상인 부서만 남긴다.

SELECT e.DEPTNO "부서 번호"
    , AVG(e.SAL) as "급여 평균"
  FROM emp e
GROUP BY e.DEPTNO
HAVING AVG(e.SAL) >= 2000
;

-- HAVING 절을 사용하여 조건을 걸 때 주의할 점 : 별칭을 사용할 수 없음
-- HAVING 절이 존재하는 경우 SELECT 의 구문의 실행 순서 정리
/*
1. FROM     절의 테이블 각 행을 대상으로
2. WHERE    절의 조건에 맞는 행만 선택하고
3. GROUP BY 절에 나온 컬럼, 식(함수 식 등)으로 그룹화를 진행
4. HAVING   절의 조건을 만족시키는 그룹행만 선택
5. 4까지 선택된 그룹 정보를 가진 행에 대해서
   SELECT   절에 명시된 컬럼, 식(함수 식 등)만 출력
6. ORDER BY 가 있다면 정렬 조건에 맞추어 최종 정렬하여 보여 준다.
*/

SELECT e.DEPTNO "부서 번호"
    , AVG(e.SAL) as "급여 평균"
  FROM emp e
GROUP BY e.DEPTNO
HAVING "급여 평균" >= 2000
ORDER BY e.DEPTNo
;
-- ORA-00904: "급여 평균": invalid identifier
SELECT*FROM EMP;
-- 1. 매니저별, 부하직원의 수를 구하고, 많은 순으로 정렬
SELECT e.MGR
     , count(*)
  FROM emp e
  where mgr is not null
  GROUP BY MGR 
 ;

-- 2. 부서별 인원을 구하고, 인원수 많은 순으로 정렬
SELECT e.deptno
     , count(*)
  FROM emp e
  GROUP BY deptno
  ORDER BY COUNT(*) DESC
 ;

-- 3. 직무별 급여 평균 구하고, 급여 평균 높은 순으로 정렬
SELECT e.JOB
     , avg(e.sal)
  FROM emp e
  GROUP BY job
  ORDER BY avg(e.sal) DESC
 ;
-- 4. 직무별 급여의 총합을 구하고, 총합 높은 순으로 정렬
SELECT e.JOB
     , sum(e.sal)
  FROM emp e
  GROUP BY job
  ORDER BY sum(e.sal) DESC
 ;
-- 5. 급여의 앞단위가 1000이하, 1000, 2000, 3000, 5000 별로 인원수를 구하시오
--    급여 단위 오름차순으로 정렬

SELECT trunc(e.sal,-3)
     , COUNT(TRUNC(e.SAL, -3))as "급여 단위"
  FROM emp e
GROUP BY TRUNC(e.SAL, -3)
ORDER BY "급여 단위" ;
;

-- b) TRUNC 로 얻어낸 급여단위를 COUNT 하면 인원수를 구할 수 있겠다.
SELECT trunc(e.sal,-3)
     , COUNT(TRUNC(e.SAL, -3))as "급여 단위"
  FROM emp e
GROUP BY TRUNC(e.SAL, -3)
ORDER BY "급여 단위" ;
;

-- c) 급여 단위가 1000 미만인 경우 0으로 출력되는 것을 변경
-- : 범위 연산이 필요해 보임 ===> CASE 구문 선택
SELECT CASE WHEN TRUNC(e.SAL, -3) <1000 THEN '1000 미만'
            ELSE TRUNC(e.SAL, -3) || ''
        END as "급여 단위"
        , COUNT(TRUNC(e.SAL, -3)) "인원(명)"
    FROM emp e
   GROUP BY TRUNC(e.SAL, -3)
   ORDER BY TRUNC(e.SAL, -3)
;
------------------------------------------------------------
-- 5번을 다른 함수로 풀이
-- a) sal 컬럼에 왼쪽으로 패딩을 붙여서 0을 채움
SELECT e.EMPNO
     , e.ENAME
     , LPAD(e.SAL, 4, '0')
  FROM emp e
;

-- b) 맨 앞의 글자를 잘라낸다.
SELECT e.EMPNO
     , e.ENAME
     , substr(LPAD(e.SAL, 4, '0'),1,1)
  FROM emp e
;

-- c) 단위로 처리 + COUNT + 그룹화
SELECT substr(LPAD(e.SAL, 4, '0'),1,1) as "급여 단위"
     , COUNT(*) "인원(명)"
  FROM emp e
 GROUP BY SUBSTR(LPAD(e.SAL, 4, '0'),1,1) 
;

-- d) 1000 단위로 출력 형태 변경
SELECT CASE WHEN SUBSTR(LPAD(e.SAL, 4, '0'),1,1)=0 THEN '1000 미만'
            ELSE TO_CHAR(SUBSTR(LPAD(e.SAL, 4, '0'),1,1)*1000)
        END "급여 단위"
     , COUNT(*) "인원(명)"
  FROM emp e
 GROUP BY SUBSTR(LPAD(e.SAL, 4, '0'),1,1)
 ORDER BY SUBSTR(LPAD(e.SAL, 4, '0'),1,1)
;
-- 6. 직무별 급여 합의 단위를 구하고, 급여 합의 단위가 큰 순으로 정렬
SELECT e.JOB
     , sum(e.sal)
  FROM emp e
  GROUP BY job
  ORDER BY sum(e.sal) DESC
 ;
 
-- b) job 별로 급여의 합을 구함 ==> 그룹화 기준 컬럼으로 job을 사용
SELECT e.JOB
     , TRUNT(SUM(e.SAL),-3) "급여 단위"
  FROM emp e
 GROUP BY e.JOB
 ;
 
-- c) 정렬
SELECT e.JOB
     , TRUNC(SUM(e.SAL),-3) "급여 단위"
  FROM emp e
 GROUP BY e.JOB
 ORDER BY "급여 단위" DESC
 ;

-- 7. 직무별 급여 평균이 2000이하인 경우를 구하고 평균이 높은 순으로 정렬
SELECT e.JOB
     , avg(e.SAL)
  FROM emp e
  GROUP BY e.job
  HAVING avg(e.sal) <= 2000
  ORDER BY avg(e.sal) DESC
 ;
 -- a) 직무별로 급여 평균을 구하자 : 그룹화 기준 컬럼 : job
 SELECT e.JOB
    , avg(e.SAL) "급여 평균"
  FROM emp e
 GROUP BY e.JOB
;

-- b) a에서 구해진 결과를 2000 이하 값으로 제한
 SELECT e.JOB
    , avg(e.SAL) "급여 평균"
  FROM emp e
 GROUP BY e.JOB
 HAVING avg(e.SAL)<=2000
  ORDER BY "급여 평균" DESC
;
 
 select*from emp;
 
-- 8. 년도별 입사 인원을 구하시오
SELECT substr(e.hiredate,1,2)||'년'
     , count(*)
  FROM emp e
  GROUP BY substr(e.hiredate,1,2)
  ORDER BY substr(e.hiredate,1,2) DESC
 ;

-- a) hiredate 에서 년도 추출 : TO_CHAR(hiredate, 'YYYY')
-- b) 기준값으로 그룹화 작성

-- 9. 년도별 원별 입사 인원을 구하시오
SELECT substr(e.hiredate,4,2)||'월'
     , count(*)
  FROM emp e
  GROUP BY substr(e.hiredate,4,2)
  ORDER BY substr(e.hiredate,4,2) DESC
 ;
 
-- a) hiredate 에서 년도 추출 : TO_CHAR(e.hiredate, 'YYYY')
--                   월 추출 : TO_CHAR(e.hiredate, 'MM')

-- b) 두 가지 그룹화 기준 적용된 구문 작성
SELECT TO_CHAR(e.hiredate, 'YYYY') "입사 년도"
     , TO_CHAR(e.hiredate, 'MM')   "입사 월"
     , COUNT(*)                    "인원(명)"
  FROM emp e
GROUP BY TO_CHAR(e.hiredate, 'YYYY'), TO_CHAR(e.hiredate,'MM')
ORDER BY "입사 년도", "입사 월"
;

----------------------------------------------------------------
-- 년도별, 월별 입사 인원을 가로 표 형태로 출력
-- a) 년도 추출, 월 추출
--TO_CHAR(e.hiredate, 'YYYY'), TO_CHAR(e.iredate,'MM')

-- b) hiredate 에서 월을 추출한 값이 01 이 나오면 그 때의 숫자만 1월에서 카운트
-- 이 과정을 12월 까지 반복
SELECT TO_CHAR(e.hiredate, 'YYYY') "입사 년도"-- 그룹화 기준 컬럼
     , DECODE(TO_CHAR(e.hiredate,'MM'),'01',1)) "1월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "2월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'03',1)) "3월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'04',1)) "4월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'05',1)) "5월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'06',1)) "6월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'07',1)) "7월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "8월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "9월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "10월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "11월"
     , DECODE(TO_CHAR(e.hiredate,'MM'),'02',1))"12월"
  FROM emp e
  GROUP BY TO_CHAR(e.hiredate,'YYYY')
 ORDER BY "입사 년도"
;

SELECT  '인원(명)' as "인원명" 
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'01',1)) "1월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "2월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'03',1))"3월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'04',1)) "4월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'05',1)) "5월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'06',1)) "6월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'07',1)) "7월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "8월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "9월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "10월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1)) "11월"
     , COUNT(DECODE(TO_CHAR(e.hiredate,'MM'),'02',1))"12월"
  FROM emp e
;

-----------------7. 조인과 서브쿼리
-- (1) 조인 : JOIN
---- 1) 조인개요
-- 하나 이상의 테이블을 논리적으로 묶어서 하나의 테이블 인 것 처럼 다루는 기술
-- FROM 절에 조인에 사용할 테이블 이름을 나열

-- 문제) 직원의 소속 부서 명을 알고 싶다. 부서 명을 알고 싶다.
-- a) FROM 절에 emp, dept 두 테이블을 나열 ==> 조인 발생 ==> 카티션 곱 ==> 두 테이블의 모든 조합
SELECT e.ENAME
     , d.DNAME
  FROM emp e
     , dept d
;

-- 16 x 4 = 64 : emp 테이블의 16건 x dept 테이블의 4건 ==> 64건

-- b) 조건이 추가 되어야 직원의 소속부서만 정확하게 연결할 수 있음
SELECT e.ENAME
     , e.DEPTNO
     , '|'
     , d.DEPTNO
     , d.DNAME
  FROM emp e
     , dept d
 WHERE e.DEPTNO = d.DEPTNO
 ORDER BY d.DEPTNO
;

SELECT E.ENAME
     , D.DNAME
 FROM emp e
     , dept d
 WHERE e.DEPTNO = d.DEPTNO --오라클의 전통적인 조인 조건 작성 기법
 ORDER BY d.DEPTNO
;

SELECT E.ENAME
     , D.DNAME
 FROM emp e JOIN dept d ON (e.DEPTNO = d.DEPTNO)
  -- 최근 다른 DBMS 들이 사용하고 있는 기법을 오라클에서 지원함
 ORDER BY d.DEPTNO
;
-- 조인 조건이 적절히 추가되어 12행의 의미 있는 데이터만 남김

-- 문제) 위의 결과에서 ACCOUNTING 부서의 직원만 알고 싶다.
--      조인 조건과 일반 보건이 같이 사용될 수 있다.
SELECT E.ENAME
     , D.DNAME
 FROM emp e
     , dept d
 WHERE e.DEPTNO = d.DEPTNO -- 조인 조건
   AND d.DNAME = 'ACCOUNTING'
;

---- 2) 조인 : 카티션 곱
--            조인 대상 테이블의 데이터를 가능한 모든 조합으로 엮는 것
--            조인 조건 누락시 발생
--            9i 버전 이후 CROSS JOIN 키워드 지원
SELECT e.ENAME
     , d.DNAME
     , s.GRADE
  FROM emp e CROSS JOIN dept d
             CROSS JOIN salgrade s
;

SELECT e.ENAME
     , d.DNAME
     , s.GRADE
  FROM emp e
     , dept d
     , salgrade s
;
-- emp 16 x dept 4 x salgrade 5 = 320 행 발생

----3) EQUI JOIN : 조인의 가장 기본 형태
--                 서로 다른 테이블의 공통 컬럼을 '=' 로 연결
--                 공통 컬럼 (join attribute)라고 부름

----- 1. 오라클 전통 적인 WHERE 에 조인 조건을 걸어주는 방법
SELECT E.ENAME
     , D.DNAME
 FROM emp e
     , dept d
 WHERE e.DEPTNO = d.DEPTNO --오라클의 전통적인 조인 조건 작성 기법
 ORDER BY d.DEPTNO
;

----- 2. NATURAL JOIN 키워드로 자동 조인
SELECT e.ENAME
     , d.DNAME
  FROM emp e NATURAL JOIN dept d --조인 공통 컬럼 명시가 필요 없음
;

----- 3. JOIN ~ USING 키워드로 조인
SELECT e.ENAME
     , d.DNAME
  FROM emp e JOIN dept d USING (deptno) -- USING 뒤에 공통 컬럼을 별칭 없이 명시
;

----- 4. JOIN ~ ON 키워드로 조인
SELECT e.ENAME
     , d.DNAME
  FROM emp e JOIN dept d ON (e.deptno = d.deptno)
 -- ON 뒤에 조인 조건구문을 명시  





-- (2) 서브쿼리


