/* ### UPDATE문 
* - 테이블의 존재하는 데이터를 수정하는 작업이다. 업무를 처리하는데 필수적인 것이며 동시성에 유의해야한다. 
* - LOCK을 잠근다.(행 자체를 잠근다) 
* - 다른 요청이 들어오면 대기를 한다. 
* - RDBMS를 사용하는 이유: 데이터에 여러명의 사용자가 들어왔을 때, 락을 거는 것이 필요. 
* - 바로바로 커밋을 해야 동시성이 좋아진다. */ 
/* 1. LAST_UPDATE 컬럼 추가(디폴트는 현재날짜)*/ 
select 
	* 
from link; 

alter table link add column last_update date; 
alter table link alter column last_update set default current_date;

/* 2. UPDATE */ 
update link 
	set last_update = default 
where last_update is null; 
commit; 

/* 3. 전체 테이블 수정 */ 
update link 
	set rel = 'NO DATA'; 
commit;

/* 4. 특정컬럼을 업데이트 한다. */ 
update link 
	set description = name; 
commit; 
--------------------------------------------------------------------------------- 
/* ### UPDATE JOIN문 
* - 두 개 이상의 테이블을 조인해서 업데이트도 같이 하자. 
* - 자주 쓰인다. 
* - UPDATE시 다른 테이블의 내용을 참조하고 싶을 때 UPDATE JOIN문을 사용한다. 
* - 복잡한 업무를 처리하는데 매우 유용한 방법이다. */ 
/*1. 실습준비 */ 
create table product_segment ( 
	id serial primary key, 
	segment varchar not null, 
	discount numeric(4,2) 
); 

insert into product_segment (segment, discount) 
values 
	('Grand Luxury', 0.05), 
	('Luxury', 0.06), 
	('Mass', 0.1); 
commit; 

create table product ( 
	id serial primary key, 
	name varchar not null, 
	price numeric(10, 2), 
	net_price numeric(10, 2), 
	segment_id int not null, 
	foreign key(segment_id) 
	references product_segment(id) 
); 

insert into product
	(name, price, segment_id) 
values 
	('K5', 804.89, 1), 
	('K7', 228.55, 3), 
	('K9', 567.98, 2), 
	('SONATA', 666.55, 3), 
	('SPARK', 567.55, 2), 
	('AVANTE', 678.76, 3), 
	('LOZTE', 441.23, 2), 
	('SANTAFE', 445.66, 1), 
	('TUSON', 887.77, 3), 
	('TRAX', 789.55, 2), 
	('ORANDO', 163.66, 1), 
	('RAY', 456.66, 1), 
	('MORNING', 982.55, 3), 
	('VERNA', 207.88, 1), 
	('K8', 985.45, 1), 
	('TICO', 896.38, 1), 
	('MATIZ', 575.74, 2), 
	('SPORTAGE', 530.64, 2), 
	('ACCENT', 892.43, 1), 
	('TOSCA', 161.71, 3); 
commit;

select 
	* 
from product;

select 
	* 
from product_segment;
-- 1개의 세그먼트는 여러개의 제품을 갖는다. 
-- 1개의 제품은 무조건 1개의 세그먼트 아이디를 갖는다.
 
/* 2. UPDATE JOIN 
* - 정가에다가 할인율을 곱해서 정말 net_price를 구한다. 
* - 정가- 할인금액 = 정가 - (정가*할인율) */ 
update product a 
	set net_price = a.price - (a.price * b.discount) 
from product_segment b 
where a.segment_id = b.id; 
commit;