-- 흐름 제어 : if, ifnull, case when
-- if(a, b, c) : a 조건이 참이면, b 반환, 거짓이면 c를 반환
select id, if(name is null, '익명사용자', name) as name from author;

-- ifnull(a, b) : a가 null이면 b를 반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자') as name from author;

-- case when end : 
select id,
case
 when name is null then '익명사용자'
 when name = 'hong1' then '홍길동1'
 when name = 'hong2' then '홍길동2'
 else name
end as name
from author;

