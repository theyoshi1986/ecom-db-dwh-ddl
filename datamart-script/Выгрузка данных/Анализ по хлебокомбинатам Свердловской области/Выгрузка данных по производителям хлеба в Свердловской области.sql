--Структура csv файла
 ord_buyer_gln
,ord_supplier_gln
,supplier_acc_name
,varname
,supplier_city
,region_name
,pos_product_num
,pos_description
,group_name
,pos_amount_order_calc
,pos_orderedquantity
,pos_weight_kg

--Выгрузка для отчета
--select count(*)
select okvd_name, okvd_code, count(1) cnt
--select 
-- ord_buyer_gln
--,ord_supplier_gln
--,supplier_name supplier_acc_name
--,varname
--,supplier_city
--,region_name
--,iw.pos_product_num
--,iw.pos_description
--,group_name
--,pos_amount_order_calc
--,pos_orderedquantity
--,pos_weight_kg
--,okvd.okvd_code
--,okvd.okvd_name
	from dwh.bi_order_position_dm_clean_bread ord
		inner join dwh.del_me_sq_items_weight iw
			on iw.pos_product_num=ord.pos_product_num
		inner join dwh.stg_item_group_bread ig
			on ig.id_group=iw.id_group_item
		inner join dwh.stg_gln gln
			on gln.vargln=ord.ord_supplier_gln
		inner join dwh.stg_okvd_gln_inn okvd
			on okvd.gln=ord_supplier_gln
		where region_name='Свердловская обл.'
group by 1,2;

--Реестр наших клиентов в разрезе ОКВЭД
select okvd.okvd_name, c.region_name, gln.vargln, varname gln_name, a.varcompanyname account_name, count(1)
	from dwh.stg_gln gln
		inner join dwh.stg_okvd_gln_inn okvd
			on okvd.gln=gln.vargln
		left join dwh.dim_city c
			on c.city_name=gln.varcityregexp
		left join dwh.stg_account a
			on a.intaccountid=gln.intaccountid
group by 1,2,3,4,5
order by 1;
		