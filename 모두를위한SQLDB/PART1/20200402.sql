/* ### NUMERIC 
 * - 정수부터 실수형까지의 숫자를 표현하며 각각의 자릿수를 지정할 수 있는 타입이다.
 */

/* 1. NUMERIC 실습 */
drop table products;
create table products(
	id serial primary key,
	name varchar not null,
	price numeric(5, 2)
);
insert into products(name, price)
values 
	('Phone', 500.215),
	('Tablet', 500.214);
-- 자동으로 반올림이 되는 것은 안좋은것
select * from products;

/* 2. NUMERIC 실습 */
insert into products(name, price)
values 
	('공기청정기', 123456.21);
/*SQL Error [22003]: 오류: 수치 필드 오버플로우
  Detail: 전체 자릿수 5, 소수 자릿수 2의 필드는 10^3보다 작은 절대 값으로 반올림해야 합니다.*/

/* 3. NUMERIC 실습 */
create table products_2(
	id serial primary key,
	name varchar not null,
	price numeric(6, 3)
);
insert into products_2(name, price)
values 
	('Phone', 500.215),
	('Tablet', 500.214);
	
select * from products_2;

/* ### INTEGER
 * - SMALLINT: 작은 인트(2)
 * - INTEGER: 4바이트
 * - BIGINT: 8바이트
 */
drop table books;
-- 책의 페이지는 절대로 32767을 넘지 않는다고 했을 때 
create table books(
	book_id serial primary key,
	title varchar(255) not null,
	pages smallint not null check(pages > 0)
);
-- 도시의 인구는 절대로 2147483647명을 넘지 않는다고 했을때
create table cities(
	city_id serial primary key,
	city_name varchar(255) not null,
	population int not null check (population >= 0)
);

/* ### SERIAL 
 * - INTEGER 형식으로 구현된 sequential한 데이터. 유일성을 보장하는 PK에 자주사용
 * - 시퀀스와 동일하다.
 */
/* 1. sequence 실습 */
drop sequence table_name_id_seq;
drop table table_name;
create sequence table_name_id_seq;
create table table_name(
	id integer not null default nextval('table_name_id_seq')
);

alter sequence table_name_id_seq owned by table_name.id;
insert into table_name values(default);

select * from table_name;

/* 2. serial 실습*/
create table fruits(
	id serial primary key,
	name varchar not null
);
insert into fruits(name) values ('orange');
insert into fruits(id, name) values(default, 'apple');

select * from fruits;

select currval(pg_get_serial_sequence('fruits', 'id')); -- 현재 시퀀스 조회

/* ### DATE, TIME, TIMESTAMP
 * - 일자 및 시간을 관리하는 주요 데이터 타입 
 */
/* 1. DATE*/
select now()::date;
select current_date;
select to_char(now()::date, 'dd/mm/yyyy');
select to_char(now()::date, 'Mon dd,yyyy');

select 
	first_name,
	last_name,
	now() - create_date as diff
from customer;

select 
	first_name,
	last_name,
	age(create_date) as diff
from customer;

select 
	first_name,
	last_name,
	extract(year from create_date) as year,
	extract(month from create_date) as month,
	extract(day from create_date) as day
from customer;

/* 2. TIME */
select current_time;
select localtime;

select
	localtime,
	extract(hour from localtime) as hour,
	extract(minute from localtime) as minute,
	extract(second from localtime) as second,
	extract(milliseconds from localtime) as milliseconds
	
select time '10:00' - time '02:00' as diff;

select time '10:59' - time '02:01' as diff;

select time '10:59:59' - time '02:00:01' as diff;

select 
	localtime,
	localtime + interval '2 HOURS' as plus_2hours,
	localtime - interval '2 HOURS' as minus_2hours;
/* 3. TIMESTAMP */
select now();
select current_timestamp;
select timeofday();

select 
	to_char(current_timestamp, 'YYYY'),
	to_char(current_timestamp, 'YYYY-MM'),
	to_char(current_timestamp, 'YYYY-MM-DD'),
	to_char(current_timestamp, 'YYYY-MM-DD HH24'),
	to_char(current_timestamp, 'YYYY-MM-DD HH24:MI'),
	to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS'),
	to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS.MS'),
	to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS.US')