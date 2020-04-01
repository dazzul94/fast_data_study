/* ### 실습문제2
 * - DVD렌텔 시스템의 관리자는 매달마다 매출 순위 1위를 한 고객에게 특별한 선물을 주고자 한다.
 * 이러한 업무를 달성하기 위해서 CUSTOMEER_RANK_YYYYMM이라는 테이블을 CTAS 기법으로 생성하는 SQL문을 작성하여라
 * 단, 선물 제공 기준을 정하기 위해 SUM_AMOUNT도 저장하라.
 */
select * from payment;
select * from customer;

-- 내가 한거
drop table customer_rank_yyyymm;

create table customer_rank_yyyymm as 
select 
	customer_id,
	yyyymm,
	sum_amount,
	row_number() over(partition by yyyymm order by sum_amount desc) rank_yyyymm
from (
	select 
		customer_id,
		to_char(payment_date, 'YYYYMM') yyyymm,
		sum(amount) sum_amount
	from payment
	group by customer_id, yyyymm
	order by sum_amount desc, yyyymm
) a;
select * from customer_rank_yyyymm;

-- 선생님이 한거
create table customer_rank_yyyymm as
select 
	a.customer_id,
	a.yyyymm,
	a.sum_amount,
	row_number() over(partition by a.yyyymm order by a.sum_amount desc) as rank_yyyymm
from (
	select 
		a.customer_id, 
		to_char(payment_date, 'yyyymm') as yyyymm,
		sum(a.amount) as sum_amount
	from payment a
	group by a.customer_id, to_char(payment_date, 'yyyymm')
) a
order by yyyymm, rank_yyyymm;

select distinct customer_id from payment;

select 
	*
from customer 
where customer_id in (
	select  
		customer_id 
	from customer_rank_yyyymm 
	where rank_yyyymm in (1,2,3)
);
	
----------------------------------------------------------------------------------------
/* ### 데이터 타입
 * - Boolean 
 * (TRUE, FALSE) ('t', 'f') ('true', 'false') ('y','n') ('yes', 'no') ('1', '0') 
 * */
create table stock_availability
(
	product_id int not null primary key,
	available boolean not null);

insert into stock_availability
values 
	(100, TRUE),
	(200, FALSE),
	(300, 't'),
	(400, '1'),
	(500, 'y'),
	(600, 'yes'),
	(700, 'no'),
	(800, '0');
commit;

/* 1. true */
select * from stock_availability
where available = 'YES';

select * from stock_availability
where available;

/* 2. false */
select * from stock_availability
where available = 'NO'; 

select * from stock_availability
where not available; 
----------------------------------------------------------------------------------------------
/* ### CHAR, VARCHAR, TEXT 
 * - 문자 및 문자열을 다루는 데이터 타입에는 CHAR, VARCHAR, TEXT가 존재한다. 
 * 이 3개의 차이점을 확실히 이해해야 한다. 
 * 1. CHAR(길이) : 고정형 길이, 공간이 남을시 공백으로 패딩
 * 2. VACHAR(길이): 가변형 길이, 공간이 남을시 공백으로 패딩하지 않음 
 * 3. TEXT: 무한대 길의의 문자열을 저장 
 * 4. VARCHAR: TEXT와 동일 */
create table character_test(
	id serial primary key, 
	x char(3),
	y varchar(10),
	z text
);
insert into character_test
values 
	(1, 'Y', 'YES', 'YESYESYES');

select * from character_test;


insert into character_test
values 
	(2, 'YES', 'YES', 'YESYESYES');

select * from character_test
where x = y;