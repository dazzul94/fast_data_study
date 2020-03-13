/* ### SELF JOIN
 * - 같은 테이블끼리 특정 컬럼을 기준으로 매칭 되는 컬럼을 출력하는 조인이다.
 * - 즉 같은 테이블의 데이터를 각각의 집합으로 분류한 후 조인한다.  
 */

/* 1. 셀프 조인 
 * */
drop table employee;
create table employee
(
	employee_id int primary key,
	first_name varchar(255) not null,
	last_name varchar(255) not null,
	manager_id int,
	foreign key(manager_id)
	references employee(employee_id)
	on delete cascade
);
-- employee_id는 manager_id를 참조한다?

insert into employee(
	employee_id,
	first_name,
	last_name,
	manager_id
)
values 
	(1, 'Windy', 'Hays', null),
	(2, 'Ava', 'Christensen', 1),
	(3, 'Hassan', 'Conner', 1),
	(4, 'Anna', 'Reeves', 2),
	(5, 'Sau', 'Norman', 2),
	(6, 'Kelsie', 'Hays', 3),
	(7, 'Tory', 'Goff', 3),
	(8, 'Salley', 'Lester', 3);

select 
	*
from employee;
-- Windy는 CEO, 
-- Ava, Hassan은 Windy아래에,
-- Anna, Sau는 Ava밑에
-- Kelsie, Tory, Salley는 Hassan밑에 
-- 트리 구조로 나타낼 수 있다.(조직도)

select 
	e.first_name || ' ' || e.last_name employee,
	m.first_name || ' ' || m.last_name manager
from employee e
inner join employee m
  on m.employee_id = e.manager_id
order by manager;
-- 최상위 관리자는 안나왔다.

/** 2. 전직원은 다 보고싶다.*/
select 	
	e.first_name || ' ' || e.last_name employee,
	m.first_name || ' ' || m.last_name manager
from employee e 
left join employee m
  on m.employee_id = e.manager_id
order by manager;

/* SELF JOIN 실습 - 부정형 조건 
 * - 상영시간은 동일하면서 다른 영화 조회 */
select
	f1.title,
	f2.title,
	f1.length
from film f1 
inner join film f2 
  on f1.film_id <> f2.film_id 
 and f1.length = f2.length;
 
select
	*
from film f1 
where f1.film_id <> f1.film_id 
 and f1.length = f1.length; -- 결과집합이 공집합이다.
 -- 동일한 테이블이지만 각가의 다른 집합으로 구성해놓고.. 
 -- 이게 셀프조인, 그다음 그 안에서 자신이 원하는 정보를 추출한다.
 
 
 --------------------------------------------------------------------
 /* ### FULL OUTER JOIN 
  * - INEER, LEFT OUTER, RIGHT OUTER 조인 집합을 모두 출력하는 조인 방식이다. 
  * - 즉 두 테이블간 출력가능한 모든 데이터를 포함한 집합을 출력한다.
  * - 합집합 */
 
 /* 1. FULL OUTER JOIN */
 select 	
 	a.id id_a,
 	a.fruit fruit_a,
 	b.id id_b,
 	b.fruit fruit_b
 from basket_a a
 full outer join basket_b b
   on a.fruit = b.fruit; -- 엑셀에서의 lookup 기능
 
/* 2. ONLY OUTER (OUTER에서 교집합을 제외) */
select 	
 	a.id id_a,
 	a.fruit fruit_a,
 	b.id id_b,
 	b.fruit fruit_b
 from basket_a a
 full outer join basket_b b
   on a.fruit = b.fruit
 where a.id is null -- right outer 
   or b.id is null; -- left outer

/* 3. 추가 실습 준비 */
create table 
if not exists departments -- 존재하지 않으면 생성
(
	department_id serial primary key,
	department_name varchar(255) not null
);
drop table employees;
create table 
if not exists employees 
(
	employee_id serial primary key,
	employee_name varchar(255),
	department_id integer
);

insert into departments(department_name)
values
	('Sales'),
	('Marketing'),
	('HR'),
	('IT'),
	('Production');

insert into employees(employee_name, department_id)
values 
	('Bette Nicholson', 1),
	('Christian Gable', 1),
	('Joe Swank', 2),
	('Fred Costner', 3),
	('Sandra Kilmer', 4),
	('Julia Mcqueen', null);

select * from departments;
select * from employees;

/* 4. FULL OUTER 조인 실습 */
select 
	e.employee_name,
	d.department_name
from employees e 
full outer join departments d
  on d.department_id = e.department_id;
 
/* 5. FULL OUTER 조인 실습 - RIGHT ONLY */
 -- 소속한 직원이 없는 부서만 출력
select 
	e.employee_name,
	d.department_name
from employees e 
full outer join departments d
  on d.department_id = e.department_id
where e.employee_name is null;

select 
	e.employee_name,
	d.department_name
from employees e 
right join departments d
  on d.department_id = e.department_id
where e.employee_name is null;

-- 위 두개는 같은 sql
-- FULL OUTER의 RIGHT ONLY와 
-- RIGTH OUTER JOIN의 RIGHT ONLY와 동일하다. 밴다이어 그램 그려보면 안다.

/* 6. FULL OUTER 조인 실습 - LEFT ONLY */
-- 소속한 부서가 없는 직원이 출력
select 
	e.employee_name,
	d.department_name
from employees e 
full outer join departments d
  on d.department_id = e.department_id
where d.department_name is null;

select 
	e.employee_name,
	d.department_name
from employees e 
left join departments d
  on d.department_id = e.department_id
where d.department_name is null;