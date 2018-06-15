create table dwh.dim_city
as
select country_name, region_name, city_name, id_city
	from dwh.stg_country co
		inner join dwh.stg_region re
			on co.id_country=re.id_country
		inner join dwh.stg_city ci
			on re.id_region=ci.id_region
			and co.id_country=ci.id_country;
			
 SELECT * FROM dwh.dim_city
