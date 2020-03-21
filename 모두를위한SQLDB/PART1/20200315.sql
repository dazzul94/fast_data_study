/* ### CROSS JOIN 
 * - 두개의 테이블의 CATESIAN PRODUCT 연산의 결과를 출력한다. 
 * 데이터 복제에 많이 쓰이는 기법이다. 
 */
create table cross_t1
(
	label char(1) primary key
);

create table cross_t2
(
	score int primary key
);

insert into cross_t1(label)
values 
	('A'),
	('B');
	
commit;

select * from cross_t1;

insert into cross_t2(score)
values 
	(1),
	(2),
	(3);
	
select * from cross_t2;

/* 1. CROSS 조인 실습
 * 나올수 있는 모든 경우의 수 출력 (2 * 3) = 6*/
select 
	*
from cross_t1
cross join cross_t2
order by label;

select * 
from cross_t1, cross_t2
order by label; --inner 조인을 표현하는 다른 방법(조건이 없는 경우이기 때문에 cross join됨

-- 위 2개의 sql문 결과는 동일=같은 SQL이다.
/* 2. CROSS 조인 예*/
select 
	label,
	case when label = 'A' then sum(score)
	     when label = 'B' then sum(score) * (-1)
	else 0
	end as calc
from cross_t1
cross join cross_t2
group by label; 

--------------------------------------------------------------
/* ### NATURAL JOIN 
 * - 두개의 테이블에서 같은 이름을 가진 컬럼 간의 iNNER 조인 집합 결과를 출력한다. SQL문 자체가 간소해지는 방법이다.
 * - 실무에서는 안쓰이지만 INNER JOIN을 더 깊게 이해해볼 수 있다. */
create table categories
(
	category_id serial primary key,
	category_name varchar(255) not null
);

create table products
(
	product_id serial primary key,
	product_name varchar(255) not null,
	category_id int not null,
	foreign key(category_id)
	references categories(category_id) -- 포린키인 category_id는 categories 테이블의 category_id를 참고한다. 
	-- 하나의 카테고리는 n개의 product를 가진다. 그리고 하나의 카테고리는 꼭 선택해야한다.
	-- 참조 무결성 조건이다.
);


insert into categories(category_name)
values 
	('Smart Phone'),
	('Laptop'),
	('Tablet');
commit;
insert into products(product_name, category_id)
values 
	('iPhone', 1),
	('Samsung Galaxy', 1),
	('HP Elite', 2),
	('Lenovo Thinkpad', 2),
	('iPad', 3),
	('Kindel Fire', 3);

select * from categories;
select * from products;

/* 1. NATURAL JOIN 실습
 * - PRODUCTS 테이블과 CATEGORIES 테이블간 NATURAL 조인.
 * 이런 경우 동일하게 가지고 있는 CATEGORIES_ID 컬럼을 기준으로 INNER JOIN한다. 
 * 자동: 안정성 낮다. */

/* 1) NATURAL JOIN */
select 
	*
from products a 
natural join categories b;

/* 2) INNNER JOIN */
select 
	a.category_id, a.product_id,
	a.product_name, b.category_name
from products a 
inner join categories b
   on (a.category_id = b.category_id);
-- 동일한 SQL
-- 가급적 INNER JOIN을 써라

/* 3) 콤마로 이어진 INNER JOIN WHERE  */
select 
	a.category_id, a.product_id,
	a.product_name, b.category_name
from products a, categories b
where a.category_id = b.category_id;


/* 2. NATURAL JOIN 실습2*/
select * from city;
select * from country;

/* 1) NATURAL JOIN */
select 
	*
from city a 
natural join country b;
-- 왜 안나올까? country_id가 있는데 
-- 아.. last_update 컬럼이 둘다 존재하기 때문에 둘다 조인 조건에 걸려서 natural join이 된다.
-- 자동으로 해주니까 자신의 의도와는 전혀 다른 -> 데이터 0건이 나온다.
-- 예상치 못하게 데이터가 나오지 않을 수가 있다.

/* 2) INNNER JOIN */
select 
	*
from city a
inner join country b
   on a.country_id  = b.country_id;

/* 3) 콤마로 이어진 INNER JOIN WHERE  */
select 
	*
from city a, country b
where a.country_id  = b.country_id;

	
