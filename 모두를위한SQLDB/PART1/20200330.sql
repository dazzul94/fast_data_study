/* ### 컬럼 데이터 타입 변경 
 * - 기존에 존재하는 테이블의 컬럼의 데이터 타입을 변경할 수 있다
 */
create table assets(
	id serial primary key,
	name text not null,
	asset_no varchar(10) not null,
	description text,
	location text,
	acquired_date date not null
);

insert into assets
	(name, asset_no, location, acquired_date)
values 
	('Server', '10001', 'Server room', '2017-01-01'),
	('UPS', '10002', 'Server room', '2017-01-02');
	
select * from assets;

/* 1. name 컬럼의 데이터 타입 변경*/
alter table assets alter column name type varchar(50);

/* 2. 한번에 n개 컬럼의 데이터 타입을 변경 */
alter table assets 
	alter column location type varchar(100),
	alter column description type varchar(500);

/* 3. asset_no 컬럼의 데이터 타입을 변경 */
alter table assets 
	alter column asset_no type int;
--"asset_no" 칼럼의 자료형을 integer 형으로 형변환할 수 없음

alter table assets 
	alter column asset_no type int using asset_no::integer;

-------------------------------------------------------------------------
/* ### 컬럼이름 변경
 * - 기존의 테이블의 컬럼의 이름을 바꿀 수 있다.*/

-- postgresql은 ddl도 commit 해야한다.
/* 1. 실습 준비 */
drop table customer_groups;
drop table customers;
drop table customer_data;

create table customer_groups(
	id serial primary key,
	name varchar not null
);

create table customers(
	id serial primary key,
	name varchar not null,
	phone varchar not null,
	email varchar,
	group_id int,
	foreign key (group_id) references customer_groups(id)
);

create view customer_data
as select
	c.id,
	c.name,
	g.name customer_group
from 
	customers c,
	customer_groups g
where g.id = c.group_id;

select * from customer_data;

/* 2. email 컬럼 이름 변경 */
alter table customers
rename column email to contact_email;

/* 3. name 컬럼 이름 변경 -> 뷰 자동적용 */
alter table customers
rename column name to group_name;

----------------------------------------------------------
/* ### 테이블 제거 
 * - 테이블 제거시는 항상 주의해야 하고 FK관계도 유의해야 한다. */

drop table page;

create table author(
	author_id int not null primary key,
	firstname varchar(50),
	lastname varchar(50)
);

create table page(
	page_id serial primary key,
	title varchar(255) not null,
	content text,
	author_id int not null,
	foreign key(author_id) references author(author_id) -- 참조무결성 조건
);

-- 한 명의 작가는 여러개의 글을 쓴다.
-- 부모
insert into author
values (1, 'dasol', 'kim');
-- 자식
insert into page
values (1, 'SQL과 데이터베이스', 'drop table', 1);
commit;

select * from author;
select * from page;

/* 1. 부모 테이블 제거 실습 */
drop table author; -- 부모를 날릴려고 하면 안날라간다. 

/*SQL Error [2BP01]: 오류: 기타 다른 개체들이 이 개체에 의존하고 있어, author 테이블 삭제할 수 없음
  Detail: page_author_id_fkey 제약 조건(해당 개체: page 테이블) 의존대상: author 테이블
  Hint: 이 개체와 관계된 모든 개체들을 함께 삭제하려면 DROP ... CASCADE 명령을 사용하십시오*/

drop table author cascade;

select * from author;
select * from page; -- 자식 테이블은 안날라가는데 참조무결성 제약조건은 날아간다.

/* 2. 자식 테이블 삭제 실습*/
drop table page; -- 자식은 잘 날린다.

-- 부모가 없는 자식은 존재할 수 없다. 