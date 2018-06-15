--drop table dwh.etl_modules;

create table dwh.etl_modules
(module_id serial,
 module_name varchar(100),
 module_description varchar(1000),
 audir_cd timestamp default current_timestamp,
 audit_rd timestamp);

ALTER TABLE dwh.etl_modules ADD CONSTRAINT etl_modules_pk PRIMARY KEY (module_id);
create index etl_modules_idx2 on etl_modules (module_name);
 
insert into dwh.etl_modules (module_name,module_description) values ('load_json_to_stage','Модуль загрузки json документов в stage зону.');
insert into dwh.etl_modules (module_name,module_description) values ('main_etl_doc_process','Основной процесс загрузки документов в ХД.');
insert into dwh.etl_modules (module_name,module_description) values ('json_parsing_stage','Модуль загрузки json документов в stage зону.');
insert into dwh.etl_modules (module_name,module_description) values ('dbeaver_statement','Логирование выполнения разовых процедур в ide.');
insert into dwh.etl_modules (module_name,module_description) values ('bi_orders_dm_to_load_date','Загрузка витрины bi_orders_dm.');

select * from dwh.etl_modules;
