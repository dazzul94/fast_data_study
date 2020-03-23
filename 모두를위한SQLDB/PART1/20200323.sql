/* any 연산자는 값을 서브 쿼리에 의해 반환된 값 집합과 비교한다.
 * any 연산자는 서브쿼리의 값이 어떠한 값이라도 만족을 하면 조건이 성립된다.
 */

/*1. 카테고리별 가장 높은 상영시간 중 어떤 값보다 같거나 큰걸 모두 뽑는다. */
select 
	title, length
from film
where length >= any 
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

/*2. ANY가 없으면 한건만 나와야 한다. 
 * 오류: 표현식에 사용된 서브쿼리 결과가 하나 이상의 행을 리턴했습니다*/ 
select 
	title, length
from film
where length >= 
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

select 
	title, length
from film
where length >= 
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
	limit 1 -- 하나만 나오게 하면 오류 안난다.
)

/* 3. = ANY 로 이 값들 중에서 같으면 뽑는다. IN과 동일하다. */
select 
	title, length
from film
where length = any 
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

select 
	title, length
from film
where length in
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)


-- 오류: 표현식에 사용된 서브쿼리 결과가 하나 이상의 행을 리턴했습니다
select 
	title, length
from film
where length =
(
	-- 카테고리별 가장 높은 상영시간
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

------------------------------------------------------------------------------------
/* ### ALL연산자
 * - 서브 쿼리에 의해 반환된 값 집합과 비교한다.
 * ALL 연산자는 서브쿼리의 모든 값이 만족을 해야만 조건이 성립된다.
 */

/* 1. 그룹별 평균 모두 보다 큰 것 */
select title, length 
from film
where length >= all 
(
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

-- 오류: 표현식에 사용된 서브쿼리 결과가 하나 이상의 행을 리턴했습니다
select title, length 
from film
where length >=  
(
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
)

select title, length 
from film
where length >=  
(
	select max(length)
	from film a, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
	limit 1
)

/* 2. 평가기준 평균값들보다 상영시간이 긴 영화를 출력 */
select
	film_id,
	title, 
	length
from film
where length > all 
(
	select round( avg(length), 2)
	from film 
	group by rating 
)
order by length;
---------------------------------------------------------------------------------
/* ### EXIST 엄청엄청 많이 쓰인다.********************************
 * 서브쿼리 내에 집합이 존재하는지 존재 여부만을 판단한다.
 * 존재 여부만을 판단하므로 연산 시 부하가 줄어든다.
 */

/* 1. 고객 중에서 지불내역이 11 보다 큰 고객이 있는지 확인 
 * - 해당 집합이 존재하기만 하면 더이상 연산을 멈추므로 성능상 유리함 */
select
	first_name,
	last_name 
from customer c 
where exists (
		select 1 
		from payment p
		where p.customer_id = c.customer_id 
		  and p.amount > 11
	)
order by first_name, last_name;

/* 2. NOT EXIST 
 * - 해당 집합이 존재하기만 하면 더이상 연산을 멈추므로 성능상 유리함 */
select
	first_name,
	last_name 
from customer c 
where not exists (
		select 1 
		from payment p
		where p.customer_id = c.customer_id 
		  and p.amount > 11
	)
order by first_name, last_name;


/* 3. NOT EXIST 개수와 EXIST 개수를 합치면 customer 전체가 나온다.*/
select count(*) from customer;

select 
(
	select
		count(*)
	from customer c 
	where exists (
			select 1 
			from payment p
			where p.customer_id = c.customer_id 
			  and p.amount > 11
		)
	) 
+ 
(
	select
		count(*)
	from customer c 
	where not exists (
			select 1 
			from payment p
			where p.customer_id = c.customer_id 
			  and p.amount > 11
		)
)