-- tinyint : 1바이트 사용. -128~127까지의 정수 표현 가능. (unsigned 0~255)
-- author 테이블에 age column 추가
update author add column age (unsigned tinyint);
alter table author add column age tinyint unsigned;

-- int : 4바이트 사용. 대략 40억 숫자범위 표현 가능.


-- bigint : 8바이트 사용. 많음...
-- author, post 테이블의 id 값을 bigint로 변경
alter table author modify column id bigint
alter table post modify column author_id bigint
alter table post modify column id bigint

-- id의 type을 바꾸려면 author_id에 위배되고 반대도 마찬가지
-- 제약조건을 끊어준 후 작업 필요

-- decimal(총자리수, 소수부자리수) : 실수의 정확한 연산을 위해 사용한다.
alter table author add column height decimal(4,1)
-- 정상적으로 insert
insert into author(id, name, email, height) values(7, 홍길동3, 'sss@naver.com', 175.5);
-- 데이터가 잘리도록 insert
insert into author(id, name, email, height) values(8, 홍길동4, 'asld@naver.com', 175.55);

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column id_number char(16);
alter table author add column self_introduction text;

-- blob(바이너리 데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는 이미지를 별도로 저장하고 이미지 경로를 varchar로 저장한다.
alter table author add column profile_image longblob;
insert into author(id, name, email, profile_image) values(9, 'avc', 'avc@naver.com', LOAD_FILE("C:\\image.jpg"));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user';
-- enum에서 지정된 role된 insert
insert into author(id, name, email, role) values(11, '홍길동', 'asdfa@naver.com', 'admin');
-- enum에서 지정되지 않은 값을 insert --> error 발생
insert into author(id, name, email, role) values(12, '홍길동', 'asdfa@naver.com', 'super-admin');
-- role을 지정하지 않고 insert
insert into author(id, name, email) values(13, '홍길동', 'asdfa@naver.com');

-- date(연월일)와 datetime(연월일시분초)
-- 날짜타입의 입력 수정 조회시에는 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, comtents, author_id, created_time) values(4, 'hello', 'hello ...', 1, '2019-01-01 14:00:30');
-- datetime과 default 현재시간 입력은 많이 사용되넌 패턴
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, contents, author_id) values(5, 'hello', 'hello...', 3);

-- 비교연산자
select * from author where id >= 2 amd id <= 4;
select * from author where id in (2,3,4);
select * from author where id between 2 and 4;

-- LIKE : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp : 정규표현식을 활용한 조회 (중요)
select * from author where name regexp '[a-z]'; -- 이름에 소문자 알파벳이 포함된 경우.
select * from author where name regexp '[가-힣]'; -- 이름에 한글이 포함된 경우.

-- 타입변환 - cast
-- 문자 -> 숫자
select cast('12' as unsigned); -- int 말고 unsigned로 쓴다(관례).
-- 숫자 -> 날짜
select cast(20251121 as date); -- 2025-11-21
-- 문자 -> 날짜
select cast('20251121' as date); -- 2025-11-21

-- 날짜 타입 변환 - date_format(Y, m, d, H, i, s) 주로 where 조건절에 사용된다.
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%Y') = '2025';
select * from post where date_format(created_time, '%m') = '05';
select * from post where cast(date_format(created_time, '%m') as unsigned) = 5;

-- 실습 : 2025년 11월에 등록된 게시글 조회.
select * from post where cast(date_format(created_time, '%Y-%m')) = '2025-11';
select * from post where created_time like '2025-11%';

-- 실습 : 2025년 11월 1일부터 11월 19일 까지의 데이터를 조회
select * from post where created_time >= '2025-11-01' && created_time < '2025-11-20';
