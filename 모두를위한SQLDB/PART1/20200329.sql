/* ### 컬럼추가
 * - 기존에 존재하는 테이블에 컬럼 추가
 */

/* 현재 존재하는 최고의 dbms는 오라클
 * 기본적으로는 오라클의 특성을 알아두는 것이 좋다. 
 * create, drop, alter 이런건 오라클같은 경우에는 치는 순간에는 commit이 된다.즉 commit할 필요가 없다(ddl)
 * delete, update, merge, insert 이런 명령어는 commit(dml)
 * 
 * - postgresql은 
 * create, drop, alter, delete, update, merge, insert 모두 commit 해야한다. 
 * 
 * - 오라클을 기본으로 알아두고 postgresql은 이렇구나 라고 알아두기 
 * 데이터베이스는 도구일 뿐이고 어떤 데이터베이스를 사용하는지는 중요하지 않다. */
create table tb_cust(
	cust_id serial primary key,
	cust_name varchar(50) not null
);

/* 1. 컬럼 한개 추가 */
alter table tb_cust add column phone_number varchar(13);

/* 2. 컬럼 여러개 추가 */
alter table tb_cust add column fax_number varchar(13);
alter table tb_cust add column email_addr varchar(50);


insert into tb_cust 
values 
	(1,'김다솔','010-1234-5678', '02-1234-5678','dazzul94@gmail.com');

/* 3. NOT NULL 제약 컬럼 추가 */
alter table tb_cust
add column contact_nm varchar not null;
--  오류: "contact_nm" 열에는 null 값 자료가 있습니다
-- 컬럼을 추가하려고 하니까 이미 들어간 데이터가 있어서 그 쪽에는 null을 넣을 수 밖에 없다
-- -> 이런 경우에는 우선 NULL조건으로 컬럼을 추가하고 CONTACT_NM 컬럼을 업데이트 치고 다시 
-- not null 조건을 넣어준다.

alter table tb_cust 
add column contact_nm varchar;

update tb_cust 
set contact_nm = '홍길동'
where cust_id = 1;

alter table tb_cust
alter column contact_nm set not null;

-------------------------------------------------------------------------
/* ### 컬럼제거 
 * - 기존에 존재하는 테이블에 컬럼을 삭제할 수 있다.*/
/* 1. 실습 준비 */
create table publishers (
	publisher_id serial primary key,
	name varchar not null
);
create table book_category (
	category_id serial primary key,
	name varchar not null
);
drop table books;
create table books (
	book_id serial primary key,
	title varchar not null,
	isbn varchar not null,
	publisher_date date not null,
	description varchar,
	category_id int not null,
	publisher_id int not null,
	foreign key (publisher_id) references publishers(publisher_id),
	foreign key (category_id) references book_category(category_id)
);


-- 한개의 카테고리는 n개의 북
-- 한개의 북은 한개의 카테에 속해있다. 반드시 카테고리를 가진다.
-- 한개의 출판사는 n개의 북을 출판
-- 한개의 북은 반드시 1개의 출판사

create view book_info as select 
	b.book_id,
	b.title,
	b.isbn,
	b.publisher_date,
	p.name
from books b,
	 publishers p
where p.publisher_id = b.publisher_id
order by title;


/* 2. 컬럼 삭제*/

select * from books;
alter table books drop column category_id;
-- 컬럼이 제거되면서 book의 category_id 포린키도 함께 삭제된다

alter table books drop column publisher_id;
-- 뷰에서 publisher_id를 참조하고 있어서 안지워진다.
-- : 기타 다른 개체들이 이 개체에 의존하고 있어,  publisher_id 칼럼(books 테이블 의) 삭제할 수 없음
-- Detail: book_info 뷰 의존대상:  publisher_id 칼럼(books 테이블 의)
-- Hint: 이 개체와 관계된 모든 개체들을 함께 삭제하려면 DROP ... CASCADE 명령을 사용하십시오

alter table books drop column publisher_id cascade; -- cascade로 지우니까 참조하고 있던 뷰 자체가 날아가버린다.

select * from book_info;
-- 오류: "book_info" 이름의 릴레이션(relation)이 없습니다

/* 3. 두개의 컬럼 삭제*/
alter table books
	drop column isbn,
	drop column description;