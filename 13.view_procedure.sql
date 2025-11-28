-- view : 실제 데이터를 참조만 하는 가상의 테이블. SELECT만 가능
-- 사용목적 : 1) 권한 목적 2) 복잡한 쿼리를 사전 생성, 팀원들과 공유

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a,name, a,email from post p inner join autor a on p.author_id = a.id;

-- view 조회(테이블 조회와 동일)
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view 삭제
drop view author_view;

-- 프로시저 생성
DELIMITER //
CREATE PROCEDURE hello_procedure()
BEGIN
    SELECT "hello world";
END
// DELIMITER ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop hello_procedure();

-- 회원목록 조회 프로시저 생성 -> 한글명 프로시저 가능
DELIMITER //
CREATE PROCEDURE hello_procedure()
BEGIN
    SELECT * FROM author;
END
// DELIMITER ;

-- 회원 상세 조회 --> input(매개변수)값 여러개 사용 가능 --> 프로시저 호출시 순서에 맞게 매개변수 입력
DELIMITER //
CREATE PROCEDURE 회원상세조회(IN idInput BIGINT)
BEGIN
    SELECT * FROM author WHERE ID = idInput;
END
// DELIMITER ;

-- 전체 회원 수 조회 -> 변수사용
DELIMITER //
CREATE PROCEDURE 전체회원수조회()
BEGIN
    -- 변수 선언
    DECLARE authorCount BIGINT;
    -- INTO를 통해 변수에 값 할당
    SELECT count(*) INTO authorCount FROM author;
    -- 변수값 사용
    SELECT authorCount;
END
// DELIMITER ;

-- 글쓰기
DELIMITER //
-- 사용자가 title, contents, 본인의 email 값을 입력
create procedure 글쓰기(IN titleInput varchar(255), contentsInput varchar(255), emailInput varchar(255))
BEGIN
    -- BEGIN 밑에 DECLARE를 통해 변수 선언
    DECLARE authorID BIGINT;
    DECLARE postID BIGINT;
    -- 아래 DECLARE는 변수 선언과는 상관 없는 예외 관련 특수 문법
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        rollback;
    END; 
    START TRANSACTION;
        SELECT a.id INTO authorID FROM author a WHERE a.email = emailInput;
        INSERT INTO post(title, contents) VALUES(titleInput, contentsInput);
        SELECT id INTO postID FROM post p ORDER BY id DESC LIMIT 1;
        INSERT INTO author_post_list(author_id, post_id) VALUES(authorID, postID);
    COMMIT;
END;
// DELIMITER ;

-- 글삭제 -> if else문
DELIMITER //
CREATE PROCEDURE 글삭제(IN postIdInput BIGINT, IN authorIdInput BIGINT)
BEGIN
    DECLARE authorCount BIGINT;
    -- 참여자의 수를 조회
    SELECT count(*) INTO authorCount FROM author_post_list WHERE post_id = postIdInput;
    -- 1이면 글삭제
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
    -- 1이상이면 나만 삭제
END
// DELIMITER ;

-- 대량글쓰기 -> while문을 통한 반복문
DELIMITER //
-- 사용자가 title, contents, 본인의 email 값을 입력
create procedure 글도배(IN count BIGINT, emailInput varchar(255))
BEGIN
    -- BEGIN 밑에 DECLARE를 통해 변수 선언
    DECLARE authorID BIGINT;
    DECLARE postID BIGINT;
    DECLARE countValue BIGINT DEFAULT 0;
    while countValue < count do
        SELECT a.id INTO authorID FROM author a WHERE a.email = emailInput;
        INSERT INTO post(title) VALUES("안녕하세요");
        SELECT id INTO postID FROM post p ORDER BY id DESC LIMIT 1;
        INSERT INTO author_post_list(author_id, post_id) VALUES(authorID, postID);
        SET countValue = countValue + 1;
    end while;
END;
// DELIMITER ;