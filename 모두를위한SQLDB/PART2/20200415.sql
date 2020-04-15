-- 01. 식별자 찾기

-- A. movie
select * 
from information_schema.columns c 
where c.table_name = 'movie';
-- movie table column list --> movieid, title_nm, genres_nm
-- pk --> movieid

-- 만약 movieid가 식별자라면 건수가 0이다
-- 만약 movieid가 식별자가 아니라면 건수가 나온다.
select 
	movieid, count(*) cnt
from movie m
group by movieid
having count(*) > 1;

select 
	title_nm, count(*) cnt
from movie m
group by title_nm
having count(*) > 1; -- title_nm도 식별자가 될수 있다. 하지만 주로 이름은 식별자로 쓰지 않는다. 왜냐하면 변경될 수 있기 때문이다.

select 
	genres_nm, count(*) cnt
from movie m
group by genres_nm
having count(*) > 1; -- 건수가 나오므로 식별자가 될 수 없다.

select 
	movieid, title_nm, genres_nm, count(*) cnt
from movie m
group by movieid, title_nm, genres_nm
having count(*) > 1; -- 건수가 나온다면 1정규화 위반이다.

-- B. users
select * 
from information_schema.columns c 
where c.table_name = 'users';
-- users table column list --> userid, gender, age, occupation, zip_code
-- pk --> userid

select 
	userid, count(*) cnt
from users u
group by userid
having count(*) > 1; -- 건수가 나오지 않으므로 pk가 될 수 있다. 

select 
	gender, count(*) cnt
from users u
group by gender
having count(*) > 1; -- 건수가 나오므로 pk가 될 수 없다 

select 
	age, count(*) cnt
from users u
group by age
having count(*) > 1; -- 건수가 나오므로 식별자가 될 수 없다.

select 
	occupation, count(*) cnt
from users u
group by occupation
having count(*) > 1; -- 건수가 나오므로 식별자가 될 수 없다.

select 
	zip_code, count(*) cnt
from users u
group by zip_code
having count(*) > 1; -- 건수가 나오므로 식별자가 될 수 없다.

-- B. users
select * 
from information_schema.columns c 
where c.table_name = 'rating';
-- rating table column list --> userid, movieid, rating_pnt, timestamp
-- pk --> userid, movieid

select 
	userid, count(*) cnt
from rating r
group by userid
having count(*) > 1; -- 건수가 나오므로 pk가 될 수 없다

select 
	movieid, count(*) cnt
from rating r
group by movieid
having count(*) > 1; -- 건수가 나오므로 pk가 될 수 없다 

select 
	rating_pnt, count(*) cnt
from rating r
group by rating_pnt
having count(*) > 1; -- 건수가 나오므로 식별자가 될 수 없다.

-- 컬럼 하나일때의 식별자를 찾지 못했으므로 두가지 조합을 본다.
select 
	userid, movieid, count(*) cnt
from rating r
group by userid, movieid
having count(*) > 1; -- userid, movieid의 조합에서 한건도 나오지 않았다. 
-- 한 유저가 여러개의 영화를 평가할 수 있지만 한번 이상 할 수 없다.

----------------------------------------------------------------------------
-- 02. 참조키 찾기

-- A. users <--> rating
/* step1 */
select 
	*
from users t1 
inner join rating t2
		on t1.userid = t2.userid
limit 1;

select 
	count(*)
from users t1 
inner join rating t2
		on t1.userid = t2.userid;
-- 데이터가 있다는 것: 참조키 관계가 있다.

/* step2 */
select 
	count(distinct t1.userid) d_x1,
	count(distinct t2.userid) d_x2,
	count(t2.userid) x2
from users t1 
left outer join rating t2
		on t1.userid = t2.userid; 
-- 1:n관계다(x1:x2), 선택일수도 필수일수도 있다.

-- B. movie <--> rating
/* step1 */
select 
	*
from movie t1 
inner join rating t2
		on t1.movieid = t2.movieid
limit 1;

select 
	count(*)
from movie t1 
inner join rating t2
		on t1.movieid = t2.movieid;
-- 데이터가 있다는 것: 참조키 관계가 있다.

/* step2 */
select 
	count(distinct t1.movieid) d_x1,
	count(distinct t2.movieid) d_x2,
	count(t2.movieid) x2
from movie t1 
left outer join rating t2
		on t1.movieid = t2.movieid;
-- 1:n관계다(x1:x2), 선택이다.

