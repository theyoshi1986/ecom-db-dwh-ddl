--drop table dwh.stg_gln2sos;
create table dwh.stg_gln2sos
(
 intgln2sosid bigint
,intglnid bigint
,intsosid bigint
,varguid varchar(128)
,varsoslogin varchar(128)
,varsospass varchar(128)
);

create index stg_gln2sos_idx1 on dwh.stg_gln2sos (varguid);

analyze verbose dwh.stg_gln2sos;

--select * 
--	from dwh.stg_gln2sos;