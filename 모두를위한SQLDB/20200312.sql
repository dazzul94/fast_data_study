/* ### 실습문제2
 * - 고객들에게 단체 이메일을 전송하고자 한다.
 * CUSTOMER 테이블에서 고객의 EMAIL주소를 추출하고, 이메일 형식에 맞지 않은 이메일 주소는 제외시켜라.
 * - 이메일 형식은 ('@'가 존재해야 하고, '@'로 시작하지 말아야 하고, '@'로 끝나지 말아야한다.
 * */
select 
	email
from customer
where email like '%@%'
  and email not like '@%'
  and email not like '%@';
  
----------------------------------------------------------------------------------------------------
/* ### 조인과 집계데이터
 * - 조인이란? 
 * 	+ 2개 이상의 테이블에 있는 정보 중 사용자가 필요한 집합에 맞게 가상의 테이블처럼 만들어서 결과를 보여주는 것
 * - 조인의 종류?
 * 	+ INNER JOIN: 특정 컬럼을 기준으로 정확히 매칭된 집합을 출력한다.
 *  + OUTER JOIN: 특정 컬럼을 기준으로 매칭된 집합을 출력하지만 한쪽의 집합은 모두 출력하고 다른 한쪽의 집합은 매칭되는 컬럼의 값 만을 출력한다.
 *  + SELF JOIN: 동일한 테이블끼리의 특정 컬럼을 기준으로 매칭되는 집합을 출력한다.
 *  + FULL OUTER JOIN: INNER, LEFT OUTER, RIGHT OUTER 조인 집합을 모두 출력한다.
 *  + CROSS JOIN: Cartesian Product이라고도 하며 조인되는 두 테이블에서 곱집합을 반환한다.
 *  + NATURAL JOIN: 특정 테이블의 같은 이름을 가진 컬럼 간의 조인집합을 출력한다.
 * */
 
/* 실습준비 */
create table basket_a(
 	id int primary key,
 	fruit varchar(100) not null
 );
 
select 
	*
from basket_a; -- 공집합

create table basket_b(
 	id int primary key,
 	fruit varchar(100) not null
);

select 
	*
from basket_b; -- 공집합

insert into basket_a(id, fruit)
values
	(1, 'Apple'),
	(2, 'Orange'),
	(3, 'Banana'),
	(4, 'Cucumber')
;
commit; -- 트랜잭션 처리(Insert, Update, Delete)

select 
	*
from basket_a;

insert into basket_b(id, fruit)
values
	(1, 'Orange'),
	(2, 'Apple'),
	(3, 'Watermelon'),
	(4, 'Pear')
;
commit; -- 트랜잭션 처리(Insert, Update, Delete)

select 
	*
from basket_b;

----------------------------------------------------------------------------------------------------
/* ### INNER JOIN
 * - 특정 컬럼을 기준으로 정확히 매칭된 집합을 출력한다.
 * INNER JOIN은 대표적인 조인의 종류이다.
 * */
