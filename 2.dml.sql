-- insert : 테이블에 데이터 삽입
INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3) VALUES(데이터1, 데이터2, 데이터3)
-- 문자열은 일반적으로 작은따옴표 사용
INSERT INTO author(id, name, email) VALUES(4, 'hongildong4', 'hongildong4@naver.com')

-- update : 테이블에 데이터를 변경
UPDATE athor SET name='홍길동', email='hong100@naver.com' WHERE id=3;

-- delete : 삭제
DELETE FROM 테이블명 WHERE 조건;
DELETE FROM author WHERE id=4;

-- select : 조회
 컬럼1, 컬럼2 FROM 테이블명;
SELECT name, email FROM author;
-- *은 모든 column을 의미한다.
SELECT * FROM author;

-- select 조건절(where) 활용
SELECT * FROM author WHERE id = 1;
SELECT * FROM author WHERE name = '홍길동';
SELECT * FROM author WHERE id > 2 AND name='홍길동';
SELECT * FROM author WHERE id in (1,3,5);
-- 이름이 홍길동인 글쓴이가 쓴 글 목록을 조회하시오.
SELECT * FROM author WHERE id in (SELECT id FROM author WHERE name = '홍길동');

-- 중복제거 조회 : distinct
SELECT DISTINCT name FROM author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순, desc : 내림차순, 안붙이면 오름차순(default)
-- 아무런 정렬 조건 없이 조회할 경우에는 PK 기준 오름차순
SELECT * FROM author ORDER BY email DESC;

-- 멀티컬럼 ORDER BY : 여러 컬럼으로 정렬시에, 먼저 쓴 컬럼 우선 정렬후, 중복시 그 다음 컬럼으로 정렬 적용.
SELECT * FROM author ORDER BY name DESC, email ASC;

-- 결과값 개수 제한
-- 가장 최근에 가입한 회원 1명만 조회
SELECT * FROM author ORDER BY id DESC LIMIT 1;

-- 별칭(alias)를 이용한 select
SELECT name AS '이름', email AS '이메일' from author;
SELECT a.name, a.email FROM author AS a;
SELECT a.name, a.email FROM author a;

-- null을 조회 조건으로 활용
SELECT * FROM author WHERE password IS NULL;
SELECT * FROM author WHERE password IS NOT NULL;

-- 프로그래머스 sql 문제풀이
