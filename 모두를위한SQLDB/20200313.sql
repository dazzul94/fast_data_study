/* 1. 간단한 INNER JOIN - 교집합*/
select 	
	a.id id_a,
	a.fruit fruit_a,
	b.id id_b,
	b.fruit fruit_b
from basket_a a
inner join basket_b b
   on a.fruit = b.fruit;

/* 2. 한 명의 고객은 여러건의 결제건을 가질 수 있다.
 * - 하나의 결제는 반드시 고객을 가져야 한다.(1:n 관계)*/
select 	
	a.customer_id,
	a.first_name,
	a.last_name,
	a.email,
	b.amount,
	b.payment_date
from customer a
inner join payment b
   on a.customer_id = b.customer_id;

select 	
	count(*)
from payment p; -- 1:n 관계일 때 조인의 건수는 n쪽의 건수가 나온다.
  
/* 3. CUSTOMER 테이블과 PAYMENT 테이블을 CUSTOMER_ID 기준으로 조인한다.
 * CUSTOMER_ID가 2인 집합만을 출력한다.*/
select 	
	a.customer_id,
	a.first_name,
	a.last_name,
	a.email,
	b.amount,
	b.payment_date
from customer a
inner join payment b
   on a.customer_id = b.customer_id
where a.customer_id = 2;

/* 4. 한 명의 고객은 여러건의 결제건을 가질 수 있다.
 * - 하나의 결제는 반드시 고객을 가져야 한다.(1:n 관계) 
 * + 한 명의 직원은 여러건의 결제내역을 처리한다.*/

-- 고객1:결제m:직원1
select 	
	a.customer_id,
	a.first_name a_first_name,
	a.last_name a_last_name,
	a.email,
	b.amount,
	b.payment_date,
	c.first_name c_first_name,
	c.last_name c_last_name
from customer a
inner join payment b
   on a.customer_id = b.customer_id
inner join staff c
   on b.staff_id = c.staff_id;
   
-- 기준 집합은 PAYMENT다. CUSTOMER과 STAFF를 조인하는것.

  
  -------------------------------------------------------------------
/* ### OUTER JOIN 
 * - 특정 컬럼을 기준으로 매칭된 집합을 출력하지만
 * 한쪽의 집합은 모두 출력하고 다른 한쪽의 집합은 매칭되는 컬럼의 값만을 출력한다.*/
  
-- 한쪽은 다 보여주고 다른쪽은 있는거만 가져오겠다.
  
-- left join = left outer join(생략가능)

/* 1. LEFT JOIN */
select 
	a.id a_id,
  	a.fruit a_fruit,
  	b.id b_id,
  	b.fruit b_fruit
from basket_a a
left join basket_b b
  on a.fruit = b.fruit; 
  
/* 2. LEFT ONLY(LEFT JOIN WHERE ID IS NULL)
 * A에만 있는 데이터 걸러내기
 * id는 널일 수가 없지만, left기준으로 뽑았을 때 
 * right는 b_id가 널일 것이다. */
select 
	a.id a_id,
  	a.fruit a_fruit,
  	b.id b_id,
  	b.fruit b_fruit
from basket_a a
left join basket_b b
  on a.fruit = b.fruit
where b.id is null;

/* 3. RIGHT OUTER(BASKET_B 테이블에 있는 기준으로 뽑는다. 매칭되는 것만 나온다. */
select 
	a.id a_id,
  	a.fruit a_fruit,
  	b.id b_id,
  	b.fruit b_fruit
from basket_a a
right join basket_b b
  on a.fruit = b.fruit;
 
/* 4. RIGTH ONLY */
select 
	a.id a_id,
  	a.fruit a_fruit,
  	b.id b_id,
  	b.fruit b_fruit
from basket_a a
right join basket_b b
  on a.fruit = b.fruit
where a.id is null;

/* OUTER JOIN이 많이 쓰이는 이유: 
 * 기준집합이 있을 때 보고자하는 집합을 셀렉트할때 
 * ex) 고객은 다 보고 싶어요 , 계약했든 안했든 우리는 고객을 보고싶어요.
 * 근데 계약을 보여주면 더 좋지요~
 */
select 
	a.customer_id,
	a.first_name,
	a.last_name,
	a.email,
	b.amount,
	b.payment_date
from customer a
left join payment b
  on a.customer_id = b.customer_id;
-- where b.payment_id is null
