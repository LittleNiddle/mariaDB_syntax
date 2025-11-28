-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
-- % : 원격에서 접속이 가능한 계정 <> localhot : 내 컴퓨터 계정만 접속
create user 'marketing'@'%' identified by 'test4321';

-- 사용자에게 권한 부여 (white listing)
grant select on board.author to 'marketing'@'%';
grant select, insert on board.* to 'marketing'@'%';
grant all privileges on board.* to 'marketing'@'%';

-- 사용자 권한 회수
revoke select on board.author from 'marketing'@'%';

-- 사용자 권한 조회
show grants for 'marketing'@'%';

-- 사용자 계정 삭제
drop user 'marketing'@'%';