create table bi_orders_dm_supplier_bck20180416
as
select *
	from bi_orders_dm_supplier;

--drop table bi_orders_dm_supplier;
--create table bi_orders_dm_supplier
--as
--select *
--	from bi_orders_dm_supplier_bck20180416;

select *
	from bi_orders_dm_supplier
		where lower(buyer_name) like '%кораб%';
		
update bi_orders_dm_supplier
	set orders_count=orders_count*20
	   ,orders_with_recadv_count=orders_with_recadv_count*20
	   ,orders_with_ordrsp_count=orders_with_ordrsp_count*20
	   ,ord_amount_desadv_calc=ord_amount_desadv_calc*20
	   ,ord_amount_ordrsp_calc=ord_amount_ordrsp_calc*20
	   ,ord_amount_recadv_calc=ord_amount_recadv_calc*20
	   ,ord_amount_req_calc=ord_amount_req_calc*20
		where lower(buyer_name) like '%ашан%';

update bi_orders_dm_supplier
	set orders_count=orders_count*20
	   ,orders_with_recadv_count=orders_with_recadv_count*20
	   ,orders_with_ordrsp_count=orders_with_ordrsp_count*20
	   ,ord_amount_desadv_calc=ord_amount_desadv_calc*20
	   ,ord_amount_ordrsp_calc=ord_amount_ordrsp_calc*20
	   ,ord_amount_recadv_calc=ord_amount_recadv_calc*20
	   ,ord_amount_req_calc=ord_amount_req_calc*20
		where lower(buyer_name) like '%лента%';


update bi_orders_dm_supplier
	set orders_count=orders_count*200
	   ,orders_with_recadv_count=orders_with_recadv_count*200
	   ,orders_with_ordrsp_count=orders_with_ordrsp_count*200
	   ,ord_amount_desadv_calc=ord_amount_desadv_calc*200
	   ,ord_amount_ordrsp_calc=ord_amount_ordrsp_calc*200
	   ,ord_amount_recadv_calc=ord_amount_recadv_calc*200
	   ,ord_amount_req_calc=ord_amount_req_calc*200
		where lower(buyer_name) like '%контур%';