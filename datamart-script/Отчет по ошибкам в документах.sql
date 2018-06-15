--Заказы без упд
--sqlOrdCountWithoutUpd
select
 a.varcompanyname
,count(1) orders_count
    from dwh.bi_orders_dm_clean_molvest dm
    	left join dwh.bi_upd_dm_molvest upd
			on dm.ord_number=upd.upd_order_number
		   and (dm.ord_date=upd.upd_order_date
		   	or upd.upd_order_date is null)
		   and dm.ord_buyer_gln=upd.upd_recipient_gln
		   and dm.ord_supplier_gln=upd.upd_sender_gln
		left join dwh.stg_gln gln
    		on gln.vargln=dm.ord_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where 1=1
			and ord_date between ${parDtFrom} and ${parDtTo}
			and dm.ord_status = 'Заказ подтвержден'
			and dm.ord_delivery_status <> 'Не доставлен'
			and upd.upd_order_number  is null
group by 1
order by 2;

--sqlOrdSummWithoutUpd
select
 a.varcompanyname
,round(sum(ord_amount_order_calc),2)/1000 ord_amount_req_calc
    from dwh.bi_orders_dm_clean_molvest dm
        left join dwh.bi_upd_dm_molvest upd
			on dm.ord_number=upd.upd_order_number
		   and (dm.ord_date=upd.upd_order_date
		   	or upd.upd_order_date is null)
		   and dm.ord_buyer_gln=upd.upd_recipient_gln
		   and dm.ord_supplier_gln=upd.upd_sender_gln
		left join dwh.stg_gln gln
    		on gln.vargln=dm.ord_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where 1=1
			and dm.ord_date between ${parDtFrom} and ${parDtTo}
			and dm.ord_status = 'Заказ подтвержден'
			and dm.ord_delivery_status <> 'Не доставлен'
			and upd.upd_order_number  is null
group by 1
order by 2;

--Детализация по выполненным заказам без УПД
--sqlOrdWithoutUpd
select
 dm.region_name
,a.varcompanyname
,ord_number
,ord_date
,round(sum(ord_amount_order_calc),2)/1000 ord_amount_req_calc
,count(1) orders_count
    from dwh.bi_orders_dm_clean_molvest dm
    	left join dwh.bi_upd_dm_molvest upd
			on dm.ord_number=upd.upd_order_number
		   and (dm.ord_date=upd.upd_order_date
		   	or upd.upd_order_date is null)
		   and dm.ord_buyer_gln=upd.upd_recipient_gln
		   and dm.ord_supplier_gln=upd.upd_sender_gln
		left join dwh.stg_gln gln
    		on gln.vargln=dm.ord_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where 1=1
			and ord_date between ${parDateFrom} and ${parDateTo}
			and dm.ord_status = 'Заказ подтвержден'
			and dm.ord_delivery_status <> 'Не доставлен'
			and upd.upd_order_number  is null
group by 1,2,3,4
order by 4,3;

--Список покупателей
--sqlOrdWithoutUpdBuyerList
select
a.varcompanyname
    from dwh.bi_orders_dm_clean_molvest dm
    	left join dwh.bi_upd_dm_molvest upd
			on dm.ord_number=upd.upd_order_number
		   and (dm.ord_date=upd.upd_order_date
		   	or upd.upd_order_date is null)
		   and dm.ord_buyer_gln=upd.upd_recipient_gln
		   and dm.ord_supplier_gln=upd.upd_sender_gln
		left join dwh.stg_gln gln
    		on gln.vargln=dm.ord_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where 1=1
			and ord_date between ${parDateFrom} and ${parDateTo}
			and dm.ord_status = 'Заказ подтвержден'
			and dm.ord_delivery_status <> 'Не доставлен'
			and upd.upd_order_number  is null
group by 1
order by 1;

--Детализация по цепочке заказов
--sqlOrdChainErrors
select distinct
 ord_number
,ord_date
,ord_deliv_place
,ord_amount_order_calc
,ord_amount_recadv_calc
,ord_status
,ord_delivery_status
	from dwh.bi_orders_dm_clean_molvest
		where (ord_amount_order_calc = 0
			or ord_amount_recadv_calc = 0)
		and ord_date between ${parDateFrom} and ${parDateTo};
	
--Детализация по УПД c ошибками
--sqlUpdErrors
select
 upd_number
,upd_date
,upd_type
,upd_file_create_timestamp
,upd_order_number
,upd_order_date
,upd_amount_no_vat
,a.varcompanyname recepient
    from dwh.bi_upd_clean_molvest upd
    	left join dwh.stg_gln gln
    		on gln.vargln=upd.upd_recipient_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where (upd_order_number is null
			or upd_recipient_gln is null
			or upd_sender_gln is null
			or upd_amount_no_vat = 0
			or upd_amount_with_vat = 0)
            and upd_date between ${parDateFrom} and ${parDateTo};	

--УПД без заказа (Таких нет)
--sqlUpdWithoutOrd
--select
-- a.varcompanyname
--,count(1) orders_count
--    from dwh.bi_upd_dm_molvest upd
--    	left join dwh.bi_orders_dm_clean_molvest dm
--			on dm.ord_number=upd.upd_order_number
--		   and (dm.ord_date=upd.upd_order_date
--		   	or upd.upd_order_date is null)
--		   and dm.ord_buyer_gln=upd.upd_recipient_gln
--		   and dm.ord_supplier_gln=upd.upd_sender_gln
--		left join dwh.stg_gln gln
--    		on gln.vargln=dm.ord_buyer_gln
--    	left join dwh.stg_account a
--    		on a.intaccountid=gln.intaccountid
--		where 1=1
--			and ord_date between ${parDtFrom} and ${parDtTo}
--			and dm.ord_status = 'Заказ подтвержден'
--			and dm.ord_delivery_status <> 'Не доставлен'
--			and dm.ord_number is null
--group by 1
--order by 2;

--recadv без order
--sqlRecadvWithoutOrd
select
 a.varcompanyname
,count(1) cnt
	from dwh.bi_recadv_clean_x5_molvest rec
		left join dwh.bi_order_clean_x5_molvest ord
			on ord.ord_number=rec.recadv_ord_number
			and ord.ord_date=rec.recadv_ord_date
			and ord.ord_supplier_gln=rec.recadv_supplier_gln
			and ord.ord_buyer_gln=rec.recadv_buyer_gln
		left join dwh.stg_gln gln
    		on gln.vargln=rec.recadv_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where ord.ord_number is null
			and recadv_ord_date between ${parDtFrom} and ${parDtTo}
group by 1
order by 1;

--Детализация recadv без order
--sqlRecadvWithoutOrder
select
 rec.recadv_ord_number
,rec.recadv_ord_date
,recadv_reception_date
,ord_amount_recadv_calc
,a.varcompanyname
	from dwh.bi_recadv_clean_x5_molvest rec
		left join dwh.bi_order_clean_x5_molvest ord
			on ord.ord_number=rec.recadv_ord_number
			and ord.ord_date=rec.recadv_ord_date
			and ord.ord_supplier_gln=rec.recadv_supplier_gln
			and ord.ord_buyer_gln=rec.recadv_buyer_gln
		left join dwh.stg_gln gln
    		on gln.vargln=rec.recadv_buyer_gln
    	left join dwh.stg_account a
    		on a.intaccountid=gln.intaccountid
		where ord.ord_number is null
			and recadv_ord_date between ${parDateFrom} and ${parDateTo};