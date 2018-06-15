-- drop table stg_city;
-- truncate table stg_city;

create table stg_city
(id_city integer
 ,id_region integer
 ,id_country integer
 ,city_name varchar(100)
);

select * from stg_city;