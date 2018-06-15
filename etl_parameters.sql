--drop table dwh.etl_parameters;

create table dwh.etl_parameters
(id integer
,param_name varchar(100)
,param_val varchar(100)
,param_descr varchar(200)
);

create unique index pk_etl_parameters on dwh.etl_parameters (param_name);

--delete from dwh.etl_parameters where param_name = 'json_loaded_date';

--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (1, 'json_date_load_counter', 0, 'Счетчик циклов загрузки документов в stage зону');
--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (2, 'json_loaded_date', '2018-01-01', 'Дата (включительно) до которой загружены цепочки документов начиная с документа order');
commit;

select * from etl_parameters;