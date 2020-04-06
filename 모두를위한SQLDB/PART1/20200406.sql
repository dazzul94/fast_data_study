create table tb_item_coalesce_test(
	id serial primary key,
	product varchar(100) not null,
	price numeric not null,
	discount numeric
);

insert into tb_item_coalesce_test(product, price, discount)
values 
	('A', 1000, 10),
	('B', 1500, 20),
	('C', 800, 5),
	('D', 500, null);

select 
	product,
	(price - discount) as net_price
from tb_item_coalesce_test;
-- 500 - null은 null이다

/* 1. coalesce 테스트 */
select 
	product,
	(price - coalesce(discount,0)) as net_price 
from tb_item_coalesce_test;
/*
product|net_price|
-------|---------|
A      |      990|
B      |     1480|
C      |      795|
D      |      500|
*/

/* 2. case표현식*/
select 
	product,
	( price - 
		case when discount is null then 0
		else discount 
		end) as net_price 
from tb_item_coalesce_test; 

-------------------------------------------------------------
/* ### NULLIF함수
 * - 입력한 두개의 인자의 값이 동일하면 NULL을 리턴하고 
 * 그렇지 않으면 첫번째 인자값을 리턴한다.
 */
create table tb_member_nullif_test(
	id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	gender smallint not null
);

insert into tb_member_nullif_test(
	first_name,
	last_name,
	gender
)
values
	('John', 'Doe', 1),
	('David', 'Dave', 1),
	('Bush', 'Lily', 2)
	
/* 1. nullif test */
-- 0으로 나누면 안된다.
select 
	sum(case when gender = 1 then 1 else 0 end) /
	sum(case when gender = 2 then 1 else 0 end ) * 100 as "MALE/FEMAILE RATIO"
from tb_member_nullif_test;

update tb_member_nullif_test
	set gender = 1
where gender = 2;
/*SQL Error [22012]: 오류: 0으로는 나눌수 없습니다.*/

select 
	(sum(case when gender = 1 then 1 else 0 end) /
	nullif(sum(case when gender = 2 then 1 else 0 end ),0) -- 0과 같으면 null을 리턴한다. SQL에러 없앰
	) * 100 as "MALE/FEMAILE RATIO"
from tb_member_nullif_test;

------------------------------------------------------------------
/* ### CAST표현식
 * - 특정 데이터 타입으로 형변환이 가능하도록 한다.
 * 각종 데이터 값을 CAST표현식을 이용해 적절하게 형변환한다.
 * */
select 
	cast('100' as integer);

select 
	'100'::integer;

select 
	cast('10C' as integer);

select '10C'::integer;
/*SQL Error [22P02]: 오류: integer 자료형 대한 잘못된 입력: "10C"
  Position: 16*/

select 
	cast('2015-01-01' as date);

select 
	'2015-01-01'::date;

select 
	cast('10.2' as double precision);

select 
	'10.2'::double precision;
--------------------------------------------------------------------
/* ### WITH문의 활용 
 * - select문의 결과를 임시 집합으로 저장해두고, SQL문에서 마치 테이블처럼 해당 집합을 불러올 수 있따.
 * */
select 
	film_id,
	title,
	(case when length < 30 then 'SHORT'
		 when length >= 30 and length < 90 then 'MEDIUM'
		 when length > 90 then 'LONG'
	end) length
from film;

with temp1 as (
select 
	film_id,
	title,
	(case when length < 30 then 'SHORT'
		 when length >= 30 and length < 90 then 'MEDIUM'
		 when length > 90 then 'LONG'
	end) length
from film
)
select * from temp1;

/* 1. with문 사용 */
with temp1 as (
select 
	film_id,
	title,
	(case when length < 30 then 'SHORT'
		 when length >= 30 and length < 90 then 'MEDIUM'
		 when length > 90 then 'LONG'
	end) length
from film
)
select 
	* 
from temp1
where length = 'MEDIUM';





