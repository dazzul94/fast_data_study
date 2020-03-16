/* ### GROUP BY: SELECT 문에서 반환된 행을 그룹으로 나눈다. 
 * 각 그룹에 대한 합계, 평균, 카운트 등을 계산할 수 있다.
 */

/* 1. 단순 GROUP BY
 * 한명의 고객은 여러번의 계산을 할 수 있다.*/
select 
	customer_id
from payment
group by customer_id; -- 중복 값이 제거된 CUSTOMER_ID를 구할 수 있다.


select 
	distinct customer_id
from payment;

/* 2. 거래액이 가장 많은 고객 순으로 출력 */ 

/* 1) order by sum(amount)*/
select 
	customer_id,
	sum(amount) as amount_sum
from payment
group by customer_id
order by sum(amount) desc;

/* 2) 숫자로 넘버링(두번째 컬럼에 대해 오더바이) */
select 
	customer_id,
	sum(amount) as amount_sum
from payment
group by customer_id
order by 2 desc;

/* 3) alias 이용 */
select 
	customer_id,
	sum(amount) as amount_sum
from payment
group by customer_id
order by amount_sum desc;


-- 이 고객이다.
select 
	* 
from customer 
where customer_id = '148';

/* 3. 직원들의 실적 
 * - 각 스텝이 몇건의 처리를 했는가? */
select 
	staff_id,
	count(payment_id) as count
from payment 
group by staff_id;

select 
	*
from staff
where staff_id = '2';

-- 직원테이블과 조인
select 
	a.staff_id a_staff_id,
	b.staff_id b_staff_id,
	count(a.payment_id) as count,
	b.first_name,
	b.last_name
from payment a, staff b
where a.staff_id = b.staff_id
group by a.staff_id, b.staff_id, b.first_name, b.last_name;

/* ### HAVING절: GROUP BY 절과 함께 HAVING 절을 사용하여
 * GROUP BY의 결과를 특정 조건으로 필터링하는 기능을 한다.
 * WHERE절과의 차이: 테이블이 가지고 있는 집합을 한정하는 역할이고,
 * HAVING절은 이 테이블을 가지고 그룹핑한 집계데이터 중에서 어떤 것만 뽑겠다라는것을 한정한다.
 * HANING절은 GROUP BY의 결과에서 한정하는 것이고, 
 * WHERE절은 GROUP BY전에 한정하는 것.
 * 시간차가 있네.
 */
/* 1. HAVING절 결제합계가 200인 고객만 조회 */
select 
	a.customer_id,
	sum(a.amount) amount_sum,
	b.email -- 고객의 이메일 주소
from payment a, customer b
where a.customer_id = b.customer_id
group by a.customer_id, b.email
having sum(a.amount) > 200
order by amount_sum desc; -- 그룹바이 결과에서 한정한다.
-- having 절은 group by를 한 결과 중에서 뽑을 정보만 뽑는다.

/* 2. 매장별 고객의 명수가 300명 이상인 매장만 뽑는다. */
select 
	store_id,
	count(customer_id) as count
from customer
group by store_id
having count(customer_id) > 300;

select 
	*
from store 
where store_id = '1';