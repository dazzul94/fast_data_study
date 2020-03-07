/* ### SELECT 
 * 일반적으로 테이블에 저장된 데이터를 가져오는 데 쓰인다.
 * SQL에서 가장 많이 쓰이는 문장이다.
 * SELECT: 선발하다.
 * ctrl + enter: 실행
 * ctrl + shift + e: 실행계획 조회
 * */

/* 1. 전체 컬럼을 조회 */

select
	*
from customer;

/* 2. 컬럼 지정해서 조회 */
select
	first_name,
	last_name,
	email
from customer;

/* 3. Alias: 코드의 가독성이 높아진다. SQL 성능이 높아진다.
DBMS에는 옵티마이저가 있는데 이것은 최적화기고 SQL을 가장 빠르고 저비용으로 실행하도록 한다. 
이때  Alias를 쓰는 버릇을 들이면 좋다. */
select 
	first_name,
	last_name,
	email
from customer c 

--------------------------------------------------------------------------------------
/* ### order by
 * SELECT문에서 가져온 데이터를 정렬하는데 사용한다.
 * 업무 처리상 매우 중요한 기능이다.
 * */

/* 1. ASC 정렬 */
select 
	first_name,
	last_name
from customer c 
order by first_name asc;

/* 2. DESC 정렬 */
select 
	first_name,
	last_name
from customer c 
order by first_name desc;


/* 3. ASC + DESC 정렬 -> 가독성이 좋다.*/
select 
	first_name,
	last_name
from customer c 
order by first_name asc
		,last_name desc;

/* 4. ASC + DESC 정렬 (줄임) -> 가독성이 나쁘다. 유지보수 측면에서 */
select 
	first_name,
	last_name
from customer c 
order by 1 asc  -- 첫번째 컬럼
		,2 desc;  -- 두번째 컬럼