CREATE TABLE book (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    category BIGINT NOT NULL
);

CREATE TABLE realBook (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bookID BIGINT NOT NULL,
    status ENUM('available', 'borrowed') NOT NULL DEFAULT 'available',
    location VARCHAR(255) NOT NULL,
    FOREIGN KEY (bookID) REFERENCES book(id)
);

CREATE TABLE member (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user'
);

CREATE TABLE borrowing (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    memberID BIGINT NOT NULL,
    borrowingDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    dueDate DATE NOT NULL,
    FOREIGN KEY (memberID) REFERENCES member(id)
);

CREATE TABLE borrowingDetail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    borrowingID BIGINT NOT NULL,
    realBookID BIGINT NOT NULL,
    returnDate DATE,
    FOREIGN KEY (borrowingID) REFERENCES borrowing(id),
    FOREIGN KEY (realBookID) REFERENCES realBook(id)
);

-- TEST QUERY
-- 1. 회원 가입
    -- 관리자
insert into member(name, email, role) values('관리자', 'abc@naver.com', 'admin');
    
    -- 회원
insert into member(name, email, role) values('사용자', 'bcd@naver.com', 'user');

-- 2. 도서 등록
-- role이 admin이면
insert into book(ISBN, title, author, category) values('978-89-954321-1-5', '책1', '저자1', 100);
insert into realBook(bookID, location) values((select id from book order by id desc limit 1), '100 서가');

insert into book(ISBN, title, author, category) values('978-89-954321-2-5', '책2', '저자2', 200);
insert into realBook(bookID, location) values((select id from book order by id desc limit 1), '200 서가');

insert into book(ISBN, title, author, category) values('978-89-954321-3-5', '책3', '저자3', 300);
insert into realBook(bookID, location) values((select id from book order by id desc limit 1), '300 서가');

insert into book(ISBN, title, author, category) values('978-89-954321-4-5', '책4', '저자4', 400);
insert into realBook(bookID, location) values((select id from book order by id desc limit 1), '400 서가');

-- 3. 도서 대출
-- 1번 사용자가 1,2를 빌림
insert into borrowing(memberID, borrowingDate, dueDate) values('1', CURRENT_DATE, CURRENT_DATE + 14);
insert into borrowingDetail(borrowingID, realBookID) values((select id from borrowing order by id desc limit 1), 1);
update realBook set status = 'borrowed' where id = 1;
insert into borrowingDetail(borrowingID, realBookID) values((select id from borrowing order by id desc limit 1), 2);
update realBook set status = 'borrowed' where id = 2;

-- 4. 도서 반납
update borrowingDetail set returnDate = CURRENT_DATE where borrowingID = '1' and realBookID = '1';
update realBook set status = 'available' where id = 1;

update borrowingDetail set returnDate = CURRENT_DATE where borrowingID = '1' and realBookID = '2';
update realBook set status = 'available' where id = 2;
