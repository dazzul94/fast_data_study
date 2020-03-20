/* ### PART3 실습문제1*/ 
/* 1. RENTAL 테이블을 이용하여 연, 연월, 연월일, 전체 각각의 기준으로 
 * RENTAL_ID 기준 렌탈이 일어난 횟수를 출력하라(전체 데이터 기준으로 모든 행을 출력)*/ 
-- 전체 개수 
select 
	count(*) 
from rental; 
-- 내가 한거(틀림) 
select 
	rental_id, 
	yyyy, 
	yyyymmm, 
	yyyymmdd, 
	count(rental_id) over (partition by yyyy) as yyyy_cnt, 
	count(rental_id) over (partition by yyyymmm) as yyyymmm_cnt, 
	count(rental_id) over (partition by yyyymmdd) as yyyymmdd_cnt, 
	count(rental_id) over () as all_cnt 
from 
	( select 
		rental_id, 
		to_char(rental_date, 'YYYY') as yyyy, 
		to_char(rental_date, 'YYYYMM') as yyyymmm, 
		to_char(rental_date, 'YYYYMMDD') as yyyymmdd, 
		inventory_id, 
		customer_id, 
		return_date, 
		staff_id, 
		last_update 
	from rental ) a;

--선생님이 한거 
-- 1. 연별 
select 
	count(*), 
	to_char(rental_date, 'YYYY') 
from rental 
group by to_char(rental_date, 'YYYY'); 
-- 월별 
select 
	count(*), 
	to_char(rental_date, 'YYYYMM') 
from rental 
group by to_char(rental_date, 'YYYYMM') 
order by to_char(rental_date, 'YYYYMM'); 
-- 일별 
select 
	count(*), 
	to_char(rental_date, 'YYYYMMDD') 
from rental 
group by to_char(rental_date, 'YYYYMMDD') 
order by to_char(rental_date, 'YYYYMMDD'); 
-- 전체 
select 
	count(*) 
from rental; 
-- 롤업을 이용 
select 
	to_char(rental_date, 'YYYY'), 
	to_char(rental_date, 'MM'), 
	to_char(rental_date, 'DD'), 
	count(*) 
from rental 
group by rollup( 
	to_char(rental_date, 'YYYY'), 
	to_char(rental_date, 'MM'), 
	to_char(rental_date, 'DD') ); 
------------------------------------------------------------------------------- 
/* ### PART3 실습문제2 
 *  - RENTAL과 CUTOMER 테이블을 이용하여 
 * 현재까지 가장 많이 RENTAL을 한 고객의 고객ID, 렌탈순위, 누적렌탈횟수, 이름을 출력하라 * 예시) 
 * customer_id / rental_rank(1)/rental_count(46)/first_name/last_name */

-- 내가 한거(난 왜 랭크를 썼지? 근데 랭크써도 첫번째 사람이기 때문에 상관은 없다.)
select 
	c.customer_id,
	rank() over (order by rental_count desc) rental_rank,
	c.rental_count,
	c.first_name,
	c.last_name
from 
	( 
	select 
		a.customer_id,
		count(*) rental_count,
		b.first_name, 
		b.last_name 
	from rental a 
	join customer b 
	on a.customer_id = b.customer_id 
	group by a.customer_id, b.first_name, b.last_name 
	order by rental_count desc ) c
limit 1;

-- 선생님이 한거(조인이 필요하고, 순위, 분석함수가 필요하다.)

-- 1) max이용(중복이 아니기 떄문에 가능하다.)
select 
	row_number () over (order by count(rental_id) desc) as rental_rank, -- 전체이기 때문에 partition by는 필요없다.
	a.customer_id,
	count(*) as rental_count,
	max(b.first_name) first_name,
	max(b.last_name) last_name
from rental a, customer b
where a.customer_id = b.customer_id
group by a.customer_id
order by rental_count desc
limit 1;

-- 2) 서브쿼리 이용
select 
	a.rental_rank,
	a.customer_id,
	a.rental_count,
	b.first_name,
	b.last_name
from (
	select 
		row_number () over (order by count(rental_id) desc) as rental_rank, -- 전체이기 때문에 partition by는 필요없다.
		a.customer_id,
		count(*) as rental_count
	from rental a, customer b
	where a.customer_id = b.customer_id
	group by a.customer_id
	order by rental_count desc
	limit 1
) a, customer b
where a.customer_id = b.customer_id