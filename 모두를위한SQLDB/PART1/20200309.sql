/* * ### LIMIT: 출력하는 행의 수를 한정하는 역할
* - LIMIT N OFFSET M: 출력하는 행의 수를 지정하면서 시작위치를 지정한다.
* OFFSET M값의 시작위치는 0이다.
*/

/*1. limit 예제 */
select
	film_id, title, release_year
from film f
order by film_id
limit 5;

/*2. offset
* - 게시판에서 많이 사용
* - 페이징할때 사용(2번을 눌렀을 때. 10번부터 10개씩)
*/
select
	film_id, title, release_year
from film f
order by film_id
limit 5 offset 3; -- 4번째 row부터 5개 제한

/*3. offset
* - order by desc*/
select
	film_id, title, rental_rate
from film f
order by rental_rate desc
limit 10 offset 3;
------------------------------------------------------------------

/* * ### FETCH: 특정 집합을 출력 시 출력하는 행의 수를 한정하는 역할을 한다.
* 부분 범위 처리시 사용한다.
* offset in rows : 시작위치를 지정한다. */

/* * 1. 숫자 지정없이 fetch first row only */
select
	film_id, title
from film f
order by title
fetch first row only;

/* * 2. 숫자 지정 fetch first 1 row only = fetch first row only */
select
	film_id, title
from film f
order by title
fetch first 1 row only;

/* * 3. 숫자 지정 fetch first 5 row only
* 지정한 숫자만큼 데이터가 나온다. */
select
	film_id, title
from film f
order by title fetch first 5 row only;

/* * 4. 시작점 세팅 * offset 5 rows */
select
	film_id, title
from film f
order by title offset 5 rows -- 시작은 6부터
fetch first 5 row only; -- 다섯 건을 뽑는다.