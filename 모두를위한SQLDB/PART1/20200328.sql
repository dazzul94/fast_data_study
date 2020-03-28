/* ### CTAS: CREATE TABLE AS SELECT 
 * - SELECT문을 기반으로 CREATE TABLE을 할 수 있는 CREATE문이다.
 */
select * from category where category_id = 1;

/* 1. 액션 영화 */
select 
	a.film_id,
	a.title, 
	a.release_year,
	a.length,
	a.rating
from film a, film_category b
where a.film_id = b.film_id 
  and b.category_id = 1;

/* 2. 액션 영화 테이블 생성 */
create table action_film as 
select 
	a.film_id,
	a.title, 
	a.release_year,
	a.length,
	a.rating
from film a, film_category b
where a.film_id = b.film_id 
  and b.category_id = 1;
  
select * from action_film;

/* 3. 만약 존재하지 않는다면 
 * 액션 영화 테이블 생성 */
create table if not exists action_film as 
select 
	a.film_id,
	a.title, 
	a.release_year,
	a.length,
	a.rating
from film a, film_category b
where a.film_id = b.film_id 
  and b.category_id = 1;
  
 ---------------------------------------------------------------------------
 /* ### 테이블 구조 변경 
  * - 한번 만들어진 테이블이라고 하더라도 테이블 구조를 변경할 수 있다.
  * 이 기능으로 인해 업무 변화에 유연하게 대처할 수 있다. */
 create table links(
 	link_id serial primary key,
 	title varchar(512) not null,
 	url varchar(1024) not null
 );
select * from links;

/* 1. 컬럼 추가 */
alter table links add column active boolean;
select * from links;

/* 2. 컬럼 삭제 */
alter table links drop column active;
select * from links;

/* 3. 컬럼 이름 변경 */
alter table links rename column title to link_title;
select * from links;

/* 4. 컬럼 추가 */
alter table links add column target varchar(10);
select * from links;

/* 5. 컬럼 디폴트 값 설정 */
alter table links alter column target set default '_BLANK';
select * from links;

/* 6. 인서트 */
insert into links(link_title, url)
values 
	('PostgreSQL Tutorial', 'http://www.postgresqltutorial.com/');
select * from links;

/* 7. target 컬럼에 대해 check 제약 조건 추가 */
alter table links add check( target in ('_SELF', '_BLANK', '_PARENT', '_TOP') );

insert into links(link_title, url, target)
values 
	('PostgreSQL2', 'http://www.postgresqltutorial.com/', 'whatever');
select * from links;
-- 실패한 자료: (3, PostgreSQL2, http://www.postgresqltutorial.com/, whatever)

---------------------------------------------------------------------------------------
 /* ### 테이블 이름 변경 
  * 한번 만들어진 테이블이라고 하더라도 테이블 이름을 변경할 수 있다. */
create table vendors(
	id serial primary key,
	name varchar not null
);
alter table vendors rename to suppliers;

/* 1. 이름 변경 */
select * from suppliers;
select * from vendors;

/* 2. suppliers group */
create table suppliers_group (
	id serial primary key,
	name varchar not null
);
alter table suppliers add column group_id int not null; -- group_id 추가
alter table suppliers add foreign key (group_id) references suppliers_group(id); -- foreign key 지정

/* 3.아래와 같은 뷰 생성*/
create view supplier_data as 
select 
	s.id,
	s.name,
	g.name "GROUP"
from 
	suppliers s, suppliers_group g
where g.id = s.group_id;

select * from supplier_data; -- 이 뷰를 조회하면 이 셀렉트 문을 돈다.

/* 4. suppliers_group의 이름을 바꾼다 .
 * -> 자동으로 참조하고 있던 테이블(suppliers) DDL이 바뀐다. 
 * -> 자동으로 참조하고 있던 뷰(supplier_data) DDL이 바뀐다.*/
alter table suppliers_group rename to groups;




 