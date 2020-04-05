/* ### UNIQUE 제약 조건 
 * - 특정 컬럼의 값이 한 테이블 내에서 유일한 값임을 보장하는 것 
 */
/* 1. UNIQUE 컬럼 */
create table person(
	id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	unique(email)
);
insert into person(first_name, last_name, email)
values 
	('john',
	'doe',
	'j.doe@postgresqltutorial.com');

/*SQL Error [23505]: 오류: 중복된 키 값이 "person_email_key" 고유 제약 조건을 위반함
  Detail: (email)=(j.doe@postgresqltutorial.com) 키가 이미 있습니다.*/
select * from person;

/* 2. UNIQUE 인덱스 생성 */
create table person_unique_index_test(
	id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50)
);
create unique index
ix_person_unique_index_test_01
on person_unique_index_test(email);

insert into person_unique_index_test(first_name, last_name, email)
values 
	('john',
	'doe',
	'j.doe@postgresqltutorial.com');
/*SQL Error [23505]: 오류: 중복된 키 값이 "person_email_key" 고유 제약 조건을 위반함
  Detail: (email)=(j.doe@postgresqltutorial.com) 키가 이미 있습니다.*/
select * from person_unique_index_test;

-------------------------------------------------------------------
/* ### NOT NULL 제약 조건 
 * - 특정 컬럼에 널 값이 들어가는 것을 방지하는 제약이다. 
 */
/* 1. insert */
create table invoice(
	id serial primary key,
	product_id int not null,
	qty numeric not null check(qty > 0),
	net_price numeric check(net_price > 0)
);
insert into invoice(product_id, qty, net_price)
values 
	(null, 1, 1);
/*SQL Error [23502]: 오류: "product_id" 칼럼의 null 값이 not null 제약조건을 위반했습니다.
  Detail: 실패한 자료: (1, null, 1, 1)*/
delete from invoice;

/* 2. update */
create table invoice_update_test(
	id serial primary key,
	product_id int not null,
	qty numeric not null check(qty > 0),
	net_price numeric check(net_price > 0)
);
insert into invoice_update_test(product_id, qty, net_price)
values 
	(1, 1, 1);
update invoice_update_test
set product_id = null 
where product_id = 1;
/*SQL Error [23502]: 오류: "product_id" 칼럼의 null 값이 not null 제약조건을 위반했습니다.
  Detail: 실패한 자료: (1, null, 1, 1)*/

----------------------------------------------------------------------------------------------
/* ### 실습문제 1
 * 영화예매 시스템을 구축하고자 한다. 아래의 요구조건을 부합하는 물리 테이블을 생성하고 
 * 임의의 테스트 데이터를 입력하시오.
 */
/* 내가 한거 */
drop table my_tb_movie_cust;
create table my_tb_movie_cust(
	cust_id varchar(10) primary key,
	name varchar(50) not null,
	gender varchar(6) check(gender = '남자' or gender = '여자'),
	birth_date date not null,
	address varchar(200),
	phone_number varchar(13),
	cust_rank varchar(1) not null check(cust_rank = 'S' or cust_rank = 'A' or cust_rank = 'B' or cust_rank = 'C' or cust_rank = 'D'),
	enter_date date not null check(enter_date <= exit_date),
	exit_date date not null default '9999-12-31'
);
drop table my_tb_movie_resv;
create table my_tb_movie_resv(
	resv_id varchar(10) not null primary key,
	movie_id varchar(6) not null,
	theater_id varchar(6) not null,
	cust_id varchar(10) not null references my_tb_movie_cust(cust_id),
	start_time timestamp not null check(start_time < end_time),
	end_time timestamp not null,
	seat_number varchar(4) not null
);

insert into my_tb_movie_cust
	(cust_id, name , gender, birth_date, address, phone_number, cust_rank, enter_date)
values 
	('dazzul', '김다솔', '여자', '1994-03-11', '풍무', '010-1234-5678', 'S', '2020-04-04');
select * from my_tb_movie_cust;

insert into my_tb_movie_resv
	(resv_id, movie_id, theater_id, cust_id, start_time, end_time, seat_number)
values 
	('1', '1234', '5678', 'dazzul', current_timestamp, current_timestamp + interval '2 hours', '1');

select * from my_tb_movie_resv;

/* 선생님이 한거 */
create table tb_movie_cust
(
	cust_id char(10) primary key,
	cust_nm varchar(50) not null,
	sex varchar(6) not null check (sex in ('남자', '여자')),
	birth_date date not null,
	address varchar(200),
	phone_number varchar(13),
	cust_grade char(1) check (cust_grade in ('S', 'A', 'B', 'C', 'D')),
	join_dt date not null check (join_dt <= expire_dt),
	expire_dt date not null default to_date('9999-12-31', 'YYYY-MM-DD')
);

insert into tb_movie_cust(cust_id, cust_nm, sex, birth_date, address, phone_number, cust_grade, join_dt)
values 
	('0000000001', '김다솔', '여자', to_date('1984-06-12', 'YYYY-MM-DD'), '용인', '010-1234-5678', 'S', to_date('2017-01-01', 'YYYY-MM-DD')),
	('0000000002', '김다솔2', '여자', to_date('1994-06-12', 'YYYY-MM-DD'), '용인', '010-1234-5678', 'S', to_date('2017-01-01', 'YYYY-MM-DD')),
	('0000000003', '김다솔3', '여자', to_date('1994-03-11', 'YYYY-MM-DD'), '용인', '010-1234-5678', 'S', to_date('2017-01-01', 'YYYY-MM-DD'));
select * from tb_movie_cust;

create table tb_movie_resv(
	resv_no char(10) not null primary key,
	movie_id char(6) not null,
	movie_theater_id char(6) not null,
	cust_id char(10) references tb_movie_cust(cust_id) not null,
	movie_start_time timestamp not null check(movie_start_time < movie_end_time),
	movie_end_time timestamp not null,
	seat_number char(4) not null
);

insert into tb_movie_resv
values 
	('9000000001','000001', '000010', '0000000001', to_timestamp('2019-05-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2019-05-01 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'A-01'),
	('9000000002','000002', '000020', '0000000001', to_timestamp('2019-05-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2019-05-01 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'B-01'),
	('9000000003','000003', '000030', '0000000002', to_timestamp('2019-05-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2019-05-01 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'C-01');
select * from tb_movie_cust;

----------------------------------------------------------------------------------------------
/* ### 실습문제 2
 * - 영화 예매 시스템의 고객통계를 보고 싶다. 아래의 조건을 만족하는 sQL을 작성하시오.
 */
drop table tb_movie_cust;
drop table tb_movie_resv;

insert into tb_movie_cust(cust_id ,cust_nm, sex, birth_date, address, phone_number, cust_grade, join_dt)
values 
	('0000000004', '이승우', '남자', to_date('1984-06-12', 'YYYY-MM-DD'), '서울', '010-1234-5678', 'S', to_date('2017-01-01', 'YYYY-MM-DD')),
	('0000000005', '안정환', '여자', to_date('2000-09-12', 'YYYY-MM-DD'), '풍무', '010-1234-5678', 'A', to_date('2014-01-01', 'YYYY-MM-DD')),
	('0000000006', '고종수', '남자', to_date('1695-03-11', 'YYYY-MM-DD'), '용인', '010-1234-5678', 'D', to_date('2012-01-01', 'YYYY-MM-DD')),
	('0000000007', '기성용', '여자', to_date('1999-03-13', 'YYYY-MM-DD'), '용인', '010-1234-5678', 'B', to_date('2012-01-01', 'YYYY-MM-DD')),
	('0000000008', '이성용', '남자', to_date('1879-12-15', 'YYYY-MM-DD'), '경주', '010-1234-5678', 'B', to_date('2012-01-01', 'YYYY-MM-DD')),
	('0000000009', '박지성', '남자', to_date('1987-05-11', 'YYYY-MM-DD'), '울산', '010-1234-5678', 'C', to_date('2012-01-01', 'YYYY-MM-DD'));
insert into tb_movie_cust(cust_id ,cust_nm, sex, birth_date, address, phone_number, cust_grade, join_dt)
values 
	('0000000010', '이승우2', '남자', to_date('1984-06-12', 'YYYY-MM-DD'), '서울', '010-1234-5678', 'A', to_date('2017-01-01', 'YYYY-MM-DD')),
	('0000000011', '이승우3', '남자', to_date('1984-06-12', 'YYYY-MM-DD'), '서울', '010-1234-5678', 'D', to_date('2017-01-01', 'YYYY-MM-DD'));
	
select * from tb_movie_cust;
-- 고객 테이블의 고객 등급별 통계
/*전체 고객수/등급의 개수/등급별평균고객수/등급별최대고객수/등급별최소고객수/최소고객수의등급/최대고객수의 등급*/

-- 내가 한거....
select 
	(select count(*) from tb_movie_cust) as all_cnt,
	(select count(distinct cust_grade) from tb_movie_cust) as grade_cnt,
	(select 
		avg(group_cnt)
	from (
		select 
			count(*) group_cnt,
			cust_grade
		from tb_movie_cust
		group by cust_grade
	) a) as group_avg_cnt,
	(select 
		max(group_cnt)
	from (
		select 
			count(*) group_cnt,
			cust_grade
		from tb_movie_cust
		group by cust_grade
	) a) as group_max_cnt,
	(select 
		min(group_cnt)
	from (
		select 
			count(*) group_cnt,
			cust_grade
		from tb_movie_cust
		group by cust_grade
	) a) as group_min_cnt,
	(select 
		cust_grade
	from (
		select 
			count(*) group_cnt,
			cust_grade
		from tb_movie_cust
		group by cust_grade
		order by group_cnt asc limit 1
	) a) as min_cust_grade,
	(select 
		cust_grade
	from (
		select 
			count(*) group_cnt,
			cust_grade
		from tb_movie_cust
		group by cust_grade
		order by group_cnt desc limit 1
	) a) as max_cust_grade;

-- 선생님이 한거
/*카티션 곱의 법칙에 따라 9 * 1 * 1 * 1 = 9가 나온다*/
select 
	count(*) "전사고객수",
	count(distinct cust_grade) "등급의개수",
	round(max(avg_by_grade), 2) "등급별평균고객수",
	max(max_by_grade) "등급별최대고객수",
	max(min_by_grade) "등급별최소고객수",
	max(grade_by_min_emp_count) "최소고객수의등급",
	max(grade_by_max_emp_count) "최대고객수의등급"
from tb_movie_cust,
(
	select 
		avg(cnt) avg_by_grade,
		max(cnt) max_by_grade,
		min(cnt) min_by_grade
	from (
		select 
			count(*) cnt 
		from tb_movie_cust a
		group by cust_grade
	) b
) b,
(
	select 
		cust_grade as grade_by_min_emp_count
	from ( 
		select 
			cust_grade,
			count(*) cnt
		from tb_movie_cust
		group by cust_grade
		order by cnt
	) c
	limit 1
) c,
(
	select 
		cust_grade as grade_by_max_emp_count
	from ( 
		select 
			cust_grade,
			count(*) cnt
		from tb_movie_cust
		group by cust_grade
		order by cnt desc
	) d
	limit 1
) d
-- 인라인뷰로 하면됨 그냥 1*1 = 1이니까
