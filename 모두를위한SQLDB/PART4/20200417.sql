-- 유저별 장르 선호도에 대한 데이터셋 만들기
select 
	*
from rating r
inner join
(
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
) m on r.movieid = m.movieid;

-- with문 사용
with movie as (
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
)
select 
	r.userid,
	count(*) movie_cnt, -- 한 유저가 몇개의 영화를 카운트 했냐
	sum(case when action_yn = 1 then r.rating_pnt end) action_rating_pnt, -- 액션영화의 별점 합
	count(case when action_yn = 1 then r.movieid end) action_cnt, -- 액션영화의 수
	sum(case when adventure_yn = 1 then r.rating_pnt end) adventure_rating_pnt, 
	count(case when adventure_yn = 1 then r.movieid end) adventure_cnt,
	sum(case when childrens_yn = 1 then r.rating_pnt end) childrens_rating_pnt, 
	count(case when childrens_yn = 1 then r.movieid end) childrens_cnt, 
	sum(case when comedy_yn = 1 then r.rating_pnt end) comedy_rating_pnt, 
	count(case when comedy_yn = 1 then r.movieid end) comedy_cnt, 
	sum(case when crime_yn = 1 then r.rating_pnt end) crime_rating_pnt, 
	count(case when crime_yn = 1 then r.movieid end) crime_cnt, 
	sum(case when documentary_yn = 1 then r.rating_pnt end) documentary_rating_pnt, 
	count(case when documentary_yn = 1 then r.movieid end) documentary_cnt, 
	sum(case when drama_yn = 1 then r.rating_pnt end) drama_rating_pnt, 
	count(case when drama_yn = 1 then r.movieid end) drama_cnt, 
	sum(case when fantasy_yn = 1 then r.rating_pnt end) fantasy_rating_pnt, 
	count(case when fantasy_yn = 1 then r.movieid end) fantasy_cnt, 
	sum(case when filmNoir_yn = 1 then r.rating_pnt end) filmNoir_rating_pnt, 
	count(case when filmNoir_yn = 1 then r.movieid end) filmNoir_cnt, 
	sum(case when horror_yn = 1 then r.rating_pnt end) horror_rating_pnt, 
	count(case when horror_yn = 1 then r.movieid end) horror_cnt, 
	sum(case when musical_yn = 1 then r.rating_pnt end) musical_rating_pnt, 
	count(case when musical_yn = 1 then r.movieid end) musical_cnt, 
	sum(case when mystery_yn = 1 then r.rating_pnt end) mystery_rating_pnt, 
	count(case when mystery_yn = 1 then r.movieid end) mystery_cnt, 
	sum(case when romance_yn = 1 then r.rating_pnt end) romance_rating_pnt, 
	count(case when romance_yn = 1 then r.movieid end) romance_cnt, 
	sum(case when scifi_yn = 1 then r.rating_pnt end) scifi_rating_pnt, 
	count(case when scifi_yn = 1 then r.movieid end) scifi_cnt, 
	sum(case when thriller_yn = 1 then r.rating_pnt end) thriller_rating_pnt, 
	count(case when thriller_yn = 1 then r.movieid end) thriller_cnt, 
	sum(case when war_yn = 1 then r.rating_pnt end) war_rating_pnt, 
	count(case when war_yn = 1 then r.movieid end) war_cnt, 
	sum(case when western_yn = 1 then r.rating_pnt end) western_rating_pnt, 
	count(case when western_yn = 1 then r.movieid end) western_cnt 
from rating r 
inner join movie m
on r.movieid = m.movieid
group by r.userid;

