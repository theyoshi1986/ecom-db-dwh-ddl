--drop TABLE dwh.stg_okvd_gln_inn;
CREATE TABLE dwh.stg_okvd_gln_inn
(inn int8
,gln int8
,okvd_code varchar(100)
,okvd_name varchar(4000))
;

create index stg_okvd_gln_inn_idx1 on dwh.stg_okvd_gln_inn (gln);

analyze verbose dwh.stg_okvd_gln_inn;
	
select *
	from dwh.stg_okvd_gln_inn;