/* ### 고급 집계 데이터 *
- GROUPING SET절 */
create table sales ( 
	brand varchar not null,
	segment varchar not null,
	quantity int not null,
	primary key(brand, segment) 
);

insert into sales(brand, segment, quantity)
values
	('ABC', 'Premium', 100),
	('ABC', 'Basic', 200),
	('XYZ', 'Premium', 100),
	('XYZ', 'Basic', 300);
commit;

select
	*
from sales;

/* 1.GROUP BY *
- 각각의 GROUP BY / SUM을 해서 UNION ALL을 해야한다.
* - 단점: 동일한 테이블을 4번이나 select했다. 성능저하.한번만 읽으면 되는 테이블을 네번이나 읽었다.
* SQL이 너무 길다-> 유지보수가 어렵다. */

select
	brand,
	segment,
	sum(quantity) sum_qt
from sales
group by brand, segment
union all
select
	brand,
	null,
	sum(quantity) sum_qt
from sales
group by brand
union all
select
	null,
	segment,
	sum(quantity)
	sum_qt
from sales
group by segment
union all
select
	null,
	null,
	sum(quantity) sum_qt
from sales;

/* 2.GROUPING SET */
select
	brand,
	segment,
	sum(quantity) sum_qt
from sales
group by
	grouping sets(
	(brand, segment),
	(brand),
	(segment),
	() )
order by brand, segment;

/*3. 자주쓰이는 함수 GROUPING
* - 해당 컬럼이 집계에 사용되었는가 사용되지 않았는가?
* - 0이면 집계기준에 쓰인것, 1이면 쓰이지 않은것*/
select
	grouping(brand) grouping_brand,
	grouping(segment) grouping_segment,
	brand, segment,
	sum(quantity) sum_qt
from sales
group by 
	grouping sets(
	(brand, segment),
	(brand),
	(segment),
	() )
order by brand, segment;

/*4. CASE문을 이용한 집계기준 출력*/
select
	case when grouping(brand) = 0 and grouping(segment) = 0 then '브랜드 + 등급별'
	when grouping(brand) = 0 and grouping(segment) = 1 then '브랜드별'
	when grouping(brand) = 1 and grouping(segment) = 0 then '등급별'
	when grouping(brand) = 1 and grouping(segment) = 1 then '전체합계'
	else '' end as 집계기준, brand, segment,
	sum(quantity) sum_qt
from sales
group by
	grouping sets(
	(brand, segment),
	(brand),
	(segment),
	() )
order by brand, segment;
----------------------------------------------------------------------------------
/* ### ROLL UP절
* - 지정된 GROUPING 컬럼의 소계를 생성하는데 사용된다. * - 간단한 문법으로 다양한 소계를 출력할 수 있다.
* - 부분적인 집계도 구할 수 있다. */
select
	brand,
	segment,
	sum(quantity)
from sales
group by rollup(brand, segment)
order by brand, segment;

/* - 각 집계조건의 그룹바이와 롤업 첫번째 조건의 그룹바이와 전체합계가 나온다.
ABC Basic 	200 b+s
ABC Premium 100 b+s
ABC 		300 b
XYZ Basic 	300 b+s
XYZ Premium 100 b+s
XYZ 		400 b 
			700 전체 */

/* 1. 등급별 그룹바이*/
select
	segment,
	sum(quantity)
	from sales
group by segment;

select
	segment,
	sum(quantity)
	from sales
group by rollup(segment); -- 전체합계가 나온다.

/* 2. 브랜드별, 등급별 그룹바이*/
select
	brand,
	segment,
	sum(quantity)
from sales
group by brand,segment;

select
	brand,
	segment,
	sum(quantity)
from sales
group by rollup(brand,segment);
--전체합계와 첫번째컬럼(brand)별 합계도 나온다.
-- group by합계 + rollup절에 맨 앞에 온 집합기준의 합계 + 전체 합계

/* 3. 부분롤업*/
select
	brand,
	segment,
	sum(quantity)
from sales
group by segment,
rollup(brand)
order by brand, segment;
-- group by합계 + rollup절에 맨 앞에 온 집합기준의 합계 -- 전체 합계는 나오지 않는다.

select
	brand,
	segment,
	sum(quantity)
from sales
group by brand,
rollup(segment)
order by brand, segment;
-- group by합계 + rollup절에 맨 앞에 온 집합기준의 합계
-- 전체 합계는 나오지 않는다.