/* ### ROW_NUMBER, RANK, DENSE_RANK
 * - 특정 집합 내에서 결과 건수의 변화 없이 해당 집합 안에서 특정 컬럼의 순위를 구하는 함수
 * ## ROW_NUMBER
 * - 같은 순위가 있어도 무조건 순차적으로 순위를 매긴다.(1,2,3,4,5...순으로 나간다.)
 */

/* 1. ROW_NUMBER 그룹별 가격순위 높은순 */
select 
	a.product_name,
	b.group_id,
	a.price,
	row_number () over (partition by b.group_name order by a.price desc)
from product a
inner join product_group b
   on a.group_id = b.group_id;
   
/* 2. RANK 그룹별 가격순위 높은순 
 * - 공동 순위가 있다. 다음 순위는 하나 밀린다. */
select 
	a.product_name,
	b.group_id,
	a.price,
	rank () over (partition by b.group_name order by a.price desc)
from product a
inner join product_group b
   on a.group_id = b.group_id;
   
/* 3. DENSE RANK 그룹별 가격순위 높은 순 
 * - 공동 순위가 있고 다음순위는 그다음 순위로 간다.*/
select 
	a.product_name,
	b.group_id,
	a.price,
	dense_rank () over (partition by b.group_name order by a.price)
from product a
inner join product_group b
   on a.group_id = b.group_id;
   
-------------------------------------------------------------------------
/* ### FIRST_VALUE, LAST_VALUE
 * - 특정 집합 내에서 결과 건수의 변화 없이 해당 집합 안에서 특정 컬럼의 첫번째 값 혹은 마지막 값을 구하는 함수이다.
 */
/* 1. FIRST_VALUE */
select
	a.product_name, b.group_name, a.price,
	first_value(a.price) over (partition by b.group_name order by a.price) as lowest_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
select
	a.product_name, b.group_name, a.price,
	first_value(a.price) over (partition by b.group_name order by a.price desc) as heighst_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
/* 2. LAST_VALUE */
select
	a.product_name, b.group_name, a.price,
	last_value(a.price) over 
	(partition by b.group_name order by a.price desc
	range between unbounded preceding --범위를 지정해줘야 한다.
	and unbounded following)
	as lowest_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
select
	a.product_name, b.group_name, a.price,
	last_value(a.price) over 
	(partition by b.group_name order by a.price
	range between unbounded preceding --범위를 지정해줘야 한다.
	and unbounded following)
	as highest_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
/* 3. LAST_VALUE를 쓸 때는 범위를 지정해줘야 한다.
 * 디폴트 설정은 
 * range between unbounded preceding
 * and current row */
select
	a.product_name, b.group_name, a.price,
	last_value(a.price) over (partition by b.group_name order by a.price) as heighst_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id
   
select
	a.product_name, b.group_name, a.price,
	last_value(a.price) over 
	(partition by b.group_name order by a.price
	range between unbounded preceding --범위를 지정해줘야 한다.
	and current row) as highest_price_per_group
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
-------------------------------------------------------------------------
/* ### LAG, LEAD 함수
 * - 특정 집합 내에서 결과 건수의 변화 없이 해당 집합 안에서 특정 컬럼의 이전행의 값 혹은 다음 행의 값을 구한다.
 */
  
/* 1. LAG함수 실습 - 이전 행의 값을 찾는다. (그룹별)*/
select
	a.product_name, b.group_name, a.price,
	lag(a.price, 1) over (partition by b.group_name order by a.price) as prev_price,
	a.price - lag(a.price, 1) over (partition by b.group_name order by a.price) as cur_prev_diff
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
/* 2. LAG함수 실습 - 2번째 이전 행의 값을 찾는다. (그룹별)*/
select
	a.product_name, b.group_name, a.price,
	lag(a.price, 2) over (partition by b.group_name order by a.price) as prev_price,
	a.price - lag(a.price, 2) over (partition by b.group_name order by a.price) as cur_prev_diff
from product a 
inner join product_group b
   on a.group_id = b.group_id;
  
/* 3. LAG함수 실습 - 다음 행의 값을 찾는다. (그룹별)*/
select
	a.product_name, b.group_name, a.price,
	lead(a.price, 1) over (partition by b.group_name order by a.price) as next_price,
	a.price - lead(a.price, 1) over (partition by b.group_name order by a.price) as cur_next_diff
from product a 
inner join product_group b
   on a.group_id = b.group_id;

  
