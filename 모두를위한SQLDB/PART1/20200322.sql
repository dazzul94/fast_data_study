/* ### EXCEPT 연산
 * - 맨위에 select문의 결과 집합에서 그 아래에 있는 select문의 결과 집합을 제외한 결과를 리턴한다.
 * A-B(차집합)
 */

/* 1. 재고가 있는 필름 아이디와 제목을 뽑아라 
 * - 하나의 필름 아이디는 여러개의 재고를 가질수 있다.
 * - distinct를 쓴 이유: 필름과 인벤토리는 1:n 관계이기 때문에 두 테이블을 조인하면 영화1개당 여러개의 재고가 나온다.
 *   영화제목도 여러개가 나올것이고 그것을 distinct로 제거시킴 */
select 	
	distinct b.film_id,
	b.title
from 
	inventory a
inner join 
	film b
on a.film_id = b.film_id
order by b.title;

/* 2. 재고가 존재하지 않는 필름 아이디와 제목을 뽑아라 
 * 전체 필름집합 - 재고가 존재하는 집합을 뺀다. */
select 
	film_id,
	title
from film
except 
select 	
	distinct inventory.film_id,
	title
from 
	inventory
inner join 
	film
on film.film_id = inventory.film_id
order by title;

/* 3. 검증 SQL */
select * from inventory
where film_id = '33';

select * from inventory
where film_id = '36';

select * from inventory
where film_id = '38';

---------------------------------------------------------------------------
/* ### 서브쿼리 
 * - SQL문 내에서 메인 쿼리가 아닌 하위에 존재하는 쿼리를 말한다. 
 * - 서브쿼리를 활용함으로써 다양한 결과를 도출할 수 있다. */
-- 종류: 중첩 서브쿼리, 인라인 뷰, 스칼라 서브쿼리 

/* 1. RENTAL_RATE의 평균을 구한다. */

select 	
	avg(rental_rate)
from film;

/* 2. 평균보다 큰 RENTAL_RATE 집합 구하기*/
select 
	film_id,
	title,
	rental_rate
from film 
where rental_rate > 2.98;

/* 3. 중첩 서브쿼리(위의 두개의 SQL을 합쳐서 하나로 만들자) 
 * - WHERE절에 들어가는 서브쿼리 */
select 
	film_id,
	title,
	rental_rate
from film 
where rental_rate > 
(
	select 	
		avg(rental_rate)
	from film
);

/* 4. 인라인 뷰 
 * - FROM 절에 있는 서브쿼리 */
select 
	a.film_id,
	a.title,
	a.rental_rate
from film a,
	(
		select 
			avg(rental_rate) as avg_rental_rate
		from film
	) b
where a.rental_rate > b.avg_rental_rate;

/* 5. 스칼라 서브쿼리의 활용 
 * - select리스크에 안에 있는 서브쿼리 */

-- 인라인 뷰와 스칼라 서브쿼리를 모두 사용 
select 
	a.film_id,
	a.title,
	a.rental_rate 
from 
(
	select 
		a.film_id,
		a.title,
		a.rental_rate,
		(
			select 
				avg(rental_rate)
			from film l
		) as avg_rental_rate
	from film a
) a 
where a.rental_rate > a.avg_rental_rate;
