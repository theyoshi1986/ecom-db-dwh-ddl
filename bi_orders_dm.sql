create table dwh.bi_orders_dm (
	ord_amount_chk text null,
	ord_delivery_status text null,
	ord_status text null,
	pos_status text null,
	ord_date date null,
	supplier_name varchar(100) null,
	supplier_city varchar(100) null,
	buyer_name varchar(100) null,
	buyer_city varchar(100) null,
	orders_count int8 null,
	orders_with_ordrsp_count int8 null,
	orders_with_desadv_count int8 null,
	orders_with_recadv_count int8 null,
	ord_amount_req_calc numeric null,
	ord_amount_ordrsp_calc numeric null,
	ord_amount_desadv_calc numeric null,
	ord_amount_recadv_calc numeric null,
	ordrsp_shortage_amount numeric null,
	desadv_shortage_amount numeric null,
	recadv_shortage_amount numeric null,
	desadv_order_delivery_delay_avg numeric null,
	recadv_order_delivery_delay_avg numeric null,
	order_reaction_interval_avg numeric null
);

alter table dwh.bi_orders_dm rename to bi_orders_dm_bck20180404;

select * from dwh.bi_orders_dm;

--Маскируем сети
update dwh.bi_orders_dm
	set buyer_name = case when buyer_name in ('ООО "Агроторг"') then 'Сеть 1'
	  			       when buyer_name in ('АО Тандер','ООО "КВАРТАЛ"','ООО "Метро Кэш энд Керри", 1342') then 'Сеть 2'
	  			       else 'Сеть 3' END;
	  			      
--Маскируем поставщиков
--300k
select count(1) from dwh.bi_orders_dm;

create table dwh.bi_orders_dm_tmp
as
select dm.*, row_number() over () rnk
	from dwh.bi_orders_dm dm;

update dwh.bi_orders_dm_tmp
	set supplier_name = 'Поставщик '||width_bucket(rnk,1,300000,9);

alter table dwh.bi_orders_dm rename to bi_orders_dm_del_me;
alter table dwh.bi_orders_dm_tmp rename to bi_orders_dm;

drop table dwh.bi_orders_dm_del_me;

--Регион поставщика
update dwh.bi_orders_dm
	set supplier_city = case	
							when width_bucket(rnk,1,300000,3) = 1 then 'Москва'
							when width_bucket(rnk,1,300000,3) = 2 then 'Белгород'
							when width_bucket(rnk,1,300000,3) = 3 then 'Партизанское'
						end;
						
--Нормализуем данные по задержке
create table dwh.bi_orders_dm_bck20180328
as
select dm.*
	from dwh.bi_orders_dm dm;
	
update dwh.bi_orders_dm
	set recadv_order_delivery_delay_avg = width_bucket(rnk,1,300000,5)
		where ord_delivery_status='Доставлен c опозданием';

update dwh.bi_orders_dm
	set recadv_order_delivery_delay_avg = width_bucket(rnk,1,300000,3)
		where ord_delivery_status='Доставлен раньше';
		
update dwh.bi_orders_dm
	set recadv_order_delivery_delay_avg = 0
		where ord_delivery_status='Доставлен в срок'
 			or recadv_order_delivery_delay_avg is null;

--Нормализуем данные по статусу
update dwh.bi_orders_dm
	set ord_delivery_status = case when width_bucket(rnk,1,300000,10) between 1 and 7 then 'Доставлен в срок' else 'Не доставлен' end
		where ord_delivery_status='Не доставлен';

--Нормализуем данные по реации на заказ
update dwh.bi_orders_dm
	set order_reaction_interval_avg = width_bucket(rnk,0,300000,2);

--Нормализуем данные по соотношению количества документов
update dwh.bi_orders_dm
	set orders_with_recadv_count = orders_with_recadv_count*5
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 4';
update dwh.bi_orders_dm
	set orders_with_recadv_count = orders_with_recadv_count*2
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 2';
update dwh.bi_orders_dm
	set orders_with_desadv_count = orders_with_recadv_count*1.5
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 2';
update dwh.bi_orders_dm
	set orders_with_recadv_count = orders_with_recadv_count*10
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 8';
update dwh.bi_orders_dm
	set orders_with_ordrsp_count = orders_count
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 8';
update dwh.bi_orders_dm
	set orders_with_ordrsp_count = orders_count*0.9
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 3';
update dwh.bi_orders_dm
	set orders_with_recadv_count = orders_count*0.7
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 3';
update dwh.bi_orders_dm
	set orders_with_recadv_count = orders_count*0.7
		,orders_with_ordrsp_count = orders_count*0.9
		,orders_with_desadv_count = orders_count*0.7
	where buyer_name='Сеть 1'
		and supplier_name='Поставщик 6';
		
--Нормализуем данные по недопоставке
update dwh.bi_orders_dm
	set ordrsp_shortage_amount = ordrsp_shortage_amount/100
		,desadv_shortage_amount = desadv_shortage_amount/100
		,recadv_shortage_amount = recadv_shortage_amount/100;

update dwh.bi_orders_dm
	set ordrsp_shortage_amount = ordrsp_shortage_amount/5
		where buyer_name='Сеть 1'
		and supplier_name in ('Поставщик 1','Поставщик 6','Поставщик 3');


update bi_orders_dm
	set buyer_city = 'Москва' where buyer_city='Ородской Округ Мытищи,Мытищи';
update bi_orders_dm
	set supplier_city = 'Нытва' where supplier_city='Пермский Край,Нытва';
update bi_orders_dm
	set supplier_city = 'Мытищи' where supplier_city='Мытищи, Олимпийский Проспект, Вл. 29';
update bi_orders_dm
	set supplier_city = 'Москва' where supplier_city='Пос.шишкин Лес';
update bi_orders_dm
	set supplier_city = 'Москва' where supplier_city='#';
