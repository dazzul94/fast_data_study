/* ### 기본키 
 * - 테이블 내에서 유일한 값이어야 하고, NOT NULL이어야 한다.(UNIQUE + NOT NULL)
 * 즉 테이블 내에서 반드시 존재해야 하는 실체 무결성에 대한 제약이다.
 */

/* 1. 기본키 추가 */
create table tb_product_pk_test(
	product_no integer,
	description text,
	product_cost numeric
);
alter table tb_product_pk_test 
add primary key(product_no);

create table tb_product_pk_test_2(
	name varchar(255)
);
insert into tb_product_pk_test_2(name)
values 
	('MICROSOFT'),
	('IBM'),
	('APPLE'),
	('SAMSUNG');
select * from tb_product_pk_test_2;

alter table tb_product_pk_test_2 add column id serial primary key;

select * from tb_product_pk_test_2;

insert into tb_product_pk_test_2(name)
values 
	('LG');
	
/* 2. 기본키 제거 */
alter table tb_product_pk_test
drop constraint tb_product_pk_test_pkey;

select * from tb_product_pk_test;

alter table tb_product_pk_test_2
drop constraint tb_product_pk_test_2_pkey;

select * from tb_product_pk_test_2;

/* ### 외래키
 * - 자식 테이블의 특정 컬럼이 부모 테이블의 특정 컬럼의 값을 참조하는 것이다.
 * 이것을 참조 무결성이라고 한다.
 */
drop table so_headers;
drop table so_items;

create table so_headers(
	id serial primary key,
	customer_id integer,
	ship_to varchar(255)
);
create table so_items(
	item_cd integer not null,
	so_id integer,
	product_id integer,
	qty integer,
	net_price integer,
	primary key(item_cd, so_id)
);

/* 1. 외래키 실습 */
alter table so_items 
add constraint fk_so_headers_id
foreign key(so_id) references so_headers(id);

insert into so_headers(customer_id, ship_to)
values 
	(10, '4000 North Fisrt Street, CA 95134, USA'),
	(20, '1900 North Fisrt Street, CA 95134, USA'),
	(10, '4000 North Fisrt Street, CA 95134, USA');
commit;

select * from so_headers;

insert into so_items(item_cd, so_id, product_id, qty, net_price)
values 
	(1, 1, 1001, 2, 1000),
	(2, 1, 1000, 3, 1500),
	(3, 2, 1000, 4, 1500),
	(1, 2, 1001, 5, 1000),
	(2, 3, 1002, 2, 1700),
	(3, 3, 1003, 1, 2000);
	
select * from so_items;

/* 2. 참조무결성 제약조건 어긋남 */
insert into so_items(item_cd, so_id, product_id, qty, net_price)
values 
	(1, 4, 1001, 2, 1000);
/*SQL Error [23503]: 오류: "so_items" 테이블에서 자료 추가, 갱신 작업이 "fk_so_headers_id" 참조키(foreign key) 제약 조건을 위배했습니다
  Detail: (so_id)=(4) 키가 "so_headers" 테이블에 없습니다.*/
	
/* 3. 외래키 삭제 */
alter table so_items 
drop constraint fk_so_headers_id;

/* 4. 테이블 생성과 동시에 외래키 생성 */
create table so_items(
	item_id integer not null,
	so_id integer references so_headers(id),
	product_id integer,
	qty integer,
	net_price numeric,
	primary key(item_id, so_id)
);

/* 5. 복합 외래키도 생성 가능 */
create table child_table(
	c1 integer primary key,
	c2 integer,
	c3 integer,
	foreign key(c2, c3) references parent_table(p1, p2) -- C2+C3가 P1+P2에 존재해야 한다.
);

/* ### 체크 제약 조건
 * - 특정 컬럼에 들어가는 값에 대한 제약을 가하는 것
 * 즉 업무적으로 절대로 들어갈 수 없는 값을 물리단에서부터 막는 것
 */
create table tb_emp_check_test(
	id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	birth_date date check(birth_date > '1900-01-01'), -- 생일은 반드시 1900년 1월 1일 이후
	joined_date date check(joined_date > birth_date), -- 입사일자는 생일보다 반드시 커야한다.
	salary numeric check(salary > 0) -- 연봉은 0보다 반드시 커야한다.
);
insert into tb_emp_check_test(
	first_name,
	last_name,
	birth_date,
	joined_date,
	salary
)
values 
(
	'JOHN',
	'DOE',
	'1972-01-01',
	'2015-07-01',
	-100000
); -- 연봉이 마이너스일리 없다.
/*SQL Error [23514]: 오류: 새 자료가 "tb_emp_check_test" 릴레이션의 "tb_emp_check_test_salary_check" 체크 제약 조건을 위반했습니다
  Detail: 실패한 자료: (1, JOHN, DOE, 1972-01-01, 2015-07-01, -100000)*/

/* 1. 체크 제약 조건 변경 */
alter table tb_emp_check_test
add constraint salary_range_check
check (salary > 0 and salary <= 1000000000000);

alter table tb_emp_check_test
add constraint name_check
check (length(first_name) > 0 and length(last_name) > 0);