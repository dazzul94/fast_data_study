/* ### DELETE문 
* - 테이블에서 특정 데이터를 삭제하거나 테이블 내에 존재하는 모든 데이터를 삭제할 수 있다.*/ 
select 
	* 
from link_tmp;

/* 1. DELETE */ 
delete 
from link 
where id = 5; -- ID가 5인 행을 삭제 
commit; 

/* 2. DELETE JOIN */ 
delete 
from link_tmp a 
using link b 
where a.id = b.id; 
commit; 

/* 3. 전체 행 삭제 */ 
select 
	* 
from link;

delete from link; 
commit; 

select 
	* 
from link_tmp;

delete from link_tmp; 
commit; 
------------------------------------------------------------ 
/* ### UPSERT문 
* - INSESRT를 시도할 때 조건(상황)에 따라 UPDATE를 하는 */ 
create table customers( 
	customer_id serial primary key, 
	name varchar unique, 
	email varchar not null, 
	active bool not null default true 
);

insert into customers
	(name, email) 
values 
	('IBM', 'contact@ibm.com'), 
	('Microsoft', 'contact@microsoft.com'), 
	('Intel', 'contact@intel.com'); 
commit; 

select 
	* 
from customers;

/* 1. DO NOTHING */ 
insert into customers (name, email) 
values 
	('Microsoft', 'hotline@microsoft.com') -- unique 제약조건 어김 . SQL에러 발생 
on conflict (name) 
do nothing; -- 충돌시 아무것도 안함 
commit;

/* 2. UPSERT */ 
insert into customers(name, email) 
values 
	('Microsoft', 'hotline@microsoft.com') -- unique 제약조건 어김 . SQL에러 발생 
on conflict (name) 
do update 
set email = excluded.email || ';' || customers.email; -- excluded.email은 insert시도한 이메일을 가리킨다. 
commit; 
---------------------------------------------------------------------- 
/* ### EXPORT 작업 
* - 테이블의 데이터를 다른 형태의 데이터로 추출하는 작업이다. 대표적으로 CSV 형식으로 가장 많이 추출한다. */ 
/* 1. COPY CSV 
* - 먼저 디렉토리가 존재해야한다.*/ 
copy category(category_id, name, last_update) 
to 'C:\tmp\DB_CATEGORY.csv' 
delimiter ',' 
csv header;

/* 2. COPY TXT 
* - 먼저 디렉토리가 존재해야한다.*/ 
copy category(category_id, name, last_update) 
to 'C:\tmp\DB_CATEGORY.txt' 
delimiter '|' 
csv header;

/* 3. COPY CSV NO HEADER * 
* - 먼저 디렉토리가 존재해야한다.*/ 
copy category(category_id, name, last_update) 
to 'C:\tmp\DB_CATEGORY_NO_HEADER.csv' 
delimiter ','; 
---------------------------------------------------------------------- 
/* ### IMPORT 작업 
* - 다른 형식의 데이터를 테이블에 넣는 작업을 말한다. 데이터 구축시 자주 사용된다. */ 
create table category_import( 
	category_id serial not null, 
	"NAME" varchar(25) not null, 
	last_update timestamp not null default now(), 
	constraint category_import_pkey primary key(category_id) 
); 
select 
	* 
from category_import;

/* 1. IMPORT CSV */ 
copy category_import(category_id, "NAME", last_update) 
from 'C:\tmp\DB_CATEGORY.csv' 
delimiter ',' 
csv header;

delete from category_import;

/* 2. IMPORT TXT */ 
copy category_import(category_id, "NAME", last_update) 
from 'C:\tmp\DB_CATEGORY.txt' 
delimiter '|' 
csv header;

/* 3. IMPORT CSV NO HEADER*/ 
copy category_import(category_id, "NAME", last_update) 
from 'C:\tmp\DB_CATEGORY_NO_HEADER.csv' 
delimiter ',' 
csv; 
--csv header; -- 헤더를 적으면 첫번째 로우를 헤더로 인식하여 한건이 누락된다.