SHOW SERVEROUTPUT;
SET SERVEROUTPUT ON 
;

-- 실습5)
-- 1. 프로시저 생성
CREATE OR REPLACE PROCEDURE chk_sal_per_month
(v_sal          IN   VARCHAR2
, v_sal_month   OUT   VARCHAR2
)
IS

BEGIN
v_sal_month := v_sal/12;
DBMS_OUTPUT.PUT_LINE(v_sal||':'||v_sal_month);
END chk_sal_per_month;
/

VAR v_month VARCHAR2;

EXECUTE chk_sal_per_month(500000, :v_month);

PRINT v_month;
desc dept;
desc emp;
-- 실습6)
--- 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_variables
(v_deptno    IN  NUMBER
,v_loc       IN  VARCHAR2
)
IS
  v_hiredate      DATE;
  v_empno         NUMBER:=1999;
  v_msg           varchar2 (200) default '안녕하세요';
  v_max           constant number :=5000;
BEGIN
DBMS_OUTPUT.PUT_LINE(v_deptno);
DBMS_OUTPUT.PUT_LINE(v_loc);
v_hiredate:= sysdate;
DBMS_OUTPUT.PUT_LINE(v_hiredate);
DBMS_OUTPUT.PUT_LINE(v_empno);
DBMS_OUTPUT.PUT_LINE(v_msg);
DBMS_OUTPUT.PUT_LINE(v_max);

END sp_variables;
/
--- 컴파일/디버깅

-- 3) VAR : BIND 변수가 필요하면 선언

-- 4) EXEC
SET SERVEROUTPUT ON
EXEC SP_VARIABLES('10', '하와이')
EXEC SP_VARIABLES('20', '스페인')
EXEC SP_VARIABLES('30', '제주도')
EXEC SP_VARIABLES('40', '몰디브')
desc log_table;
--실습7)

CREATE OR REPLACE PROCEDURE log_excution_references
(v_log_user   IN log_table.userid%TYPE
,v_log_date   OUT log_table.log_date%TYPE)
IS

BEGIN
 v_log_date := sysdate;
 DBMS_OUTPUT.PUT_LINE(v_log_user||':'||v_log_date);
 
END log_excution_references;
/

VAR v_log_date_result varchar2(200);

EXECUTE log_execution('윤홍식',:v_log_date_result);

print v_log_date_result;

-- 실습8)
CREATE OR REPLACE PROCEDURE v_sysdate_excution
(v_sysdate  IN OUT  varchar2      
)
IS
BEGIN 
DBMS_OUTPUT.PUT_LINE('초기 입력 값:'||v_sysdate);

v_sysdate :=TO_CHAR(TO_DATE(v_sysdate),'YYYY-MON-dd');

DBMS_OUTPUT.PUT_LINE('패턴 적용 값:'||v_sysdate);

END v_sysdate_excution;
/

VAR v_sysdate_bind VARCHAR2(30);

exec :v_sysdate_bind := sysdate;
exec v_sysdate_excution(:v_sysdate_bind);

PRINT v_sysdate_bind;


-- 실습9)
---프로시저 작성
CREATE OR REPLACE PROCEDURE insert_dept
(v_dname IN  dept.dname%TYPE
,v_loc   IN  dept.loc%TYPE)
IS
  v_dept dept%ROWTYPE; 
BEGIN
        select d.dname
             , d.deptno
             , d.loc
          into v_dept
          from dept d
          where d.dname = v_dname
          ;
DBMS_OUTPUT.PUT_LINE('부서 번호'||v_dept.deptno+10);
END insert_dept;
/
show errors;
---2. 디버깅
---3. bind변수
---4. exec

EXEC insert_dept('SALESMAN');
--모르겠습니다..
show errors;

-- 실습10)

desc emp;
-- 실습11)
CREATE OR REPLACE PROCEDURE sp_get_comm
(v_empno       IN  EMP.EMPNO%TYPE
,v_comm_fee        OUT EMP.comm%TYPE )
IS
    -- 1. 사번인 직원의 직무를 저장할 지역 변수 선언
    v_job  EMP.JOB%TYPE;
    -- 2. 사번인 직원의 급여를 저장할 지역 변수 선언
    v_comm  EMP.COMM%TYPE;
    
BEGIN 
    -- 3. 입력된 사번 직원의 직무를 조회하여 v_job v_sal에 저장
    SELECT e.job
         , e.comm
      INTO v_job, v_comm
      FROM emp e
     WHERE e.EMPNO = v_empno
     ;
  
    -- 4. 일정 비율로 v_tribute_fee를 계산
    IF    v_job = 'SALESMAN' THEN v_comm_fee := 1000;
    ELSIF v_job = 'MANAGER' THEN v_comm_fee:= 1500;
    ELSE v_comm_fee :=500;
    END IF ;
    
END sp_get_comm;
/
show errors;
-- 2. 컴파일/ 디버깅

-- 3. VAR
VAR v_comm_fee_bind NUMBER;
-- 4. EXEC
EXEC sp_get_comm(v_comm_fee => :v_comm_fee_bind, v_empno => 7566);

-- 5. PRINT
PRINT v_comm_fee_bind;

-- 실습12)
DECLARE
    -- FOR LOOP 에서 사용할 카운터 변수 선언 / 초기화
    v_init      NUMBER :=0;
BEGIN
    -- 2. LOOP 작성
    FOR v_init IN 1 .. 10 LOOP
         IF(MOD(v_init,1)=0)
            THEN DBMS_Output.Put_Line(v_init);
         END IF;
    END LOOP;
END;
/

-- 실습13)
DECLARE
    -- FOR LOOP 에서 사용할 카운터 변수 선언 / 초기화
    v_init      NUMBER :=0;
BEGIN
    -- 2. LOOP 작성
    FOR v_init IN reverse 1 .. 10 LOOP
         IF(MOD(v_init,2)=0)
            THEN DBMS_Output.Put_Line(v_init);
         END IF;
    END LOOP;
END;
/

-- 실습14)
DECLARE
    -- 반복 조건으로 사용할 횟수 변수 선언
        cnt     NUMBER :=0;
BEGIN
    -- WHILE 반복문 작성
    WHILE cnt < 10 LOOP
        cnt := cnt + 1;
        Dbms_Output.Put_Line(cnt);
    END LOOP;
END;
/

-- 실습15)
CREATE OR REPLACE FUNCTION fn_avg_sal_by_emp
(v_job      IN    emp.job%TYPE)
RETURN NUMBER
IS 
    -- 직무별 급여 평균을 저장할 지역변수 선언
    v_avg_sal  EMP.SAL%TYPE;
BEGIN
    -- 직무별 급여 평균을 AVG() 함수를 사용하여 구하고 저장
    SELECT  avg(e.sal)
      INTO v_avg_sal
      FROM emp e
      group by e.job
     ;
    
     -- 계산 결과를 반올림하여 리턴
     RETURN ROUND(v_avg_sal);
END fn_avg_sal_by_emp;
/

PRINT fn_avg_sal_by_emp;





-- 실습18)
CREATE OR REPLACE PROCEDURE 
RETURN
IS
BEGIN
END
/

CREATE OR REPLACE VIEW v_emp_dept
AS
SELECT e1.EMPNO
     , e1.ENAME
     , e2.ENAME  as mgr_name
     , e1.DEPTNO
     , d.DNAME
     , d.LOC
  FROM new_emp e1
     , new_emp e2
     , new_dept d
 WHERE e1.deptno = d.deptno(+)
   AND e1.mgr = e2.empno(+)
WITH READ ONLY   
; 
----------- VIEW ---------------

-- 실습9)
create view v_cust_general_regdt
as
select c.userid
     , c.regdate
  from customer c
 with read only
 ;
 
 -- 실습10)
 select v.*
   from v_cust_general_regdt v
      ;
      
-- 실습11)
desc v_cust_general_regdt;

-- 실습12)
SELECT u.VIEW_NAME
     , u.TEXT
  FROM user_views u 
;  

-- 실습13) 
drop view v_cust_general_regdt;

-- 실습14)
SELECT u.VIEW_NAME
     , u.TEXT
  FROM user_views u 
;  


