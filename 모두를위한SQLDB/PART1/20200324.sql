/* ### 실습 문제 1
 * 아래 SQL문은 FILM 테이블을 2번이나 스캔하고 있다. 
 * FILM 테이블을 한번만 SCAN하여 동일한 결과 집합을 구하는 SQL을 작성하라. 
 * */
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

-- 내가 한거
select 
	film_id,
	title,
	rental_rate 
from (
	select 
		film_id,
		title,
		rental_rate,
		avg(rental_rate) over() avg_rate
	from film
) a
where rental_rate > avg_rate;

-- 선생님이 한거
select 
	avg(rental_rate)
from film;

select 
	film_id,
	title,
	rental_rate
from( 
	select 
		a.film_id,
		a.title,
		a.rental_rate,
		avg(a.rental_rate) over() as avg_rental_rate --분석함수
	from film a
) a -- 인라인 뷰
where rental_rate > avg_rental_rate;

-------------------------------------------------------------------------
/* ### 실습문제2 
 * - 아래 SQL문은 EXCEPT 연산을 사용하여 재고가 없는 영화를 구하고 있다. 
 * 해당 sQL문을 EXCEPT연산을 사용하지 말고 같은 결과를 도출하라.*
 */ 
-- 재고가 없는 film을 뽑아라.(문제의 SQL)
select 
	film_id,
	title
from film
except 
select 
	distinct inventory.film_id,
	title 
from inventory
inner join film 
   on film.film_id = inventory.film_id 
order by title;

-- 내가 한거
select 
	film_id,
	title
from film a
where not exists (
	select 
		distinct film_id 
	from inventory b
	where a.film_id = b.film_id
)
order by title;



-- 선생님이 한거
select 
	a.film_id,
	a.title
from film a
where not exists (
	select 
		1
	from inventory b, film c
	where b.film_id = c.film_id
	  and a.film_id = c.film_id
)
order by title;

select 
	a.film_id,
	a.title
from film a
where not exists (
	select 
		1
	from inventory b
	where a.film_id = b.film_id
)
order by title;

-----------------------------------------------------
/* ### INSERT문
 * - 컬럼을 지정하지 않고, 컬럼을 지정하고 넣을 수 있다. (자동/수동) 
 * */
create table link(
	id serial primary key,
	url varchar(255) not null,
	name varchar(255) not null,
	description varchar(255),
	rel varchar(50)
);

select * from link;

/* 1. 인서트 */
insert 
into link
	(url, name)
values
	('http://naver.com', 'Naver');
commit;

select * from link;

/* 2. 작은따옴표 인서트*/
insert 
into link
	(url, name)
values
	('''http://naver.com''', '''Naver''');
commit;

select * from link;

/* 3. 동시에 n개의 로우 인서트 */
insert 
into link
	(url, name)
values
	('http://naver.com', 'Naver'),
	('http://yahoo.com', 'Yahoo'),
	('http://bing.com', 'Bing');
commit;

select * from link;

/* 4. 테이블을 테이블에 입력*/

-- 껍데기를 복사
create table link_tmp as 
select * from link where 0=1;

select * from link_tmp;

-- 내용 복사
insert 
	into link_tmp
select * 
from link;

select * from link_tmp;

-- 동일한지 확인
select * from link_tmp
except 
select * from link; -- 두개의 집합이 동일하다.

select * from link
except 
select * from link_tmp; -- 두개의 집합이 동일하다.(반대도 해야함)