--drop table stg_gln;
--truncate table stg_gln;

create table dwh.stg_gln
(intGlnID bigint,
 varGln bigint,
 varName varchar(100),
 varStreet varchar(100),
 varCity varchar(50),
 varcityRegexp varchar(50),
 intAccountID integer,
 intRetailerID integer,
 geodata_id bigint
);

create index stg_gln_idx1 on dwh.stg_gln (intGlnID);
create index stg_gln_idx2 on dwh.stg_gln (varGln);

analyze verbose dwh.stg_gln;
	
select * 
	from dwh.stg_gln;

--delete from dwh.stg_gln g
--	where not exists (select intaccountid from dwh.stg_account a where a.intaccountid=g.intaccountid);

--Маскируем сети
update dwh.stg_gln
	set varname = case when varname in ('ООО "Агроторг"') then 'Сеть 1'
	  			       when varname in ('АО Тандер','ООО "КВАРТАЛ"','ООО "Метро Кэш энд Керри", 1342') then 'Сеть 2'
	  			       else 'Сеть 3' end
		where varname in (select buyer_name
								from dwh.bi_orders_dm dm
							group by buyer_name)
			or varname in ('АО Тандер','ООО "КВАРТАЛ"','ООО "Метро Кэш энд Керри", 1342');
							
--Маскируем поставщиков
update dwh.stg_gln
	set varname = 'Поставщик '||width_bucket(vargln,1,9999999999999,10)
		where varname not in ('Сеть 1','Сеть 2','Сеть 3');



update stg_gln
	set varcityregexp = 'Москва' where varcityregexp='Ородской Округ Мытищи,Мытищи';
update stg_gln
	set varcityregexp = 'Нытва' where varcityregexp='Пермский Край,Нытва';
update stg_gln
	set varcityregexp = 'Мытищи' where varcityregexp='Мытищи, Олимпийский Проспект, Вл. 29';
update stg_gln
	set varcityregexp = 'Москва' where varcityregexp='Пос.шишкин Лес';
update stg_gln
	set varcityregexp = 'Москва' where varcityregexp='#';
