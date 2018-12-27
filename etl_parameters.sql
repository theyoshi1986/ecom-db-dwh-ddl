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
--	values (1, 'json_date_load_counter', 0, '������� ������ �������� ���������� � stage ����');
--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (2, 'json_loaded_date', '2018-01-01', '���� (������������) �� ������� ��������� ������� ���������� ������� � ��������� order');
--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (3, 'last_loaded_intChainID', '274680426', '������������� ��������� ����������� ������� ����������, ��� �������� ���������� �� evolution');
--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (4, 'last_loaded_intDocID', '2269565205', '������������� ���������� ������������ ���������, ��� �������� ���������� �� evolution');
--insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
--	values (5, 'last_loaded_date_molvest', '2018-09-17', '���� ��������� �������� �������� ������ ��� �������� ���������� �� evolution');
insert into dwh.etl_parameters (id, param_name, param_val, param_descr) 
	values (6, 'last_loaded_date_billing', '2018-01-01 00:00:00', '���� ��������� ����������� ���������� �� ������� �� evolution');
commit;

select * from etl_parameters;