--drop table dwh.bi_order_position_uniq_bread;
create table dwh.bi_order_position_uniq_bread
as
select *
	from (
			select doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date, pos_product_num
				,pos_description
				,(ord_delivery_date||' '||coalesce(ord_delivery_time,'00:00'))::timestamp ord_delivery_date, ord_latest_delivery_date
				,ord_deliv_place
				,pos_orderedquantity
				,case
					when pos_unit_name = 'PK' then 'NMP'
					when pos_unit_name in ('PR','RO') then 'PCE'
					when pos_unit_name is null then 'PCE'
					else pos_unit_name
				 end pos_unit_name
				,pos_price_no_vat, pos_price_with_vat, pos_vat, ord_vat
				,case
					when ord_doctype is null then 'O'
					when ord_doctype = '9' then 'O'
					when ord_doctype in ('O','R','D') then ord_doctype
					else 'X'
				 end ord_doctype
				,case 
					when ord_type is null then 'O'
					when ord_type = 'CORRECTION' then 'R'
					when ord_type in ('ORIGINAL','1','0') then 'O'
					when ord_type in ('O','R','D','RETORD') then ord_type
					else 'X'
				 end ord_type
				,coalesce(ord_version,0) ord_version
				--Р С™Р С•РЎР‚РЎР‚Р ВµР С”РЎвЂљР С‘РЎР‚Р С•Р Р†Р С”Р В° Р С‘Р Т‘Р ВµРЎвЂљ Р Р…Р Вµ Р С—Р С• Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏР С�, Р В° Р С—Р С• Р Р†РЎРѓР ВµР С�РЎС“ Р В·Р В°Р С”Р В°Р В·РЎС“, Р С—Р С•РЎРЊРЎвЂљР С•Р С�РЎС“ Р Р…Р В°Р Т‘Р С• Р Р†РЎвЂ№РЎвЂЎР С‘Р В»РЎРЏРЎвЂљРЎРЉ Р ВµРЎвЂ� Р С‘Р Р…Р В°РЎвЂЎР Вµ, Р С‘Р Р…Р В°РЎвЂЎР Вµ Р С•РЎв‚¬Р С‘Р В±Р С”Р С‘ Р Р† Р В·Р В°Р С”Р В°Р В·Р В°РЎвЂ¦ Р С–Р Т‘Р Вµ Р В±РЎвЂ№Р В»Р В° Р В·Р В°Р С�Р ВµР Р…Р В° Р С—Р С•Р В·Р С‘РЎвЂ Р С‘Р С‘
				,row_number() over (partition by doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date, pos_product_num order by coalesce(ord_version,0), ord_doctype, ord_type desc) rn
				from dwh.bi_order_position_trans_bread ord
					where ord_buyer_gln is not null
						and ord_supplier_gln is not null
						and ord_number is not null
						and ord_date is not null
						and pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

--drop table dwh.bi_ordrsp_position_uniq_bread;
create table dwh.bi_ordrsp_position_uniq_bread
as
select *
	from (
			select doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date, ordrsp_pos_product_num
--				,ordrsp_pos_number, ordrsp_pos_description
				,ordrsp_pos_product_type --1 Р В±Р ВµР В· Р С‘Р В·Р С�, 2-Р С‘Р В·Р С� Р С”Р С•Р В»-Р Р†Р В°, 3-Р С•РЎвЂљР С”Р В°Р В·
				,coalesce(ordrsp_action,29) ordrsp_action
				,ordrsp_date
				,ordrsp_pos_orderedquantity
				,ordrsp_pos_price_no_vat, ordrsp_pos_price_with_vat, ordrsp_pos_vat, ordrsp_vat
				,case
					when ordrsp_doctype is null then 'O'
					when ordrsp_doctype = '9' then 'O'
					when ordrsp_doctype in ('O','R','D') then ordrsp_doctype
					else 'X'
				 end ordrsp_doctype
				,coalesce(ordrsp_version,0) ordrsp_version
				--Р С™Р С•РЎР‚РЎР‚Р ВµР С”РЎвЂљР С‘РЎР‚Р С•Р Р†Р С”Р В° Р С‘Р Т‘Р ВµРЎвЂљ Р Р…Р Вµ Р С—Р С• Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏР С�, Р В° Р С—Р С• Р Р†РЎРѓР ВµР С�РЎС“ Р В·Р В°Р С”Р В°Р В·РЎС“, Р С—Р С•РЎРЊРЎвЂљР С•Р С�РЎС“ Р Р…Р В°Р Т‘Р С• Р Р†РЎвЂ№РЎвЂЎР С‘Р В»РЎРЏРЎвЂљРЎРЉ Р ВµРЎвЂ� Р С‘Р Р…Р В°РЎвЂЎР Вµ, Р С‘Р Р…Р В°РЎвЂЎР Вµ Р С•РЎв‚¬Р С‘Р В±Р С”Р С‘ Р Р† Р В·Р В°Р С”Р В°Р В·Р В°РЎвЂ¦ Р С–Р Т‘Р Вµ Р В±РЎвЂ№Р В»Р В° Р В·Р В°Р С�Р ВµР Р…Р В° Р С—Р С•Р В·Р С‘РЎвЂ Р С‘Р С‘
				,row_number() over (partition by doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date, ordrsp_pos_product_num order by coalesce(ordrsp_version,0), ordrsp_doctype desc) rn
				from dwh.bi_orderrsp_position_trans_bread ord
					where doc_chain_id is not null
						and ordrsp_buyer_gln is not null
						and ordrsp_supplier_gln is not null
						and ordrsp_ord_number is not null
						and ordrsp_ord_date is not null
						and ordrsp_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

--drop table dwh.bi_desadv_position_uniq_bread;
create table dwh.bi_desadv_position_uniq_bread
as
select *
	from (
			select doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date, desadv_pos_product_num
--				,desadv_pos_number, desadv_pos_description
--				,(desadv_delivery_date||' '||coalesce(desadv_delivery_time,'00:00'))::timestamp desadv_delivery_date --РЎвЂ¦РЎР‚Р ВµР Р…Р С•Р Р†РЎвЂ№Р Вµ Р Т‘Р В°Р Р…Р Р…РЎвЂ№Р Вµ Р Р† desadv_delivery_time, Р Р…Р В°Р Т‘Р С• РЎвЂЎР С‘РЎРѓРЎвЂљР С‘РЎвЂљРЎРЉ
				,desadv_delivery_date
				,desadv_pos_orderedquantity, desadv_pos_deliveredquantity
				,desadv_pos_amount_no_vat, desadv_pos_amount_with_vat, desadv_pos_price_no_vat, desadv_pos_price_with_vat, desadv_pos_vat
				,case
					when desadv_doctype is null then 'O'
					when desadv_doctype in ('O','R','D') then desadv_doctype
					else 'X'
				 end desadv_doctype
				,coalesce(desadv_version,0) desadv_version
				--Р С™Р С•РЎР‚РЎР‚Р ВµР С”РЎвЂљР С‘РЎР‚Р С•Р Р†Р С”Р В° Р С‘Р Т‘Р ВµРЎвЂљ Р Р…Р Вµ Р С—Р С• Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏР С�, Р В° Р С—Р С• Р Р†РЎРѓР ВµР С�РЎС“ Р В·Р В°Р С”Р В°Р В·РЎС“, Р С—Р С•РЎРЊРЎвЂљР С•Р С�РЎС“ Р Р…Р В°Р Т‘Р С• Р Р†РЎвЂ№РЎвЂЎР С‘Р В»РЎРЏРЎвЂљРЎРЉ Р ВµРЎвЂ� Р С‘Р Р…Р В°РЎвЂЎР Вµ, Р С‘Р Р…Р В°РЎвЂЎР Вµ Р С•РЎв‚¬Р С‘Р В±Р С”Р С‘ Р Р† Р В·Р В°Р С”Р В°Р В·Р В°РЎвЂ¦ Р С–Р Т‘Р Вµ Р В±РЎвЂ№Р В»Р В° Р В·Р В°Р С�Р ВµР Р…Р В° Р С—Р С•Р В·Р С‘РЎвЂ Р С‘Р С‘
			,row_number() over (partition by doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date, desadv_pos_product_num order by coalesce(desadv_version,0), desadv_doctype desc) rn
				from dwh.bi_desadv_position_trans_bread ord
					where doc_chain_id is not null
					and desadv_buyer_gln is not null
					and desadv_supplier_gln is not null
					and desadv_ord_number is not null
					and desadv_ord_date is not null
					and desadv_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

--drop table dwh.bi_recadv_position_uniq_bread;
create table dwh.bi_recadv_position_uniq_bread
as
select *
	from (
			select doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date, recadv_pos_product_num
--				,recadv_pos_number, recadv_pos_description
				,recadv_reception_date
				,recadv_pos_orderedquantity, recadv_pos_acceptedquantity, recadv_pos_deliveredquantity, recadv_pos_deltaquantity
				,recadv_pos_price_no_vat, recadv_pos_price_with_vat, recadv_pos_vat, recadv_pos_amount_no_vat, recadv_pos_amount_with_vat
				,case
					when recadv_doctype is null then 'O'
					when recadv_doctype in ('O','R','D') then recadv_doctype
					else 'X'
				 end recadv_doctype
				,coalesce(recadv_version,0) recadv_version
				--Р С™Р С•РЎР‚РЎР‚Р ВµР С”РЎвЂљР С‘РЎР‚Р С•Р Р†Р С”Р В° Р С‘Р Т‘Р ВµРЎвЂљ Р Р…Р Вµ Р С—Р С• Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏР С�, Р В° Р С—Р С• Р Р†РЎРѓР ВµР С�РЎС“ Р В·Р В°Р С”Р В°Р В·РЎС“, Р С—Р С•РЎРЊРЎвЂљР С•Р С�РЎС“ Р Р…Р В°Р Т‘Р С• Р Р†РЎвЂ№РЎвЂЎР С‘Р В»РЎРЏРЎвЂљРЎРЉ Р ВµРЎвЂ� Р С‘Р Р…Р В°РЎвЂЎР Вµ, Р С‘Р Р…Р В°РЎвЂЎР Вµ Р С•РЎв‚¬Р С‘Р В±Р С”Р С‘ Р Р† Р В·Р В°Р С”Р В°Р В·Р В°РЎвЂ¦ Р С–Р Т‘Р Вµ Р В±РЎвЂ№Р В»Р В° Р В·Р В°Р С�Р ВµР Р…Р В° Р С—Р С•Р В·Р С‘РЎвЂ Р С‘Р С‘
			,row_number() over (partition by doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date, recadv_pos_product_num order by coalesce(recadv_version,0), recadv_doctype desc) rn
				from dwh.bi_recadv_position_trans_bread ord
					where doc_chain_id is not null
					and recadv_buyer_gln is not null
					and recadv_supplier_gln is not null
					and recadv_ord_number is not null
					and recadv_ord_date is not null
					and recadv_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

create index bi_order_position_uniq_bread_idx1 on dwh.bi_order_position_uniq_bread (ord_date);
create index bi_order_position_uniq_bread_idx2 on dwh.bi_order_position_uniq_bread (doc_chain_id);
create index bi_order_position_uniq_bread_idx3 on dwh.bi_order_position_uniq_bread (ord_number,ord_date,ord_supplier_gln,ord_buyer_gln,ord_doctype);
create index bi_ordrsp_position_uniq_bread_idx1 on dwh.bi_ordrsp_position_uniq_bread (doc_chain_id);
create index bi_desadv_position_uniq_bread_idx1 on dwh.bi_desadv_position_uniq_bread (doc_chain_id);
create index bi_recadv_position_uniq_bread_idx1 on dwh.bi_recadv_position_uniq_bread (doc_chain_id);

analyze verbose dwh.bi_order_position_uniq_bread;
analyze verbose dwh.bi_ordrsp_position_uniq_bread;
analyze verbose dwh.bi_desadv_position_uniq_bread;
analyze verbose dwh.bi_recadv_position_uniq_bread;

--Р вЂ”Р В°Р С–РЎР‚РЎС“Р В·Р С”Р В° Р С•РЎвЂЎР С‘РЎвЂ°Р ВµР Р…Р Р…РЎвЂ№РЎвЂ¦ Р Т‘Р С•Р С”РЎС“Р С�Р ВµР Р…РЎвЂљР С•Р Р†
--drop table dwh.bi_order_position_clean_bread;
create table dwh.bi_order_position_clean_bread
as
select *
	from dwh.bi_order_position_uniq_bread
		where ord_doctype in ('O','R')
		and ord_type in ('O','R');

create index bi_order_position_clean_bread_idx1 on dwh.bi_order_position_clean_bread (doc_chain_id);
create index bi_order_position_clean_bread_idx2 on dwh.bi_order_position_clean_bread (ord_number);
analyze verbose dwh.bi_order_position_clean_bread;

--Р Р€Р В±Р С‘РЎР‚Р В°Р ВµР С� Р С•РЎвЂљР С�Р ВµР Р…РЎвЂ№ Р С‘ Р Р†Р С•Р В·Р Р†РЎР‚Р В°РЎвЂљРЎвЂ№ (Р С›Р Р…Р С‘ РЎС“Р В±Р С‘РЎР‚Р В°РЎР‹РЎвЂљРЎРѓРЎРЏ Р В°Р Р†РЎвЂљР С•Р С�Р В°РЎвЂљР С•Р С�, Р Р†Р С•Р В·Р Р†РЎР‚Р В°РЎвЂљ Р С‘Р С�Р ВµР ВµРЎвЂљ Р Р…Р С•Р Р†РЎС“РЎР‹ Р Р†Р ВµРЎР‚РЎРѓР С‘РЎР‹, Р С—Р С•РЎРЊРЎвЂљР С•Р С�РЎС“ РЎвЂћР С‘Р В»РЎРЉРЎвЂљРЎР‚РЎС“Р ВµРЎвЂљРЎРѓРЎРЏ Р С—Р С• rn=1 Р С‘ ord_doctype in ('O','R'))
--alter table dwh.bi_order_position_uniq_bread add del_mrk varchar(1);
--delete from dwh.bi_order_position_clean_bread o1
--update dwh.bi_order_position_uniq_bread o1
--	set del_mrk = 'y'
--	where exists (select 1
--					from dwh.bi_order_position_uniq_bread o2
--						where o2.ord_doctype in ('D','RETORD')
--						and o2.ord_buyer_gln=o1.ord_buyer_gln
--						and o2.ord_supplier_gln=o1.ord_supplier_gln
--						and o2.ord_number=o1.ord_number
--						and o2.ord_date=o1.ord_date);

--analyze verbose dwh.bi_order_position_clean_bread;

--drop table dwh.bi_ordrsp_position_clean_bread;
create table dwh.bi_ordrsp_position_clean_bread
as
select *
	from dwh.bi_ordrsp_position_uniq_bread
		where ordrsp_doctype in ('O','R');

--Р Р€Р Т‘Р В°Р В»РЎРЏР ВµР С� РЎвЂљР Вµ Р С—Р С•Р В·Р С‘РЎвЂ Р С‘Р С‘, Р С–Р Т‘Р Вµ Р Р…Р ВµР В»РЎРЉР В·РЎРЏ Р С—Р С•РЎРѓРЎвЂЎР С‘РЎвЂљР В°РЎвЂљРЎРЉ РЎРѓРЎвЂљР С•Р С‘Р С�Р С•РЎРѓРЎвЂљРЎРЉ
delete from dwh.bi_ordrsp_position_clean_bread
	where case 
				when ordrsp_pos_price_no_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_no_vat		
				when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_pos_vat / 100)
				when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is null and ordrsp_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_vat / 100)
		 	 end = 0;

create index bi_ordrsp_position_clean_bread_idx1 on dwh.bi_ordrsp_position_clean_bread (doc_chain_id);
create index bi_ordrsp_position_clean_bread_idx2 on dwh.bi_ordrsp_position_clean_bread (ordrsp_buyer_gln,ordrsp_supplier_gln,ordrsp_ord_date,ordrsp_ord_number,ordrsp_pos_product_num);
analyze verbose dwh.bi_ordrsp_position_clean_bread;

--drop table dwh.bi_desadv_position_clean_bread;
create table dwh.bi_desadv_position_clean_bread
as
select *
	from dwh.bi_desadv_position_uniq_bread;

delete from bi_desadv_position_clean_bread
	where case
					when desadv_pos_amount_no_vat is not null
						then desadv_pos_amount_no_vat
					when desadv_pos_amount_no_vat is null and desadv_pos_amount_with_vat is not null and desadv_pos_vat is not null
						then desadv_pos_amount_with_vat / (1 + desadv_pos_vat / 100)
					when desadv_pos_price_no_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity * desadv_pos_price_no_vat		
					when desadv_pos_price_no_vat is null and desadv_pos_price_with_vat is not null and desadv_pos_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity / (1 + desadv_pos_vat/100)
			 	 end is null;

create index bi_desadv_position_clean_bread_idx1 on dwh.bi_desadv_position_clean_bread (doc_chain_id);
create index bi_desadv_position_clean_bread_idx2 on dwh.bi_desadv_position_clean_bread (desadv_buyer_gln,desadv_supplier_gln,desadv_ord_date,desadv_ord_number,desadv_pos_product_num);
analyze verbose dwh.bi_desadv_position_clean_bread;

--drop table dwh.bi_recadv_position_clean_bread;
create table dwh.bi_recadv_position_clean_bread
as
select *
	from dwh.bi_recadv_position_uniq_bread;

create index bi_recadv_position_clean_bread_idx1 on dwh.bi_recadv_position_clean_bread (doc_chain_id);
analyze verbose dwh.bi_recadv_position_clean_bread;

--Р вЂ™Р С‘РЎвЂљРЎР‚Р С‘Р Р…РЎвЂ№ Р В·Р В°Р С”Р В°Р В·Р С•Р Р†
--drop table dwh.bi_order_clean_bread;
create table dwh.bi_order_clean_bread
as
select doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date
		,ord_delivery_date,  ord_latest_delivery_date, ord_deliv_place
		,sum(case 
			when pos_price_no_vat is not null and pos_orderedquantity is not null
				then pos_orderedquantity * pos_price_no_vat		
			when pos_price_no_vat is null and pos_price_with_vat is not null and pos_vat is not null and pos_orderedquantity is not null
				then pos_orderedquantity * pos_price_with_vat / (1 + pos_vat / 100)
			when pos_orderedquantity is not null and pos_price_no_vat is null and pos_price_with_vat is not null and pos_vat is null and ord_vat is not null
				then pos_orderedquantity * pos_price_with_vat / (1 + ord_vat / 100)
	 	 end) ord_amount_order_calc	
		,ord_doctype
		,ord_type
	from dwh.bi_order_position_clean_bread
group by doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date
		,ord_delivery_date, ord_latest_delivery_date, ord_deliv_place
		,ord_doctype
		,ord_type;
		
--drop table dwh.bi_ordrsp_clean_bread;
create table dwh.bi_ordrsp_clean_bread
as
select doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date
				,ordrsp_action
				,ordrsp_date
				,sum(case 
					when ordrsp_pos_price_no_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_no_vat		
					when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_pos_vat / 100)
					when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is null and ordrsp_vat is not null and ordrsp_pos_orderedquantity is not null
						then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_vat / 100)
			 	 end) ord_amount_ordrsp_calc
				,ordrsp_doctype
			from dwh.bi_ordrsp_position_clean_bread ord
group by doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date
				,ordrsp_action
				,ordrsp_date
				,ordrsp_doctype;

delete from bi_ordrsp_clean_bread where ord_amount_ordrsp_calc is null;

--drop table dwh.bi_desadv_clean_bread;
create table dwh.bi_desadv_clean_bread
as
select doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date
				,desadv_delivery_date
				,sum(case
					when desadv_pos_amount_no_vat is not null
						then desadv_pos_amount_no_vat
					when desadv_pos_amount_no_vat is null and desadv_pos_amount_with_vat is not null and desadv_pos_vat is not null
						then desadv_pos_amount_with_vat / (1 + desadv_pos_vat / 100)
					when desadv_pos_price_no_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity * desadv_pos_price_no_vat		
					when desadv_pos_price_no_vat is null and desadv_pos_price_with_vat is not null and desadv_pos_vat is not null and desadv_pos_deliveredquantity is not null
						then desadv_pos_deliveredquantity / (1 + desadv_pos_vat/100)
			 	 end) ord_amount_desadv_calc
				,desadv_doctype
			from dwh.bi_desadv_position_clean_bread ord
		group by doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date
				,desadv_delivery_date
				,desadv_doctype;

delete from bi_desadv_clean_bread where ord_amount_desadv_calc is null;

--drop table dwh.bi_recadv_clean_bread;
create table dwh.bi_recadv_clean_bread
as
select doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date
				,recadv_reception_date
				,sum(case
					when recadv_pos_amount_no_vat is not null
						then recadv_pos_amount_no_vat
					when recadv_pos_amount_no_vat is null and recadv_pos_amount_with_vat is not null and recadv_pos_vat is not null
						then recadv_pos_amount_with_vat / (1 + recadv_pos_vat / 100)
					when recadv_pos_price_no_vat is not null and recadv_pos_acceptedquantity is not null
						then recadv_pos_acceptedquantity * recadv_pos_price_no_vat		
					when recadv_pos_price_no_vat is null and recadv_pos_price_with_vat is not null and recadv_pos_vat is not null and recadv_pos_acceptedquantity is not null
						then recadv_pos_acceptedquantity / (1 + recadv_pos_vat/100)
			 	 end) ord_amount_recadv_calc
				,recadv_doctype
			from dwh.bi_recadv_position_clean_bread ord
		group by doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date
				,recadv_reception_date
				,recadv_doctype;

--Собираю общую витрину
drop table dwh.bi_orders_dm_clean_bread;
create table dwh.bi_orders_dm_clean_bread
as
select sq.*
,case
	when recadv_order_delivery_delay = '0'::interval then 'Доставлен в срок'
	when recadv_order_delivery_delay > '0'::interval then 'Доставлен c опозданием'
	when recadv_order_delivery_delay < '0'::interval then 'Доставлен раньше'
	when recadv_order_delivery_delay is null then 'Не доставлен'
 end ord_delivery_status
	from (
	select ord.doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_date, ord_number
	,a1.varcompanyname supplier_name, g1.varcityregexp supplier_city, c.region_name
	,ord_delivery_date, ord_latest_delivery_date, g2.varname ord_deliv_place, ord_doctype, ord_type, ord_amount_order_calc
	,rsp.ordrsp_date, rsp.ordrsp_action, rsp.ord_amount_ordrsp_calc
	,des.desadv_delivery_date, des.desadv_doctype, des.ord_amount_desadv_calc
	,rec.recadv_doctype, rec.recadv_reception_date, rec.ord_amount_recadv_calc
	,case
		when des.desadv_delivery_date is not null and (ord.ord_delivery_date is not null or ord.ord_latest_delivery_date is not null)
			then des.desadv_delivery_date - greatest(ord.ord_delivery_date, ord_latest_delivery_date)
			else null
	 end desadv_order_delivery_delay
	,case
		when rsp.ordrsp_date is not null and ord.ord_date is not null
			then rsp.ordrsp_date - ord.ord_date::timestamp
			else null
	 end order_reaction_interval
	,case
		when rec.recadv_reception_date is not null and (ord.ord_delivery_date is not null or ord.ord_latest_delivery_date is not null)
			then rec.recadv_reception_date - greatest(ord.ord_delivery_date, ord_latest_delivery_date)
			else null
	 end recadv_order_delivery_delay
	,case
		when ord.ord_doctype = 'D' or ord.ord_type = 'D'
			then 'Р вЂ”Р В°Р С”Р В°Р В· Р С•РЎвЂљР С�Р ВµР Р…Р ВµР Р… Р С—Р С•Р С”РЎС“Р С—Р В°РЎвЂљР ВµР В»Р ВµР С�'
		when rsp.ordrsp_action = 27
			then 'Р вЂ”Р В°Р С”Р В°Р В· Р С•РЎвЂљР С�Р ВµР Р…Р ВµР Р… Р С—Р С•РЎРѓРЎвЂљР В°Р Р†РЎвЂ°Р С‘Р С”Р С•Р С�'
		when rsp.ordrsp_ord_date is null and des.desadv_ord_date is null and rec.recadv_ord_date is null
			then 'Р вЂ”Р В°Р С”Р В°Р В· Р Р…Р Вµ Р С—Р С•Р Т‘РЎвЂљР Р†Р ВµРЎР‚Р В¶Р Т‘Р ВµР Р…'
		else 'Р вЂ”Р В°Р С”Р В°Р В· Р С—Р С•Р Т‘РЎвЂљР Р†Р ВµРЎР‚Р В¶Р Т‘Р ВµР Р…'
	 end ord_status
		from dwh.bi_order_clean_bread ord --1 572 416
			left join dwh.bi_ordrsp_clean_bread rsp --1 572 432
				on rsp.ordrsp_buyer_gln=ord.ord_buyer_gln
				and rsp.ordrsp_supplier_gln=ord.ord_supplier_gln
				and rsp.ordrsp_ord_date=ord.ord_date
				and rsp.ordrsp_ord_number=ord.ord_number
			left join dwh.bi_desadv_clean_bread des --1 572 469
				on des.desadv_buyer_gln=ord.ord_buyer_gln
				and des.desadv_supplier_gln=ord.ord_supplier_gln
				and des.desadv_ord_date=ord.ord_date
				and des.desadv_ord_number=ord.ord_number
			left join dwh.bi_recadv_clean_bread rec -- 1 573 929
				on rec.doc_chain_id=ord.doc_chain_id
				and rec.recadv_buyer_gln=ord.ord_buyer_gln
				and rec.recadv_supplier_gln=ord.ord_supplier_gln
				and rec.recadv_ord_date=ord.ord_date
				and rec.recadv_ord_number=ord.ord_number
			inner join dwh.stg_gln g1
				on g1.varGln=ord.ord_supplier_gln
			left join dwh.stg_gln g2
				on g2.varGln=ord.ord_deliv_place
			inner join dwh.stg_account a1
				on a1.intaccountid=g1.intaccountid
			left join dwh.dim_city c
				on c.city_name=g1.varcityregexp
				) sq
order by ord_date, ord_buyer_gln, ord_supplier_gln, ord_number;

--update dwh.bi_orders_dm_clean_bread
--	set region_name='Р В РЎСљР В РЎвЂ�Р В Р’В¶Р В Р’ВµР В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ (Р В РІР‚СљР В РЎвЂўР РЋР вЂљР РЋР Р‰Р В РЎвЂќР В РЎвЂўР В Р вЂ Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ)'
--		where supplier_city in ('Р В РЎСљ.Р В Р вЂ¦Р В РЎвЂўР В Р вЂ Р В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�','Р В РЎСљР В РЎвЂ�Р В Р’В¶Р В Р’ВµР В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ Р В РЎвЂєР В Р’В±Р В Р’В»., Р В РЎв„ўР В Р вЂ¦Р РЋР РЏР В РЎвЂ“Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂ�Р В Р вЂ¦Р РЋР С“Р В РЎвЂќР В РЎвЂ�Р В РІвЂћвЂ“ Р В Р’В -Р В РЎСљ,Р В РЎв„ўР В Р вЂ¦Р РЋР РЏР В РЎвЂ“Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂў');

delete from dwh.bi_orders_dm_clean_bread where ord_date <= date'2017-11-01';

create index bi_orders_dm_clean_bread_idx1 on dwh.bi_orders_dm_clean_bread (ord_date, ord_buyer_gln, ord_supplier_gln, ord_number);
create index bi_orders_dm_clean_bread_idx2 on dwh.bi_orders_dm_clean_bread (ord_date, ord_buyer_gln);
create index bi_orders_dm_clean_bread_idx3 on dwh.bi_orders_dm_clean_bread (ord_date, ord_supplier_gln);
analyze verbose dwh.bi_orders_dm_clean_bread;

drop table dwh.bi_order_position_dm_clean_bread;
create table dwh.bi_order_position_dm_clean_bread
as
select ord.doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date, pos_product_num, pos_description, u.unit_id
		,g2.varname ord_deliv_place
		,a1.varcompanyname supplier_name, g1.varcityregexp supplier_city, c.region_name
		,sum(case 
			when pos_price_no_vat is not null and pos_orderedquantity is not null
				then pos_orderedquantity * pos_price_no_vat		
			when pos_price_no_vat is null and pos_price_with_vat is not null and pos_vat is not null and pos_orderedquantity is not null
				then pos_orderedquantity * pos_price_with_vat / (1 + pos_vat / 100)
			when pos_orderedquantity is not null and pos_price_no_vat is null and pos_price_with_vat is not null and pos_vat is null and ord_vat is not null
				then pos_orderedquantity * pos_price_with_vat / (1 + ord_vat / 100)
	 	 end) pos_amount_order_calc
	 	,sum(case
			when recadv_pos_amount_no_vat is not null
				then recadv_pos_amount_no_vat
			when recadv_pos_amount_no_vat is null and recadv_pos_amount_with_vat is not null and recadv_pos_vat is not null
				then recadv_pos_amount_with_vat / (1 + recadv_pos_vat / 100)
			when recadv_pos_price_no_vat is not null and recadv_pos_acceptedquantity is not null
				then recadv_pos_acceptedquantity * recadv_pos_price_no_vat		
			when recadv_pos_price_no_vat is null and recadv_pos_price_with_vat is not null and recadv_pos_vat is not null and recadv_pos_acceptedquantity is not null
				then recadv_pos_acceptedquantity / (1 + recadv_pos_vat/100)
	 	 end) pos_amount_recadv_calc
	 	,pos_orderedquantity
	 	,rec.recadv_pos_acceptedquantity
	from dwh.bi_order_position_clean_bread ord
		left join dwh.bi_recadv_position_clean_bread rec
				on rec.doc_chain_id=ord.doc_chain_id
				and rec.recadv_buyer_gln=ord.ord_buyer_gln
				and rec.recadv_supplier_gln=ord.ord_supplier_gln
				and rec.recadv_ord_date=ord.ord_date
				and rec.recadv_ord_number=ord.ord_number
				and rec.recadv_pos_product_num=ord.pos_product_num
		inner join dwh.dim_units u
			on u.unit_code_iso=ord.pos_unit_name
		inner join dwh.stg_gln g1
				on g1.varGln=ord.ord_supplier_gln
		left join dwh.stg_gln g2
				on g2.varGln=ord.ord_deliv_place
		inner join dwh.stg_account a1
			on a1.intaccountid=g1.intaccountid
		left join dwh.dim_city c
			on c.city_name=g1.varcityregexp
group by ord.doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date, pos_product_num, pos_description, u.unit_id, g2.varname, pos_orderedquantity,rec.recadv_pos_acceptedquantity
		,a1.varcompanyname, g1.varcityregexp, c.region_name;

create index bi_order_position_dm_clean_bread_idx1 on dwh.bi_order_position_dm_clean_bread (ord_date, ord_buyer_gln, ord_supplier_gln, ord_number);

delete from dwh.bi_order_position_dm_clean_bread where ord_date <= date'2017-11-01';

--update dwh.bi_order_position_dm_clean_bread
--	set region_name='Р В РЎСљР В РЎвЂ�Р В Р’В¶Р В Р’ВµР В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ (Р В РІР‚СљР В РЎвЂўР РЋР вЂљР РЋР Р‰Р В РЎвЂќР В РЎвЂўР В Р вЂ Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ)'
--		where supplier_city in ('Р В РЎСљ.Р В Р вЂ¦Р В РЎвЂўР В Р вЂ Р В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�','Р В РЎСљР В РЎвЂ�Р В Р’В¶Р В Р’ВµР В РЎвЂ“Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РўвЂ�Р РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ Р В РЎвЂєР В Р’В±Р В Р’В»., Р В РЎв„ўР В Р вЂ¦Р РЋР РЏР В РЎвЂ“Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂ�Р В Р вЂ¦Р РЋР С“Р В РЎвЂќР В РЎвЂ�Р В РІвЂћвЂ“ Р В Р’В -Р В РЎСљ,Р В РЎв„ўР В Р вЂ¦Р РЋР РЏР В РЎвЂ“Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂ�Р В Р вЂ¦Р В РЎвЂў');
--analyze verbose dwh.bi_order_position_dm_clean;
commit;