--drop table dwh.etl_log;

create table dwh.etl_log
(log_id bigserial,
 module_id integer,
 log_value varchar(100),
 log_date timestamp default current_timestamp);

ALTER TABLE dwh.etl_log ADD CONSTRAINT etl_log_pk PRIMARY KEY (log_id);
ALTER TABLE dwh.etl_log ADD CONSTRAINT etl_log_etl_modules_fk FOREIGN KEY (module_id) REFERENCES dwh.etl_modules(module_id);
 
insert into dwh.etl_log (module_id,log_value)
values ();

--delete from dwh.etl_log where module_id=4;

--Лог за сегодня
select m.module_name, l.log_value, log_date
	from dwh.etl_log l
		inner join dwh.etl_modules m
			on m.module_id=l.module_id
	where log_date >= current_date
order by log_date desc, log_id desc;

--Лог последнего запуска общего ETL
select m.module_name, l.log_value, log_date
	from dwh.etl_log l
		inner join dwh.etl_modules m
			on m.module_id=l.module_id
	where log_date >= (select max(log_date) from dwh.etl_log where module_id=2)
order by log_date desc, log_id desc;