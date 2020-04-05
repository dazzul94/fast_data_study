/* ### 조건 연산자 
 * - CASE문 
 * IF/ELSE문과 같은 로직을 구사할 수 있다.
 */
/* 1. case문 실습 1*/
/* 1) 하나의 행으로 3개의 컬럼으로 조회 */
select 
	sum(
		case when rental_rate = 0.99 then 1
		else 0 end) as "C",
	sum(
		case when rental_rate = 2.99 then 1
		else 0 end) as "B",
	sum(
		case when rental_rate = 4.99 then 1
		else 0 end) as "A"
from film;

/* 2) 세개의 행 */
select 
	rental_rate, count(*) cnt 
from film 
group by rental_rate

/* 2. case문 실습2 
 * - 세로로 뽑았던 것을 가로로 뽑음 
 * 행 방식으로 뽑은 것을 열 방식으로 변경 */
select 
	* 
from (
	select 
		sum(
			case when rental_rate = 0.99 then cnt
			else 0 end) as "C",
		sum(
			case when rental_rate = 2.99 then cnt
			else 0 end) as "B",
		sum(
			case when rental_rate = 4.99 then cnt
			else 0 end) as "A"
	from (
		select 
			rental_rate, count(*) cnt 
		from film 
		group by rental_rate
	) a
) a