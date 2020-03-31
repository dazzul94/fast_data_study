/* ### 임시 테이블 
 * - DB 접속 세션의 활동 기간동안 존재하는 테이블이다.
 * 세션이 종료되면 임시 테이블은 자동으로 소멸된다.
 */

create temp table tb_cust_temp_test(cust_id int);
insert into tb_cust_temp_test values(1);
-- 세션 재접속 후
select * from tb_cust_temp_test;

create table tb_cust_temp_test(cust_id serial primary key, cust_nm varchar not null);
select * from tb_cust_temp_test;

select * from tb_cust_temp_test; -- 임시테이블을 바라본다.
-- 세션 재접속하면 일반 테이블 바라본다.

drop table tb_cust_temp_test; -- 임시 테이블을 날린다.
select * from tb_cust_temp_test;

-----------------------------------------------------------------

/* ### TRUNCATE
 * - 대용량의 테이블을 빠르게 지우는 방법이다.
 * 테이블의 세그먼트 자체를 바로 지우기 때문에 빠르게 데이터가 지워진다.
 * 오라클은 truncate가 롤백이 안되지만 postgresql은 롤백이 된다.
 */
-- delete하는 것은 데이터는 지워지지만 
-- rollback을 조건으로 하기 때문에 메모리를 차지한다.
-- truncate는 되돌릴 수 없고, 속도가 빠르다.
truncate table big_table;
truncate table bit_table, big_table_2;

create table big_table as 
select * from action_film;

insert into big_table 
select * from action_film;
commit;

select * from big_table;

truncate table big_table;
rollback;
commit;

/* ### 실습문제1
 * - DVD렌탈 시스템의 관리자는 고객별 매출 순위를 알고 싶다.
 * 신규 테이블을 생성해서 고객의 매출 순위를 관리하고 싶으며 신규테이블의 이름은 CUSTOMER_RANK이고
 * 테이블 구성은 CUSTOMER_ID, CUSTOMER_RANK로 정했다.
 * CTAS 기법을 이용하여 신규테이블을 생성하면서 데이터를 입력해라
 */


select * from payment;
select * from customer;
-- 내가 한거
drop table customer_rank;
create table customer_rank 
as
select
	customer_id,
	row_number() over() customer_rank
from ( 
	select 
		sum(p.amount) amount_sum,
		p.customer_id
	from payment p
	group by p.customer_id
	order by amount_sum desc
) a;

-- 선생님이 한거
create table customer_rank 
as
select 
	a.customer_id,
	row_number() over(order by a.sum_amount desc) customer_rank
from 
(
	select 
		a.customer_id,
		sum(a.amount) as sum_amount
	from payment a
	group by a.customer_id
) a
order by customer_rank;

select * from customer_rank;




