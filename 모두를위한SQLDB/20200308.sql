/* ### DISTINCT
 * 중복값의 제외한 결과값
 * */
drop table t1;
create table t1(id serial not null primary key, bcolor varchar, fcolor varchar);

insert 
	into t1(bcolor, fcolor)
values
	('red','red')
	,('red','red')
	,('red', null)
	,(null,'red')
	,('red','green')
	,('red','blue')
	,('green','red')
	,('green','blue')
	,('green','green')
	,('blue','red')
	,('blue','green')
	,('blue','blue');
commit;

/* 1. 전체 컬럼을 조회 */
select 
	*
from t1;

/* 2. DISTINCT 하나의 컬럼 + order by는 명확히 보려고 사용 */
select 	
	distinct bcolor 
from t1 
order by bcolor;

/* 3. DISTINCT 두개의 컬럼 */
select 	
	distinct bcolor, fcolor 
from t1 
order by bcolor, fcolor ;

/* 4. DISTINCT ON
 * 기준 집합을 정하고, 뒤의 컬럼은 그냥 보고싶을때 */
select 	
	distinct on (bcolor) bcolor
	, fcolor 
from t1 
order by bcolor, fcolor ;

/* 5. DISTINCT ON
 * 기준 집합을 정하고, 뒤의 컬럼은 그냥 보고싶을때 
 * FCOLOR 보여줄때 내림차순으로 정렬하여 보여줌 */
select 	
	distinct on (bcolor) bcolor
	, fcolor 
from t1 
order by bcolor, fcolor desc ;


/* ### WHERE절 필터링
 * 데이터 조회와 필터링
 * 특정 테이블에서 어떠한 조건으로 집합을 가져오느냐
 * */

/* 1. WHERE 조건 하나*/
select 
	last_name,
	first_name
from 
	customer c 
where 
	first_name  ='Jamie';
	
/* 2. WHERE 조건 두개 */
select 
	last_name,
	first_name
from 
	customer c 
where first_name  ='Jamie'
  and last_name = 'Rice';
 
/* 3. WHERE 조건 부등호 */
select
	customer_id,
	amount,
	payment_date
from 
	payment
where amount <= 1 or amount >= 8;
