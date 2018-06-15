--drop TABLE dwh.stg_geodata;
CREATE TABLE dwh.stg_geodata
(
  id bigint
, name_Utf8 varchar(4000)
, name_Ascii varchar(4000)
, alternatenames varchar(4000)
, name_rus varchar(4000)
, latitude varchar(4000)
, longitude varchar(4000)
, feature_class varchar(4000)
, feature_code varchar(4000)
, country_code varchar(4000)
, country_code_alternate varchar(4000)
, admin1_code varchar(4000)
, admin2_code varchar(4000)
, admin3_code varchar(4000)
, admin4_code varchar(4000)
, population bigint
, elevation varchar(4000)
, dem varchar(4000)
, timezone varchar(4000)
, audit_modify_date varchar(4000)
)
;

--Извлекаем данные по русским названиям
update dwh.stg_geodata
	set name_rus = 	case
					 when strpos(substring(lower(alternatenames),'[а-я]+.*'),',') > 0 
						 then substring(substring(lower(alternatenames),'[а-я]+.*'),1,strpos(substring(lower(alternatenames),'[а-я]+.*'),',')-1)
					 else substring(lower(alternatenames),'[а-я]+.*')
					end;

create index stg_geodata_idx1 on dwh.stg_geodata (name_rus);

analyze verbose dwh.stg_geodata;
	
select id, name_rus
	from dwh.stg_geodata
		where name_rus is not null;