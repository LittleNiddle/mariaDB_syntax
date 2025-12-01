# window에서는 redis가 직접 설치가 안됨 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속 명령어
redis-cli

# docker에서 실행되는 프로세스 확인
docker ps

# docker에 설치된 redis 접속 명령어
docker exec -it 컨테이너ID redis-cli

# 나가기
exit

# redis 는 0~15번까지의 db로 구성(default 0번)
# db번호 선택
select db번호

# db 내 모든 키값 조회
keys *

# String 자료구조
# set 키:value 형식으로 값 세팅
set user:email:1 hong@naver.com
set user:email:2 hong2@naver.com
# 이미 존재하는 key에 set 하면 덮어쓰기
set user:email:1 hong2@naver.com
# key값이 이미 존재하면 pass시키고 없을때만 set 하기 위해서는 nx 옵션 사용
set user:email:1 hong3@naver.com nx
# 만료시간(TTL(time to live)) 설정은 ex옵션 사용(초단위)
set user:email:2 hong2@naver.com ex 30
# get key를 통해 value 값 구함
get user:email:1
# 특정 key값 삭제
del key값
# 현재 DB내 모든 key값 삭제
flushdb

# redis String 자료구조 실전활용
# 사례 1 : 좋아요 기능 구현 -> 동시성 이슈 해결
set likes:posting:1 0 # redis는 기본적으로 모든 key:value가 문자열. 그래서 0으로 세팅해도 내부적으로 "0"으로 저장
incr likes:posting:1 # 특정 key 값의 value를 1만큼 증가시킴
decr likes:posting:1 # 특정 key 값의 value를 1만큼 감소시킴

# 사례 2 : 재고 관리 -> 동시성 이슈 해결
set stok:product:1 100
incr stok:product:1 
decr stok:product:1 

# 사례 3 : 로그인 성공시 토큰 저장 -> 빠른 성능
set user:1:refresh_token abcdexxxx ex 1800

# 사례 4 : 데이터 캐싱 -> 빠른 성능
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조
# redis의 list는 deque와 같은 자료구조. 즉, double-ended-queue구조
lpush students kim1
lpush students lee1
rpush students park1
lpop
rpop
# list 조회
lrange students 0 2 # 0번째부터 2번째까지
lrange students 0 -1 # 0번째부터 끝까지
lrange students 0 0 # 0번째 값
# list값 꺼내기(꺼내면서 삭제)
rpop students
lpop students
# A리스트에서 rpop하여 B리스트에 lpush : 잘 안씅메
rpoplpush A리스트 B리스트 
rpoplpush students students
# list의 데의 데이터 개수 조회
llen students
# expire, ttl 문법 모두 사용 가능

# redis List 자료구조 실전활용
# 사례1 : 최근 조회한 상품 목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근 살펴본 상품 리스트 - 중요한 데이터이나 rdb에 넣지 않는다.
# -> zset이 낫다.
# 최근 본 상품목록 3개 조회
lrange user:1:recent:product -3 -1


# set 자료구조 : 중복없음, 순서없음.
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3
# set 조회
smembers memberlist
# set의 멤버 개수 조회 (cardinality)
scard memberlist

# redis set 자료구조 실전 활용
# 사례1. 좋아요 구현
# 게시글 상세보기에 들어가면
scard likes:posting:1 # 좋아요 개수
sismember likes:posting:1 abc@naver.com # 내가 좋아요를 눌렀는지 아닌지 
sadd likes:posting:1 abc@naver.com # 좋아요를 누른 겨우
srem likes:post:1 abc@naver.com # 좋아요 취소

scard likes:posting:1 

deprecated


# zset 자료구조
# zset활용 사례 1 : 최근 본 상품 목록
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간)값만 업데이트
zadd user:1:recent:product 151400 apple
zadd user:1:recent:product 151401 banana
zadd user:1:recent:product 151402 orange
zadd user:1:recent:product 151403 melon
zadd user:1:recent:product 151404 mango
zadd user:1:recent:product 151403 melon
# zset 조회 : zrange(score기준 오름차순 정렬), zrevrange(내림차순 정렬)
zrange user:1:recent:product -3 -1
zrevrange user:1:recent:product 0 2 withscores
# 주식, 코인 등의 실시간 시세 저장


# hashes 자료구조 : value가 map 형태의 자료구조 (key:value, key:value, ... 형태의 구조)
# set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" 과의 비교
hset member:info:1 name hong email hong@daum.net age 30
# 특정값 조회
hget member:info:1 name
# 특정값 수정
hset member:info:1 name hong2
# 빈번하게 변경되는 객체값을 저장 시에는 hashes가 성능 효율적이다.
# 캐싱 -> string or hashes에서 보통은 string을 사용한다.
# 특정 값만 뽑아서 변경 가능하다.


# redis 기능
# pub(publish) sub(subscribe)
# 실시간 서비스
    # 알림
    # 채팅 : 서버에서는 메모리에 사용자 위치정보를 저장하기 때문에 서버가 분산되면 사용자의 위치가 공유되지 않는다.
    # 단점 : redis는 메세지를 저장하지 않기 때문에 유실 가능성이 있다.
    # 장점 : 성능이 빠르다.


