--2 931 574
select count(1)
	from dwh.stg_doc_chain_to_load_x5;

--12 192 509
select count(1)
	from dwh.bi_order_position_clean_x5;

--12 192 509
select count(1)
	from dwh.bi_order_position_uniq_x5;

--375 651
select count(1)
	from dwh.bi_ordrsp_position_uniq_x5;

--569 900
select count(1)
	from dwh.bi_desadv_position_uniq_x5;

--10 079 637
select count(1)
	from dwh.bi_recadv_position_uniq_x5;

select ord_doctype, ord_type, count(1) cnt
	from dwh.bi_order_position_clean_x5
group by 1,2;

select ordrsp_doctype, count(1) cnt
	from dwh.bi_orderrsp_position_trans_x5
group by 1;

select desadv_doctype, count(1) cnt
	from dwh.bi_desadv_position_trans_x5
group by 1;
		
select recadv_doctype, count(1) cnt
	from dwh.bi_recadv_position_trans_x5
group by 1;

select recadv_doctype, recadv_version, count(1) cnt
	from dwh.bi_recadv_position_uniq_x5
group by 1,2;
		
--1
select *
	from dwh.bi_order_position_clean_x5
		where doc_chain_id is null
			or ord_buyer_gln is null
			or ord_supplier_gln is null
			or ord_number is null
			or ord_date is null
			or pos_product_num is null;
			
--0
select * 
	from dwh.bi_ordrsp_position_clean_x5
		where doc_chain_id is null
			or ordrsp_buyer_gln is null
			or ordrsp_supplier_gln is null
			or ordrsp_ord_number is null
			or ordrsp_ord_date is null
			or ordrsp_pos_product_num is null;
			
--661
select * 
	from dwh.bi_desadv_position_trans_x5
		where doc_chain_id is null
			or desadv_buyer_gln is null
			or desadv_supplier_gln is null
			or desadv_ord_number is null
			or desadv_ord_date is null
			or desadv_pos_product_num is null;

--0
select *
	from dwh.bi_recadv_position_trans_x5
		where doc_chain_id is null
			or recadv_buyer_gln is null
			or recadv_supplier_gln is null
			or recadv_ord_number is null
			or recadv_ord_date is null
			or recadv_pos_product_num is null;
			
--Нет цепочек с rsp по doc_chain_id
--313,992
select ordr.doc_chain_id,ord_buyer_gln, ord_supplier_gln, ord_date, ord_number, pos_product_num
,ordrsp.doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_date, ordrsp_ord_number
	from dwh.bi_order_position_clean_x5 ordr	
		inner join dwh.bi_ordrsp_position_clean_x5 ordrsp
--			on ordr.doc_chain_id=ordrsp.doc_chain_id
			on ordr.ord_buyer_gln=ordrsp.ordrsp_buyer_gln
			and ordr.ord_supplier_gln=ordrsp.ordrsp_supplier_gln
			and ordr.ord_date=ordrsp.ordrsp_ord_date
			and ordr.ord_number=ordrsp.ordrsp_ord_number
			and ordr.pos_product_num=ordrsp.ordrsp_pos_product_num;

--90 цепочек по doc_chain_id
--500 036 без doc_chain_id
select count(1) from (
select ordr.doc_chain_id,ord_buyer_gln, ord_supplier_gln, ord_date, ord_number, pos_product_num
,desadv.doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_date, desadv_ord_number
	from dwh.bi_order_position_clean_x5 ordr	
		inner join dwh.bi_desadv_position_clean_x5 desadv
--			on ordr.doc_chain_id=desadv.doc_chain_id
			on ordr.ord_buyer_gln=desadv.desadv_buyer_gln
			and ordr.ord_supplier_gln=desadv.desadv_supplier_gln
			and ordr.ord_date=desadv.desadv_ord_date
			and ordr.ord_number=desadv.desadv_ord_number
			and ordr.pos_product_num=desadv.desadv_pos_product_num) sq;

--10 034 447 по doc_chain_id
select count(1) from (
select ordr.doc_chain_id,ord_buyer_gln, ord_supplier_gln, ord_date, ord_number, pos_product_num
,recadv.doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_date, recadv_ord_number
	from dwh.bi_order_position_clean_x5 ordr	
		inner join dwh.bi_recadv_position_clean_x5 recadv
			on ordr.doc_chain_id=recadv.doc_chain_id
			and ordr.ord_buyer_gln=recadv.recadv_buyer_gln
			and ordr.ord_supplier_gln=recadv.recadv_supplier_gln
			and ordr.ord_date=recadv.recadv_ord_date
			and ordr.ord_number=recadv.recadv_ord_number
			and ordr.pos_product_num=recadv.recadv_pos_product_num) sq;
			
--Анализ витрин по заказам
--1
select * 
	from dwh.bi_order_clean_x5
		where ord_amount_order_calc is null 
		or ord_amount_order_calc <0
		or ord_date is null;
		
--10k
select * 
	from dwh.bi_ordrsp_clean_x5
		where ord_amount_ordrsp_calc is null 
		or ord_amount_ordrsp_calc <0
		or ordrsp_ord_date is null;

--проверяем
select doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date
				,ordrsp_action
				,ordrsp_date
				,ordrsp_pos_orderedquantity
				,ordrsp_pos_price_no_vat, ordrsp_pos_price_with_vat, ordrsp_pos_vat, ordrsp_vat
				,case 
					when ordrsp_pos_price_no_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_no_vat		
					when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_pos_vat / 100)
					when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is null and ordrsp_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_vat / 100)
			 	 end ord_amount_ordrsp_calc
				,ordrsp_doctype
			from dwh.bi_ordrsp_position_clean_x5 ord
where doc_chain_id=897260526;

--6052
select * 
	from bi_desadv_clean_x5
		where ord_amount_desadv_calc is null
			or ord_amount_desadv_calc < 0;

--Проверяем
select doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date, desadv_pos_product_num
				,desadv_delivery_date
				,case
					when desadv_pos_amount_no_vat is not null
						then desadv_pos_amount_no_vat
					when desadv_pos_amount_no_vat is null and desadv_pos_amount_with_vat is not null and desadv_pos_vat is not null
						then desadv_pos_amount_with_vat / (1 + desadv_pos_vat / 100)
					when desadv_pos_price_no_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity * desadv_pos_price_no_vat		
					when desadv_pos_price_no_vat is null and desadv_pos_price_with_vat is not null and desadv_pos_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity / (1 + desadv_pos_vat/100)
			 	 end ord_amount_desadv_calc
				,desadv_pos_orderedquantity, desadv_pos_deliveredquantity
				,desadv_pos_amount_no_vat, desadv_pos_amount_with_vat, desadv_pos_price_no_vat, desadv_pos_price_with_vat, desadv_pos_vat
				,desadv_doctype
			from dwh.bi_desadv_position_clean_x5 ord
	where doc_chain_id = 897239876;				
	
--0
select *
	from bi_recadv_clean_x5
		where ord_amount_recadv_calc is null
			or ord_amount_recadv_calc < 0;
			
--509
select ord.doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_date, ord_number, count(*)
	from dwh.bi_order_clean_x5 ord --1 572 416
		left join dwh.bi_ordrsp_clean_x5 rsp
			on rsp.ordrsp_buyer_gln=ord.ord_buyer_gln
			and rsp.ordrsp_supplier_gln=ord.ord_supplier_gln
			and rsp.ordrsp_ord_date=ord.ord_date
			and rsp.ordrsp_ord_number=ord.ord_number		
group by 1,2,3,4,5
having count(1)>1;

select *
	from dwh.bi_order_clean_x5
		where ord_buyer_gln=4606038001260
			and ord_supplier_gln=4607145599992
			and ord_date = '2017-12-28'
			and ord_number = '5781780938';
			
select *
	from dwh.bi_order_position_clean_x5
		where ord_buyer_gln=4606038001260
			and ord_supplier_gln=4607145599992
			and ord_date = '2017-12-28'
			and ord_number = '5781780938';
			
--0
select count(*)
	from dwh.bi_order_clean_x5 o
		where not exists (select *
							from dwh.bi_order_position_clean_x5 p
								where p.ord_buyer_gln = o.ord_buyer_gln
									and p.ord_supplier_gln = o.ord_supplier_gln
									and p.ord_date = o.ord_date
									and p.ord_number = o.ord_number);

--0
select count(*)
	from dwh.bi_orders_dm_clean o
		where not exists (select *
							from dwh.bi_order_position_dm_clean p
								where p.ord_buyer_gln = o.ord_buyer_gln
									and p.ord_supplier_gln = o.ord_supplier_gln
									and p.ord_date = o.ord_date
									and p.ord_number = o.ord_number);

