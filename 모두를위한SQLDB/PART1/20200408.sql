/* ### 실습 문제 2
 * WITH문과 ROW_NUMBER()를 이용하여 FILM테이블에서 RATING컬럼별로 
 * LENGTH컬럼이 가장 긴 영화의 목록을 구하는 SELECT문을 작성하시오.
 */
with tmp1 as (
	select 
		film_id,
		title,
		rating,
		length,
		row_number() over(partition by rating order by length desc) length_rank
	from film
)
select 
	*
from tmp1
where length_rank = 1;