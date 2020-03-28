/* ### 테이블 관리(데이터타입) 
* - 테이블은 컬럼으로 이루어져 있고, 컬럼은 다양한 데이터 타입을 지원한다. 
* - 이는 rdbms가 제 역할을 하는데 있어서 매우 중요하다. 
* - 1. boolean 
* - 2. character 
* + 1) char(고정형) 
* + 2) varchar(가변형) 
* + 3) text(대용량의 문자데이터) 
* - 3. nummeric 
* + 1) int(4) 
* + 2) smallint(2) 
* + 3) float(8): 부동형 소수점 데이터 
* + 4) numeric: 전체 크기와 소수점의 크기를 지정 
* - 4. time 
* + 1) date: 일자 데이터 저장 
* + 2) time: 시간 데이터 저장 
* + 3) timestamp: 일자와 시간 데이터 모두 저장 
* - 5. arrays 
* + 1) array: 배열 형식의 데이터 저장 . 한개의 컬럼에 여러개의 데이터를 동시에 저장할수 있고 저장한 데이터의 순서로 조회할 수 있다. 
* - 6. json: json형식의 데이터를 저장한다. json형식의 데이터를 입력해서 json형식대로 각 level의 데이터를 저장할 수 있다. */ 
create table data_type_test_1 ( 
	a_boolean boolean, 
	b_char char(10), 
	c_varchrar varchar(10), 
	d_text text, e_int int, 
	f_smallint smallint, 
	g_float float, 
	h_numeric numeric(15, 2) 
); 
/* 1. 테스트 */ 
insert into data_type_test_1 
values ( 
	true, -- a_boolean 
	'abcde', -- b_char 
	'abcde', -- c_varchrar 
	'text', -- d_text 
	1000, -- e_int 
	10, -- f_smallint 
	10.12345, -- g_float 
	10.25 -- h_numeric 
); 
commit;

select * from data_type_test_1; 
-- char형에는 'abcde ' 뒤에 다섯개의 공백이 들어갔다.(고정형이기 때문에)
 
create table data_type_test_2 ( 
	a_date date, 
	b_time time, 
	c_timestamp timestamp, 
	d_array text[], 
	e_json json 
); 
/* 2. 테스트 */ 
insert into data_type_test_2 
values ( 
	current_date, -- a_date 
	localtime, -- b_time 
	current_timestamp, -- c_timestamp 
	array['010-1234-1234', '010-4321-4321'], -- d_array 
	'{"customer": "john doe", "items": {"product": "beer", "qty": 6}}' -- e_json 
);

select * from data_type_test_2;

select 
	to_char(c_timestamp, 'yyyy-mm-dd hh24:mi:ss') 
from data_type_test_2;
---------------------------------------------------------------------------------------------- 
/* ### 테이블관리 - 테이블 생성 
* - 테이블은 데이터를 담는 그릇으로써 반드시 생성해야만 데이터를 저장할 수 있다. 
* - 테이블 생성시 컬럼의 제약 조건 
* + 1) NOT NULL: NULL 허용하지 않음 
* + 2) UNIQUE: 컬럼의 값은 테이블 내에서 유일한 값이어야 한다. 
* + 3) PRIMARY KEY: 컬럼의 값은 테이블 내에서 유일한 값이어야 하고 NOT NULL 
* + 4) CHECK: 지정하는 조건에 맞는 값이 들어가야 한다. 
* + 5) REFERENCES: 참조하는 테이블의 특정 컬럼에 값이 존재해야 한다. 
* - PK없이 UK만 지정하는것은 잘못된 것이다. * */ 
-- uk이고 not null이라고 해서 pk는 아니다 . 
-- 엄밀히 말하면 이 테이블의 pk는 user_id다 
create table account( 
	user_id serial primary key, 
	username varchar(50) unique not null, 
	password varchar(50) not null, 
	email varchar(355) unique not null, 
	created_on timestamp not null, 
	last_login timestamp 
); 
create table role ( 
	role_id serial primary key, 
	role_name varchar(255) unique not null 
); 

-- account와 role과의 관계를 맺어주는 테이블(다대다 관계를 회피하기 위한 중간 테이블) 
create table account_role ( 
	user_id integer not null, 
	role_id integer not null, 
	grant_date timestamp without time zone, 
	primary key (user_id, role_id), -- 기본키는 user_id와 role_id 두개 지정 
	constraint account_role_role_id_fkey foreign key (role_id) -- role_id 컬럼은 role테이블의 role_id 컬럼을 참조한다. 
	references role (role_id) match simple -- role_id 컬럼은 role테이블의 role_id컬럼에 대한 삭제 혹은 변경시 아무것도 하지 않는다. 
	on update no action on delete no action, constraint account_role_user_id_fkey foreign key (user_id) -- user_id 컬럼은 account테이블의 user_id 컬럼을 참조한다. 
	references account(user_id) match simple on -- user_id 컬럼은 account테이블의 user_id컬럼에 대한 삭제 혹은 변경시 아무것도 하지 않는다 
	update no action on delete no action 
); 

insert into account values
	(1, '김다솔', '1234', 'dazzul94@gmail.com', current_timestamp, null); 
commit;

select * from account;

insert into role values(1, 'DBA'); 
insert into role values(2, 'Developer'); 
commit;

select * from role; 
insert into account_role values(1, 1, current_date); 
insert into account_role values(1, 2, current_date); 
select * from account_role; 
/* 오류 */ 
insert into account_role values(2, 1, current_date); -- (user_id)=(2) 키가 "account" 테이블에 없습니다. 참조무결성 위배 
insert into account_role values(1, 3, current_date); -- (role_id)=(3) 키가 "role" 테이블에 없습니다. 참조무결성 위배 
insert into account_role values(1, 1, current_date); -- (user_id, role_id)=(1, 1) 키가 이미 있습니다. 키 중복 
update account set user_id = 2 where user_id = 1; -- (user_id)=(1) 키가 "account_role" 테이블에서 여전히 참조됩니다. -- 이미 account_role에서 참조하고 있다. 
delete from account where user_id = 1; -- (user_id)=(1) 키가 "account_role" 테이블에서 여전히 참조됩니다. -- 이미 account_role에서 참조하고 있다.