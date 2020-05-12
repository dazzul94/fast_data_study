-- 03. 컬럼값 범위 점검 
select * from movie; -- title_nm에 영화제목과 출시년도가 혼재되어있다.

-- split_part, right
select 
	col1,
	split_part(col1, ',', 1) part1,
	split_part(col1, ',', 2) part2,
	split_part(col1, ',', 3) part3
from (select '1, 2, 3' col1) c; -- 인라인뷰

select right('123456789', 3) right_result;
drop table movie2;
create table movie2 as (
	select 
		movieid,
		case when title_nm like '%(1%' then split_part(title_nm, '(1', 1)
			 when title_nm like '%(2%' then split_part(title_nm, '(2', 1) end title_nm,
		replace(replace(right(title_nm, 6), ')', ''), '(', '') release_year,
		genres_nm
	from movie
);
--where title_nm like '%(1%';
--where title_nm like '%(2%';
select * from movie2
where release_year like '%2%';

alter table movie rename to movie_old;
alter table movie2 rename to movie;

select * from movie;
select * from movie_old;

----------------------------------------------------------------
-- 04. 분석변수 만들기
select * from movie; -- 장르이름 -> 0, 1, 2 .... 숫자로
/*	* Action
	* Adventure
	* Animation
	* Children's
	* Comedy
	* Crime
	* Documentary
	* Drama
	* Fantasy
	* Film-Noir
	* Horror
	* Musical
	* Mystery
	* Romance
	* Sci-Fi
	* Thriller
	* War
	* Western*/
select
	m.movieid,
	m.title_nm,
	m.release_year,
	m.genres_nm,
	case when m.genres_nm like '%Action%' 	   then 1 else 0 end action_yn,
	case when m.genres_nm like '%Adventure%'   then 1 else 0 end adventure_yn,
	case when m.genres_nm like '%Children''s%' then 1 else 0 end childrens_yn,
	case when m.genres_nm like '%Comedy%' 	   then 1 else 0 end comedy_yn,
	case when m.genres_nm like '%Crime%' 	   then 1 else 0 end crime_yn,
	case when m.genres_nm like '%Documentary%' then 1 else 0 end documentary_yn,
	case when m.genres_nm like '%Drama%' 	   then 1 else 0 end drama_yn,
	case when m.genres_nm like '%Fantasy%' 	   then 1 else 0 end fantasy_yn,
	case when m.genres_nm like '%Film-Noir%'   then 1 else 0 end filmNoir_yn,
	case when m.genres_nm like '%Horror%' 	   then 1 else 0 end horror_yn,
	case when m.genres_nm like '%Musical%' 	   then 1 else 0 end musical_yn,
	case when m.genres_nm like '%Mystery%' 	   then 1 else 0 end mystery_yn,
	case when m.genres_nm like '%Romance%' 	   then 1 else 0 end romance_yn,
	case when m.genres_nm like '%Sci-Fi%' 	   then 1 else 0 end scifi_yn,
	case when m.genres_nm like '%Thriller%'    then 1 else 0 end thriller_yn,
	case when m.genres_nm like '%War%' 		   then 1 else 0 end war_yn,
	case when m.genres_nm like '%Western%' 	   then 1 else 0 end western_yn
from movie m