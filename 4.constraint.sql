-- not null 제약 조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약 조건 제거
alter table author modify column name varchar(255);
-- not null에 unique 동시 추가
alter table author modify column email varchar(255) not null unique;

-- pk/fk 추가/제거
-- 1. describe post;
-- 2. 제약 조건 테이블 조회 : select * from information_schema.key_column_usage where table_name='post';
-- 
-- pk 제약 조건 제거
alter table post drop primary key;
-- fk 제약 조건 제거
alter table post drop foreign key post_fk;
-- pk 제약 조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약 조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

-- 1. 기존 fk 삭제
-- 2. 새로운 fk 추가(on update / on delete 변경)
-- 3. 새로운 fk에 맞는 테스트
--     3-1. 삭제 테스트
delete from author where id = 3;
--     3-2. 수정 테스트
update author set id = 15 where id = 2;

-- default 옵션 (주로 null과 enum에서 사용된다.)
alter table author modify column name varchar(255) default'anonymous';
-- auto_increment : 숫자값을 입력 안했을때, 마지막에 입력된 가장 큰 값에 +1만큼 자동으로 증가된 숫자값 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

alter table post add column user_id char(36) not null default (uuid());
