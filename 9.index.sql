-- pk, fk, unique 제약조건 추가 시에 해당 column에 대해 index 페이지 자동 생성
-- 조회가 빈번하기 때문에
-- 별도의 컬럼에 대해 index 추가 생성 가능

-- index 조회
show index from author;

-- index 삭제
alter table author drop index 인덱스명;
alter table author drop index name_idx;

-- index 생성 : 시간이 엄청 오래 결림(이미 데이터가 있는 경우)
create index 인덱스명 on 테이블명(컬럼명);
create index name_idx on author(name);

-- index는 1컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능
-- 이 경우 두 컬럼을 and 조건으로 조회해야만 index를 사용
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);
where 컬럼1 = ? and 컬럼2 = ?
-- 1) 두 컬럼을 대상으로 인덱스 설정
-- 2) 컬럼1에만 인덱스가 만들어져 있다면
-- 3) 컬럼2에만 인덱스가 만들어져 있다면
-- 4) 컬럼1, 컬럼2에 각각 인덱스가 있는 경우

-- index 성능 테스트
-- 기존 테이블 삭제 후 간단한 테이블로 index 설정 또는 미설정 테스트
create table author(
    id bigint auto_increment,
    email varchar(255),
    name varchar(255),
    primary key(id));

create table author(
    id bigint auto_increment,
    email varchar(255) unique,
    name varchar(255),
    primary key(id));


-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;