create table dwh.dim_ordtype
(ordtype_id int,
 ordtype_code varchar(10),
 ordtype_name varchar(100));

comment on table dwh.dim_ordtype is '���������� ����� �������';
 
insert into dwh.dim_ordtype values (1,'O','��������');
insert into dwh.dim_ordtype values (2,'R','�������������');
insert into dwh.dim_ordtype values (3,'D','������');
commit;