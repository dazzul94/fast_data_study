/* ### CUBE절 
 * - 지정된 GROUPING 컬럼의 다차원 소계를 생성하는데 사용된다.
 * CUBE(C1, C2, C3) = GROUPING SETS( (C1, C2, C3), (C1, C2), (C1, C3), (C2, C3), (C1), (C2), (C3), () )
 */
select 
	brand, segment,
	sum(quantity)
from sales
group by cube(brand, segment)
order by brand, segment;

/* 1. ROLLUP이랑 비교(Rollup과 마찬가지로 전체합계는 나온다.)
 * - segment별 합계는 안나온다(첫번째 컬럼만 그룹바이해서 나온다.)*/
select 
	brand, segment,
	sum(quantity)
from sales
group by rollup(brand, segment)
order by brand, segment;

/*2. 부분 CUBE */
select 
	brand, segment,
	sum(quantity)
from sales
group by brand, 
cube(segment)
order by brand, segment;
-- 부분 cube = group by별 합계 + 맨 앞에 쓴 컬럼별 합계
-- 뒤에 쓴 컬럼이랑 전체합계는 구하지 않는다.

-----------------------------------------------------------------------------------------------------

/* ### COUNT 함수
 * 분석 함수란?
 * - 특정 집합 내에서 결과 건수의 변화 없이 해당 집합 안에서
 *   합계 및 카운트 등을 계산할 수 있는 함수이다. 
 */
create table product_group (
	group_id serial primary key,
	group_name varchar(255) not null
);

drop table product;
create table product (
	product_id serial primary key,
	product_name varchar(255) not null,
	group_id int not null,
	price decimal(11, 2),
	foreign key(group_id)
	references product_group(group_id)
);

insert into product_group(group_name)
values 
	('Smartphone'),
	('Laptop'),
	('Tablet');
commit;

insert into product(product_name, group_id, price)
values 
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('iPhone', 1, 900),
	('HP Elite', 2, 1200),
	('LG Gram', 2, 1500),
	('Lenovo Thinkpad', 2, 700),
	('Sony VAIO', 2, 700),
	('Dell Vostro', 2, 800),
	('iPad', 3, 700),
	('Kindel Fire', 3, 150),
	('Samsung Galaxy Tab', 3, 200);
commit;

select * from product_group;
select * from product;

/* 1. COUNT 
 * - 집계함수의 한계: 집계의 결과만을 출력한다. */
select 
	count(*)
from product;

select 
	count(*) over(), a.* -- 건수도 보여주고 내용도 보여주려면 count(*) over을 쓰면 된다.
from product a;
-- SQL 두번 안써도 된다. 호출 두번안해도 된다.
-- 집계의 결과와 테이블의 내용도 함께 보여준다. 이게 바로 집계함수의 역할이다.

-----------------------------------------------------------------------------------------------------

/* ### AVG 함수
 * - 사용하고자 하는 분석함수를 쓰고 
 *   대상 컬럼을 기재 후 PARTITION BY에서 값을 구하는 기준 컬럼을 쓰고 
 *   ORDER BY에서 정렬 컬럼을 기재한다.
 * 
 * select 
 * 	c1, 
 *  분석함수(c2, c3...) over(partition by c4 order by c5)
 * from table_name
 */

/* 1. AVG 실습 - 집계함수 */
-- 집계함수는 집계의 결과만을 출력한다.
select 
	avg(price)
from product;

select * from product_group;

/* 2. AVG 실습 - 집계함수*/
-- 집계함수는 집계의 결과만을 출력한다.
select 
	b.group_name,
	avg(price)
from product a
inner join product_group b
   on a.group_id = b.group_id
group by b.group_name;

/* 3. AVG 실습 - 분석함수*/
-- 집계함수는 집계의 결과만을 출력한다는 한계를 극복
-- 보여줄 거 다 보여주면서 그룹별 평균을 보여준다.
select 
	a.product_name,
	a.price,
	b.group_name,
	avg(price) over (partition by b.group_name) groupby_groupname
from product a
inner join product_group b
   on a.group_id = b.group_id;
  
/* 4. AVG 실습 - 분석함수 + ORDER BY group_name*/
-- 집계함수는 집계의 결과만을 출력한다는 한계를 극복
-- 보여줄 거 다 보여주면서 그룹별 평균을 보여준다.
select 
	a.product_name,
	a.price,
	b.group_name,
	avg(price) over (partition by b.group_name order by b.group_name) groupby_groupname
from product a
inner join product_group b
   on a.group_id = b.group_id;
  
/* 5. AVG 실습 - 분석함수 + ORDER BY price(누적집계) */
-- order by price로 하면 누적 평균을 구한다.
-- ex) Sony VAIO - 700 / Lenovo Thinkpad - 700 / Dell Vostro - 733.3333 / HP Elite - 850 / LG Gam - 980 ..... 누적으로
-- 결론: 각 그룹의 마지막 row의 평균은 전체 그룹의 평균이 나온다.
select 
	a.product_name,
	a.price,
	b.group_name,
	avg(price) over (partition by b.group_name order by a.price) groupby_groupname
from product a
inner join product_group b
   on a.group_id = b.group_id;
