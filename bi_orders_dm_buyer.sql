--Данные по всем поставщикам Торговый дом "ПЕРЕКРЕСТОК
--drop table dwh.bi_orders_dm_buyer;
create table dwh.bi_orders_dm_buyer
as
/*bi_orders_dm_bck20180416 + все заказы Торговый дом "ПЕРЕКРЕСТОК*/
select *
	from bi_orders_dm
		where supplier_name in ('Молвест','ТД Айсберри','Самарский хлебозавод №5','СМАК','Карат Плюс','Компания "Хлебный Дом','Гуковская М.Ю.','ХЛЕБ','ТОРГОВАЯ КОМПАНИЯ','Каравай','Княгининское молоко','Зеленодольский хлебокомбинат')
except
select * from dwh.bi_orders_dm_bck20180416 /*Все сети поставщика Маслозавод Нытвенский*/;

create index bi_orders_dm_buyer_idx1 on dwh.bi_orders_dm_buyer (ord_date);

analyze verbose bi_orders_dm_buyer;

update dwh.bi_orders_dm_buyer
	set supplier_city = 'Княгинино'
		where supplier_name = 'Княгининское молоко'
		and supplier_city = 'Нижегородская Обл., Княгининский Р-Н,Княгинино';

update dwh.bi_orders_dm_buyer
	set supplier_city = 'Нижний Новгород'
		where supplier_name = 'Каравай'
		and supplier_city = 'Н.новгород';