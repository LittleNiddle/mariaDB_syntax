-- 회원 테이블 생성
-- id(PK), email(UNIQUE, NOT NULL), name(NOT NULL), password(NOT NULL)
create table author(
    id bigint auto_increment primary key,
    email varchar(255) not null unique,
    name varchar(255) not null,
    password varchar(255) not null
)
-- 주소 테이블
-- id(PK), country(not null), city(not null), street(not null), author_id(FK, not null)
create table address(
    id bigint  auto_increment primary key,
    country varchar(255) not null,
    city varchar(255) not null,
    street varchar(255) not null,
    author_id bigint not null unique,
    foreign key(author_id) references author(id)
);

-- post 테이블
-- id, title(not null), contents
create table post(
    id bigint auto_increment primary key,
    title varchar(255) not null,
    contents varchar(3000)
);

-- 연결(junction) 테이블
create table author_post_list(
    id bigint auto_increment primary key,
    author_id bigint not null,
    post_id bigint not null,
    foreign key (author_id) references author(id),
    foreign key (post_id) references author(id)
);

-- 복합키를 이용한 연결(junction) 테이블
create table author_post_list(
    author_id bigint not null,
    post_id bigint not null,
    primary key (author_id, post_id),
    foreign key (author_id) references author(id),
    foreign key (post_id) references author(id)
);

-- 회원가입 및 주소 생성
insert into author();
insert into address() values();

-- 글쓰기
insert into post();
insert into author_post_list values(1,2);
insert into author_post_list values(2,2);

-- 글 전체 목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성
select * from post inner join author_post_list inner join author;