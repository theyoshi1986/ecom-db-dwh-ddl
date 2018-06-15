create table dwh.dim_doctype
(doctype_id int,
 doctype_code varchar(10),
 doctype_name varchar(100));

comment on table dwh.dim_doctype is 'Справочник типов документов';
 
insert into dwh.dim_doctype values (1,'O','Оригинал');
insert into dwh.dim_doctype values (2,'R','Замена');
insert into dwh.dim_doctype values (3,'D','Удаление');
commit;

select *
	from dwh.dim_doctype;