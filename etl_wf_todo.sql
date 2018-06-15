--drop table dwh.etl_wf_todo;

create table dwh.etl_wf_todo
(todo_id bigserial,
 todo_task_name varchar(100),
 todo_task_value varchar(100),
 audit_cd timestamp default current_timestamp,
 audit_rd timestamp);
 
insert into dwh.etl_wf_todo(todo_task_name,todo_task_value)
select 'jsons_to_load_date' todo_task_name, cast(date_actual as varchar) todo_task_value
	from dwh.dim_date
		where year_actual=2018
			and month_actual in (1);
insert into dwh.etl_wf_todo(todo_task_name,todo_task_value)
select 'bi_orders_dm_to_load_date' todo_task_name, cast(date_actual as varchar) todo_task_value
	from dwh.dim_date
		where year_actual=2018
			and month_actual in (1);

--update dwh.etl_wf_todo
--	set audit_rd = null
--		where todo_task_name='jsons_to_load_date'
--		and audit_cd between current_date and current_date+1;

select * from dwh.etl_wf_todo
	where todo_task_name='bi_orders_dm_to_load_date'
		and audit_rd is null;