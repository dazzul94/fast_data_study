------------------------------------------------------------------
/* * ### IN: ~안에 * 값이 존재하는지 확인 */

/* 1. IN 예제: 특정 집합이 존재하는지 확인
* + null이 제일 큰값으로 나옴
*/
select
	customer_id,
	rental_id,
	return_date
from rental r
where customer_id in ('1','2') -- customer_id가 1 '또는' 2에 속해있는지 확인
order by return_date desc;

/* 2. OR 연산자의 활용
* (IN연산자는 기본적으로 OR연산자 디폴트) */
select
	customer_id,
	rental_id,
	return_date
from rental r
where customer_id = '1'
   or customer_id = '2'
order by return_date desc;
-- IN 연산자를 이용하는 것이 좋다
-- WHY? 1) 가독성 좋다. 2) 옵티마이저 특성상 성능상 유리하다

/* 3. NOT IN(IN의 반대)
* 여집합
* (1 혹은 2가 아닌것) = (1과 2를 제외한 나머지 전부) */
select
	customer_id,
	rental_id,
	return_date
from rental r
where customer_id not in ('1','2')
order by return_date desc;

/* 4. NOT IN 연산자는 'AND' && '<>'과 같다 */
select
	customer_id,
	rental_id,
	return_date
from rental r
where customer_id <> '1'
  and customer_id <> '2'
order by return_date desc;
-- 마찬가지로 NOT IN 연산자를 이용하는 것이 좋다
-- WHY? 1) 가독성 좋다. 2) 옵티마이저 특성상 성능상 유리하다

/* 5. 서브쿼리 이용
* 2005년 5월 27일에 렌탈한 고객의 성과 이름을 조회 */
select
	first_name,
	last_name
from customer
where customer_id in ( 
	select
		customer_id
	from rental r
	where cast(return_date as date) = '2005-05-27');
-- timestamp를 date로 변환

/* rental 테이블에 성과 이름을 추가한다면?
* 그것은 데이터의 중복이다.
* 성능때문에 넣는 경우가 있긴 하지만
* 일반적으로는 전혀 그렇지 않다. */

------------------------------------------------------------------
/* ### BETWEEN 연산자
* 어떤 집합에서 특정 범위에 들어가는 집합을 조회할 때 사용
* COL_NM BETWEEN A AND B: A와 B 사이의 값
* = COL_NM >= VALUE A AND COL_NM <= B */

/* 1.BETWEEN */
select
	customer_id,
	payment_id,
	amount
from payment p
where amount between 8 and 9;

/* 2.WHERE 조건으로 */
select
	customer_id,
	payment_id,
	amount
from payment p
where amount >= 8 and amount <= 9;
-- BETWEEN으로 조회하는 것이 가독성이 더 좋다. 코드가 길어지면 더 낫다.

/* 3. NOT BETWEEN: BETWEEN 을 부정 */
select
	customer_id,
	payment_id,
	amount
from payment p
where amount not between 8 and 9;

/* 4. NOT BETWEEN을 WHERE 조건으로 */
select
	customer_id,
	payment_id,
	amount
from payment p
where amount < 8 or amount > 9;
-- NOT BETWEEN으로 조회하는 것이 가독성이 더 좋다. 코드가 길어지면 더 낫다.

/* 5. 일자비교시에 많이 쓴다.
* timestamp를 date로 캐스팅 */
select
	customer_id,
	payment_id,
	amount,
	payment_date
from payment
where cast(payment_date as date) between '2007-02-07' and '2007-02-15';

/* 6. 일자비교시에 많이 쓴다.
* 5번과 같은 결과
* timestamp를 char형으로 캐스팅 */
select
	customer_id,
	payment_id,
	amount,
	payment_date,
	to_char(payment_date, 'YYYY-MM-DD'),
	cast(payment_date as date)
from payment
where to_char(payment_date, 'YYYY-MM-DD') between '2007-02-07' and '2007-02-15';
/* to_char(payment_date, 'YYYY-MM-DD') 와
* cast(payment_date as date) 의 출력결과는 다르지만
* between을 써서 제한한 결과 집합은 동일하다
* 동일한 SQL이라고 볼 수 있다. */