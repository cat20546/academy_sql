-- day05 : SQL
------------------------------------------------------------
-- ORACLE 의 특별한 컬럼
-- 1. ROWID : 물리적으로 디스크에 저장된 위치를 가리키는 값
--            물리적으로 저장된 위치이므로 한 행당 반드시 유일할 수 밖에 없음.
--            ORDER BY 절에 의해서 변경되지 않는 값

-- 예) emp 테이블에서 'SMITH'인 사람의 정보를 조회
SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'
;
 
-- rowid 는 ORDER BY 에 의해 변경되지 않는다.
SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 ORDER BY e.empno
 ;
-- ORDER BY e.ENAME

-- 2. ROWNUM : 조회된 결과의 첫번째 행부터 1로
SELECT rownum
    , e.EMPNO
    , e.ENAME 
  FROM emp e
  WHERE e.ENAME = 'SMITH'
;

SELECT rownum
    , e.EMPNO
    , e.ENAME 
  FROM emp e
  WHERE e.ENAME LIKE 'J%'
;

/*
1	7566	JONES
2	7900	JAMES
3	9999	J_JUNE
4	8888	J
5	7777	J%JONES
6	6666	JJ
*/
-- 위의 두 결과를 비교하면 orwnum 도 ORDER BY에 영향을
-- 받지 않는 것 처럼 보일 수 있으나
-- SUB-QUERY 로 사용할 때 영향을 받음.

SELECT rownum
     , a.empno
     , a.ename
  FROM (SELECT e.EMPNO
             , e.ENAME 
             , '|'
        FROM emp e
        WHERE e.ENAME LIKE 'J%'
        ORDER BY e.ENAME) a
;

-----------------------------------------------
-- DML : 데이터 조작어
-----------------------------------------------
-- 1) INSERT : 테이블 

DROP TABLE member; -- Table MEMBER이(가) 삭제되었습니다.
CREATE TABLE member
(  member_id    VARCHAR2(3)     
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     -- NULL 허용시 제약조건 비우면 됨
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30)
 , birth_month  NUMBER(2)
 , gender       VARCHAR2(1)     
 , CONSTRAINT pk_member        PRIMARY KEY (member_id)
 , CONSTRAINT ck_member_gender CHECK (gender IN ('M', 'F'))
 , CONSTRAINT ck_member_birth  CHECK (birth_month>0 AND birth_month <=12)
);

-- 테이블 구조 확인
desc member;

--- 1. INTO 구문에 컬럼 이름 생략시 데이터 추가
INSERT INTO member
VALUES ('M01', '전현찬', '5250', sysdate, '덕명동', 11, 'M');
INSERT INTO member
VALUES ('M02', '조성철', '9034', sysdate, '오정동', 8, 'M');
INSERT INTO member
VALUES ('M03', '김승유', '5219', sysdate, '오정동', 1, 'M');

-- 몇몇 컬럼에 NULL 데이터 추가

--- 2. INTO 구문에 컬럼 이름 명시하여 데이터 추가
INSERT INTO member
VALUES ('M04', '박길수', '4003', sysdate, NULL, NULL, 'M');
INSERT INTO member
VALUES ('M05', '강현', NULL , NULL, '홍도동', 6, 'M');
INSERT INTO member
VALUES ('M06', '김소민', NULL, sysdate, '월평동', NULL, NULL);

-- 입력데이터 조회
SELECT M.*
  FROM MEMBER M;
  
-- CHECK 옵션에 위배되는 데이터 추가 시도
INSERT INTO member
VALUES ('M07', '강병우', 2260 , sysdate, '사정동', 2, 'N'); -- gender 위반
/*
오류 보고 -
ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated
*/

INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 0, NULL); -- birt_month 위반
/*
오류 보고 -
ORA-02290: check constraint (SCOTT.CK_MEMBER_BIRTH) violated
*/

INSERT INTO member
VALUES ('M07', '강병우', 2260 , sysdate, '사정동', 2, 'M'); -- gender 위반

INSERT INTO member 
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 1, NULL); -- birt_month 위반

--- 2. INTO 구문에 컬럼 이름 명시하여 데이터 추가
--     : VLAUES 절에 INTO 의 순서대로
--       값의 타입, 개수를 맞추어서 작성
INSERT INTO member (member_id, member_name, gender)
VALUES ('M09', '윤홍식', 'M'); -- birt_month 위반
-- reg_date 컬럼 : DEFAULT 설정이 작동하여 시스템 날짜가 자동 입력
-- phone, address 컬럼 : NULL 값으로 입력되는 것 확인

-- INTO 절에 컬럼 나열시 테이블 정의 순서와 별개로 나열 가능
INSERT INTO member (member_name, address, member_id)
VALUES ('이주영', '용전동', 'M10');

-- PK 값이 중복되는 입력시도
INSERT INTO member (member_name, member_id)
VALUES ('남정규', 'M10');
/*
오류 보고 -
ORA-00001: unique constraint (SCOTT.PK_MEMBER) violated
*/
-- 수정 : 이름 컬럼에 주소가 들어가 들어가는 데이터
--       이름, 주소 모두 문자 데이터이기 때문에 타입이 맞아서
--       논리오류 발생
INSERT INTO member (member_name, member_id)
VALUES ('목동', 'M11');

-- 필수 입력 컬럼인 member_name 누락
INSERT INTO member (member_id)
VALUES ('목동', '\\M12')
;

INSERT INTO member (member_name, member_id)
VALUES ('M12', '이동희');

-- INTO 절에 나열된 컬럼(3개)와 VALUES 절의 값(2개)의 개수 불일치
INSERT INTO member (member_name, member_id, gender)
VALUES ('M13', '유재성');
-- SQL ORA-00947: not enough values
--00947. 00000 -  "not enough values"
--*Cause:   

-- INO 절에 나열된 컬럼와 VALUES 절의 데이터 타입이 불일치
INSERT INTO member (member_id, member_name, birth_month)
VALUES ('M13', '유재성', 'M');

-- 숫자가 들어가는 컬럼에 문자 입력 : ORA-01722: invalid number
INSERT INTO member (member_id, member_name, birth_month)
VALUES ('M13', '유재성', 3);


----------------------------------------------------------------
-- 다중 행 입력 : SUB-QUERY 를 사용하여 가능
-- 구문구조
INSERT INTO 테이블이름
SELECT 문장; -- 서브쿼리

-- CREATE AS SELECT 는 데이터를 복사하여 테이블 생성
-- vs.
-- INSERT INTO ~ SELECT는 이미 만들어진 테이블에
--          데이터만 복사 추가
-- member 테이블의 내용을 조회해서 new_member 로 insert
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.PHONE IS NOT NULL
;
-- 5개 행 이(가) 삽입되었습니다.
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.MEMBER_ID > 'M09'
;

-- 성이 '김'인 멤버데이터를 복사 입력
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.MEMBER_NAME LIKE '김%'
;

-- 짝수달에 태어난 멤버데이터를 복사 입력
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE mod(m.birth_month,2) = 0 
;

------------------------------------------------------
-- 2) UPDATE : 테이블의 행을 수정
--             WHERE 조건절의 조합에 따라 1행 혹은 다행 수정이 가능

-- member 테이블에서 이름이 잘못들어간 'M11' 멤버 정보를 수정

-- 데이터 수정 전에 영구반영을 실행
commit; --커밋 완료.

UPDATE member m
   SET m.MEMBER_NAME = '남정규'
where m.member_ID = 'M11'
;
-- 1 행 이(가) 업데이트되었습니다.

-- 'M05' 회원의 전화번호 필드를 업데이트
commit;

UPDATE member m
   SET m.PHONE = '1743'
-- where m.member_ID = 'M05'
;

-- 12개 행이 (가) 업데이트되었습니다.
-- WHERE 조건절의 실수로 DML 작업 실수가 발생
-- 데이터 상태 되돌리기
rollback; -- 롤백완료. / 마지막 커밋 상태까지 되돌림
UPDATE member m
   SET m.PHONE = '1743'
where m.member_ID = 'M05'
;

-- 2개 이상의 컬럼을 한번에 업데이트 SET 절에 나열
UPDATE member m
   SET m.PHONE = '0000'
     , m.REG_DATE = sysdate
where m.member_ID = 'M05'
;
commit;

-- '월평동' 사는 '김소민' 멤버의 NULL 업데이트 
UPDATE member m
   SET m.PHONE = '4724'
     , m.BIRTH_MONTH = 1
     , m.GENDER = 'F'
where m.ADDRESS = '월평동'
;

-- 위의 실행 겨로가는 의도대로 반여오디는 것 처럼
-- 월평동에 사는 사람이 많다면
-- 월평동의 모든 사람 정보가 수정 될것
-- 따라서 UPDATE 구ㅜㄴ작성시 WHERE 조건은
-- 주의를 기울여서 작성해야 함.

/* DML : UPDATE, DELETE 작업시 주의 점

    딱 하나의 데이터를 수정/삭제 하려면
    WHERE 절의 비교 조건에 반드시 PK 로 설정한
    컬럼의 값을 비교하도록 권장.
    
    PK는 전체 행에서 유일하고, NOT NULL 임이 보장 
    되기 때문.
    
    UPDATE, DELETE 는 구문에 물리적 오류가 없으면
    WHERE 조건에 맞는 전체 행 대상으로 작업하는
    것이 기본이므로 항상 주의!!!!!
*/



COMMIT;

-- UPDATE 구문에 SELECT 서브쿼리 사용
-- 'M08' 아이디의 phone, gender 수정
-- 권장되는 PK로 걸어서 수정하는 구문
UPDATE member m
   SET m.PHONE = '4724'
     , m.BIRTH_MONTH = 1
     , m.GENDER = 'F'
where m.ADDRESS = '월평동'
;

-- 서브쿼리 적용
UPDATE member m
 SET m.PHONE = '3318'
     , m.GENDER = 'M'
where m.ADDRESS = (select m.address
                    from member m
                    where m.member_ID = 'M08')
;

select m.address
  from member m
 where m.member_id='M08'
 ;

-- 'M13' 유재성 멤버의 성별 업데이트
UPDATE member m
   SET m.GENDER = (SELECT substr('MATH',1,1) FROM dual)
WHERE m.MEMBER_ID = 'M13'
;

SELECT 'MATH'
  FROM dual;

-- 'M12' 데이터 gender 컬럼 수정시 제약 조건 위반
UPDATE member m
   SET m.gender = 'N'
  WHERE m.MEMBER_ID = 'M12'
;

-- address 가 null 인 사람들의 주소를 일괄 '대전' 으로 수정
UPDATE member m
   SET m.ADDRESS = '대전'
 WHERE m.ADDRESS IS NULl
 ;
 
 commit;
 
 -------------------------------------------------------------
 -- 3) DELETE : 테이블에서 
 ---- 1. WHERE 조건이 있는 DELETE 구문
 --삭제 전 커밋
 commit;
 -- gender 가 'F'인 데이터를 삭제
 DELETE member m
  WHERE m.GENDER = 'R'
;

-- 0개 행 이(가) 삭제되었습니다.
-- 이 결과는 gender에 R 값이 없으므로
-- 삭제된 행이 없는 결과를 얻은 것 뿐
-- 구문오류는 아님, 논리적으로 잘못된 결과인 것.
DELETE member m
 Where m.GENDER = 'F'
 ;
 
 -- 2개 행 이(가) 삭제되었습니다.
 -- WHERE 조건절을 만족하는 모든 행에 대해 삭제 작업 진행
 
-- 데이터 되돌림
ROLLBACK;

-- M99 1행을 삭제하고 싶다면 PK로 삭제하자
DELETE member m
  WHERE m.MEMBER_ID = 'M99'
  ;
  
  commit;
-- 커밋 완료.

-- WHERE 조건을 아예 누락(생략)한 경우 전체행 삭제
DELETE member;
-- 13개 행 이(가) 삭제되었습니다.
rollback;
-- 롤백 완료.


--- 3. DELETE 의 WHERE 에 서브쿼리 조합
-- 주소가 대전인 사람을 모두 삭제
--- (1) 주소가 대전인 사람을 조회
SELECT M.Member_Id
  FROM member m
 WHERE m.ADDRESS = '대전'
;

--- (2) 삭제하느 메인 쿼리 작성
DELETE member m
 WHERE m.MEMBER_ID IN (SELECT M.Member_Id
  FROM member m
 WHERE m.ADDRESS = '대전')
;

rollback;

-- 위와 동일한 작업을 일반 where 로 삭제
DELETE member m
 WHERE m.ADDRESS = '대전'
;
rollback;

----------------------------------------
-- DELETE vs TRUNCATE
/*
  1. TRUNCATE 는 DDL 에 속하는 명령어
     ROLLBACK 지점을 생성하지 않음
     따라서 한 번 실행된 DDL을 되돌릴 수 없음.
     
  2. TRUNCATE 는 WHERE 절 조합이 안되므로
     특정 데이터 선별하여 삭제하는 것이 불가능.
  
     사용시 주의   
*/

-- new_member 테이블을 TRUNCATE 로 날려보자

-- 실행 전 되돌아갈 커밋 지점 생성
commit;

-- new_member 내용 확인
SELECT m.*
  FROM new_member m 
;

-- TRUNCATE 로 new_member 테이블 잘라내기
TRUNCATE TABLE new_member;

-- 되돌리기 시도
rollback;

-- DDL 종류의 구문은 생성즉시 바로 커밋이 이루어짐.
-- 롤백의 시점이 이미 DDL 실행 다음 시점으로 잡힘

--------------------------------------------
-- TCL : Transaction Control Language
-- 1. COMMIT
-- 2. ROLLBACK

-- 3) SAVEPOINT
--- 1. new_member 테이블에 1행 추가
commit;
INSERT INTO new_member(MEMBER_ID, MEMBER_NAME)
VALUES ('M01','홍길동')
;

-- 1행 추가 상태까지 중간 저장
SAVEPOINT do_insert; --Savepoint이(가) 생성되었습니다.

--- 2. '홍길동' 데이터의 주소를 수정
UPDATE new_member m
   SET m.ADDRESS = '율도국'
 WHERE m.MEMBER_ID = 'M01'
;

-- 수정 상태까지 중간 저장
SAVEPOINT do_update; --Savepoint이(가) 생성되었습니다.

--- 3. '홍길동' 데이터의 전화번호를 수정
UPDATE new_member m
   SET m.PHONE = '0001'
 WHERE m.MEMBER_ID = 'M01'
;

SAVEPOINT do_update_phone;

--- 4. '홍길동' 데이터의 성별을 수정
UPDATE new_member m
   SET m.GENDER = 'K'
 WHERE m.MEMBER_ID = 'M01'
;

SAVEPOINT do_update_gender;

----------------------------------------
-- 홍길동 데이터의 ROLLBACK 시나리오

-- 1. 주소 수정까지는 맞는데, 전화번호, 성별 수정은 잘못됨
--  : 되돌아가야 할 SAVEPOINT = do_update_addr
ROLLBACK to do_update_addr;

-- 2. 주소, 전화번호까지 수정이 맞고, 성별 수정이 잘못됨
ROLLBACK to do_update_phone;
/*
ORA-01086: savepoint 'DO_UPDATE_PHONE' never established in this session or is invalid
SAVEPOINT 의 순서가 do_update_addr 이 앞서기 때문에 여기까지 한번 rollback이
일어나면 그 후에 생성된 SVAEPOINT 는 삭제 됨.

앞의 수정구분 제 실행 후 다시 성별 수정
*/

-- 3. 2번 수행 후 어디까지 롤백이 가능한가
ROLLBACK TO do_update_addr
ROLLBACK TO do_insert;
ROLLBACK;
-- SAVIEPOINT 로 한번 뒤돌아 가면 되돌아간 시점 이후
-- 생성된 SAVEPOINT 는 무효화 됨

---------------------------------------------
-- SEQUENCE : 기본 키 등으로 사용되는 일련번호 생성 객체

-- 1. 시작번호: 1, 최대 : 30, 사이클이 없는 시퀀스 생성
CREATE SEQUENCE "Seq_member_id"
START WITH 1
MAXVALUE 30
NOCYCLE
;

-- Sequence SEQ_MEMBER_ID이(가) 생성되었습니다.

-- 시퀀스가 생성되면 유저 딕셔너리에 정보가 저장됨
--  : user_sequences

SELECT s.SEQUENCE_NAME
     , s.MIN_VALUE
     , s.MAX_VALUE
     , s.CYCLE_FLAG
     , s.INCREMENT_BY
  FROM user_sequences s
 WHERE s.SEQUENCE_NAME = 'SEQ_MEMBER_ID'
;

-- 사용자의 객체가 저장되는 딕셔너리 테이블
--  : user_objects
SELECT o.OBJECT_NAME
     , o.OBJECT_TYPE
     , o.OBJECT_ID
  FROM user_objects o
;

DROP SEQUENCE "seq_member_id";

/* ----------------------------------
    메타 데이터를 저장하는 유저 딕셔너리
   ----------------------------------
    무결성 제약조건 : user_constraints
    시퀀스 생성정보 : user_sequences
    테이블 생성정보 : user_tables
    인덱스 생성정보 : user_indexes
    객체를 생성정보 : user_objects
    --------------------------------- */
    
-- 2. 생성된 시퀀스 사용
---- (1) NEXTVAL : 시퀀스의 다음 번호를 생성
--                 CREATE 되고 나서 반드시 최초에 한번은 NEXTVAL 호출되어야
--                 생성 시작됨

--       사용법 : 시쿠너스이름.NEXTVAL
SELECT SEQ_MEMBER_ID.NEXTVAL
  FROM dual;
-- MAXVALUE 이상 생성하면
-- ORA-08004: sequence SEQ_MEMBER_ID.NEXTVAL exceeds MAXVALUE and cannot be instantiated

---- (2) CURRVAL : 시퀀스에서 현재 생성된 번호 확인
--                 시퀀스 생성 수 NEXTVAL 한번도 호출된 적 없으면 비활성화 상태

--          사용법 : 시퀀스이름.CURRVAL
SELECT SEQ_MEMBER_ID.CURRVAL
  FROM dual
;

CREATE SEQUENCE seq_test
;
SELECT seq_test.CURRVAL
  FROM dual;
/* NEXTVAL 최초 한번 실행 전 CURRVAL 를 실행하면 아래와 같은 오류
ORA-08002: sequence SEQ_TEST.CURRVAL is not yet defined in this session
*/
DROP SEQUENCE seq_test;

-- 3. 시퀀스 수정 : ALTER SEQUENCE 
--                생성한 시퀀스 seq_member_id 의 MAXVALUE 옵션을 NOMAXVALUE로
ALTER SEQUENCE seq_member_id
NOMAXVALUE
;
-- Sequence SEQ_MEMBER_ID이(가) 변경되었습니다.

-- 4. 시퀀스 삭제 : DROP SEQUENCE
--                생성한 시퀀스 seq_member_ID 삭제
DROP SEQUENCE seq_member_id
;

-- 멤버 아이디에 조합할 시퀀스 신규 생성
CREATE SEQUENCE seq_member_id
START WITH 1
NOMAXVALUE
NOCYCLE
;

-- 일괄적으로 증가하는 값을 멤버아이디로 자동생성
-- 'M01', 'M02', ...'M0x' 이런 형태의 값을 조합

SELECT 'M' || LPAD(seq_member_id.NEXTVAL, 2, 0) as member_id
  FROM dual;
  
INSERT INTO new_member(member_id, member_name)
VALUES (SELECT 'M' || LPAD(seq_member_id.CURRVAL, 2, 0) as member_id
       FROM dual
     , '허균')
;

----------------------------------------------------------------------
-- INDEX : 데이터의 검색(조회)시 일정한 검색 속도를 보장하기 위하여
--         DBMS 가 관리하는 객체

-- 1. user_indexes 딕셔너리에서 검색
SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes i
;  

-- 2. 테이블의 주키(PK) 컬럼에 대해서는 이미 DBMS가 자동으로
--    인덱스 생성함
--    따라서 또 생성 시도시 생성 불가능

-- 예_ member 테이블의 member_id 컬럼에 인덱스 생성 시도
CREATE TABLE INDEX idx_member_id
ON member (member_id)
;

-- 테이블의 주키 컬럼에는 이미 있으므로 오류 발생
-- 생성한느 인덱스 이름이 달라도 생성할 수 없음.

-- 3. 복사한 테이블인 new_member 에는 PK 가 없으므로 인덱스도 없는 상태
--   (1) new_member 테이블에 index 생성 시도
CREATE INDEX idx_new_member_id
ON new_member(member_id)
;
--Index IDX_NEW_MEMBER_ID이(가) 생성되었습니다.

-- 1. user_indexes 딕셔너리에서 검색
SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes i
;  

-- IDX_NEW_MEMBER_ID   NORMAL NEW_MEMBER SCOTT

--- (2) 대상 컬럼이 중복 값이 없는 컬럼임이 확실하다면
--      UNIQUE 인덱스 생성이 가능

Drop index idx_new_member_id;

CREATE UNIQUE INDEX IDX_NEW_MEMBER_ID
ON new_member(member_id)
;

SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes i
;  
-- INDEX 가 명시적으로 사용되는 경우

-- 오라클에 빠른 검색을 위해 HINT 절을 SELECT에 사용하는
-- 경우가 존재

