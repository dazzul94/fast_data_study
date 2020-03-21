/* ### UNION 연산
 *두 개 이상의 select 문들의 결과 집합을 단일 결과 집합으로 결합하며
 * 결합시 중복된 데이터는 제거 된다.
 * 집합 간의 관계를 맺어준다.
 */
-- 두개의 select문 간 컬럼의 개수는 동일해야 하고 해당 순서의 열에는 서로 호환되는 데이터 유형이어야 한다.
-- 두개의 select문에서 중복되는 데이터는 제거된다.
create table sales2007_1
(
	name varchar(50),
	amount numeric(15, 2)
);
insert into sales2007_1
values
	('Mike', 150000.25),
	('Jon', 132000.75),
	('Mary', 100000);
commit;

create table sales2007_2
(
	name varchar(50),
	amount numeric(15, 2)
);

insert into sales2007_2
values
	('Mike', 120000.25),
	('Jon', 142000.75),
	('Mary', 100000);
commit;
select 
	*
from sales2007_1;

select 
	*
from sales2007_2;

/* 1. union 
 * - 중복값이 날아간다. */
select 
	*
from sales2007_1
union 
select 
	*
from sales2007_2;

select 
	name
from sales2007_1
union 
select 
	name
from sales2007_2;

select 
	amount
from sales2007_1
union 
select 
	amount
from sales2007_2;

/* 2. union 연산 실습 order by */
select 
	*
from sales2007_1
union 
select 
	*
from sales2007_2
order by amount desc; -- 맨 아래에다가 오더바이 한다는 규칙

-------------------------------------------------------------------
/* ### UNION ALL 연산
 * - 두 개 이상의 select 문들의 결과 집합을 단일 결과 집합으로 결합하며 결시 
 *  중복된 데이터도 모두 출력한다.
 * */

/* 1. union all
 * - 중복된 데이터도 모두 출력한다. 
 * - union 보다 union all이 더 많이 사용한다. */
select 
	*
from sales2007_1
union all
select 
	*
from sales2007_2;

select 
	name
from sales2007_1
union all
select 
	name
from sales2007_2;

select 
	amount
from sales2007_1
union all
select 
	amount
from sales2007_2;

/* 2. union all 연산 실습 order by */
select 
	*
from sales2007_1
union all
select 
	*
from sales2007_2
order by amount desc; -- 맨 아래에다가 오더바이 한다는 규칙

-----------------------------------------------------------------
/* INTERCEPT 연산 
 * - 두 개 이상의 select문들의 결과 집합을 하나의 결과 집합으로 결합한다.
 * - A와 B에 동시에 존재하는 데이터(교집합)
 * - INNER JOIN과 같다.
 */
create table employees2
(
	employee_id serial primary key,
	employee_name varchar(255) not null
);
create table keys(
	employee_id int primary key,
	effective_date date not null,
	foreign key (employee_id)
	references employees2 (employee_id)
);
create table hipos
(
	employee_id int primary key,
	effective_date date not null,
	foreign key (employee_id)
	references employees2(employee_id)
);
insert into employees2(employee_name)
values
	('Joyce Edwards'),
	('Diane Collins'),
	('Alice Stewart'),
	('Julie Sanchez'),
	('Heather Morris'),
	('Teresa Rogers'),
	('Doris Reed'),
	('Gloria Cook'),
	('Evelyn Morgan'),
	('Jean Bell');
commit;

insert into keys 
values 
	(1, '2000-02-01'),
	(2, '2001-06-01'),
	(5, '2002-01-01'),
	(7, '2005-06-01');
commit;

insert into hipos 
values 
	(9, '2000-01-01'),
	(2, '2002-06-01'),
	(5, '2006-06-01'),
	(10, '2005-06-01');
commit;

select * from employees2;
select * from keys;
select * from hipos;

/* 1. INTERSECT 실습 
 * - INNER JOIN과 동일하다. */
select 
	employee_id
from keys
intersect
select 
	employee_id
from hipos;

select 	
	a.employee_id
from keys a, hipos b
where a.employee_id = b.employee_id;

/* 2.INTERSECT ORDER BY */
select 
	employee_id
from keys
intersect
select 
	employee_id
from hipos
order by employee_id desc;

select 	
	a.employee_id
from keys a, hipos b
where a.employee_id = b.employee_id
order by a.employee_id desc;

select 	
	a.employee_id
from keys a
inner join hipos b
on a.employee_id = b.employee_id
order by a.employee_id desc;

-- 결과 집합이 동일하므로 모두 같은 SQL이다.
