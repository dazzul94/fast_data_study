-- ************************************** users

CREATE TABLE users
(
 UserID     integer NOT NULL,
 Gender     varchar(1) NOT NULL,
 Age        integer NOT NULL,
 Occupation integer NOT NULL,
 Zip_code   varchar(10) NOT NULL,
 CONSTRAINT PK_users PRIMARY KEY ( UserID )
);

-- ************************************** movie

CREATE TABLE movie
(
 MovieID   integer NOT NULL,
 Title_nm  varchar(100) NOT NULL,
 Genres_nm varchar(100) NOT NULL,
 CONSTRAINT PK_movie PRIMARY KEY ( MovieID )
);

-- ************************************** rating

CREATE TABLE rating
(
 UserID     integer NOT NULL,
 MovieID    integer NOT NULL,
 Rating_pnt integer NOT NULL,
 Timestamp  varchar(10) NOT NULL,
 CONSTRAINT PK_rating PRIMARY KEY ( UserID, MovieID ),
 CONSTRAINT FK_25 FOREIGN KEY ( UserID ) REFERENCES users ( UserID ),
 CONSTRAINT FK_28 FOREIGN KEY ( MovieID ) REFERENCES movie ( MovieID )
);

CREATE INDEX fkIdx_25 ON rating
(
 UserID
);

CREATE INDEX fkIdx_28 ON rating
(
 MovieID
);


-- 00. 데이터 확인
select * from movie;

select * from users;

select * from rating;


















