select @@default_storage_engine;

create database test;
use test;
create table test(id int, memo varchar(100));

alter table test.test 
ENGINE=MyISAM;

alter table test.test 
ENGINE=InnoDB;

create database test2;
use test2;