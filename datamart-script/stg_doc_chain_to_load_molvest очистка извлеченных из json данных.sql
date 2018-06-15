drop table dwh.bi_order_position_uniq_x5_molvest;
create table dwh.bi_order_position_uniq_x5_molvest
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
				--Корректировка идет не по позициям, а по всему заказу, поэтому надо вычилять её иначе, иначе ошибки в заказах где была замена позиции
				,row_number() over (partition by doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date, pos_product_num order by coalesce(ord_version,0), ord_doctype, ord_type desc) rn
				from dwh.bi_order_position_trans_x5_molvest ord
					where ord_buyer_gln is not null
						and ord_supplier_gln is not null
						and ord_number is not null
						and ord_date is not null
						and pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

drop table dwh.bi_ordrsp_position_uniq_x5_molvest;
create table dwh.bi_ordrsp_position_uniq_x5_molvest
as
select *
	from (
			select doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date, ordrsp_pos_product_num
--				,ordrsp_pos_number, ordrsp_pos_description
				,ordrsp_pos_product_type --1 без изм, 2-изм кол-ва, 3-отказ
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
				--Корректировка идет не по позициям, а по всему заказу, поэтому надо вычилять её иначе, иначе ошибки в заказах где была замена позиции
				,row_number() over (partition by doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date, ordrsp_pos_product_num order by coalesce(ordrsp_version,0), ordrsp_doctype desc) rn
				from dwh.bi_orderrsp_position_trans_x5_molvest ord
					where doc_chain_id is not null
						and ordrsp_buyer_gln is not null
						and ordrsp_supplier_gln is not null
						and ordrsp_ord_number is not null
						and ordrsp_ord_date is not null
						and ordrsp_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

drop table dwh.bi_desadv_position_uniq_x5_molvest;
create table dwh.bi_desadv_position_uniq_x5_molvest
as
select *
	from (
			select doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date, desadv_pos_product_num
--				,desadv_pos_number, desadv_pos_description
--				,(desadv_delivery_date||' '||coalesce(desadv_delivery_time,'00:00'))::timestamp desadv_delivery_date --хреновые данные в desadv_delivery_time, надо чистить
				,desadv_delivery_date
				,desadv_pos_orderedquantity, desadv_pos_deliveredquantity
				,desadv_pos_amount_no_vat, desadv_pos_amount_with_vat, desadv_pos_price_no_vat, desadv_pos_price_with_vat, desadv_pos_vat
				,case
					when desadv_doctype is null then 'O'
					when desadv_doctype in ('O','R','D') then desadv_doctype
					else 'X'
				 end desadv_doctype
				,coalesce(desadv_version,0) desadv_version
				--Корректировка идет не по позициям, а по всему заказу, поэтому надо вычилять её иначе, иначе ошибки в заказах где была замена позиции
			,row_number() over (partition by doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date, desadv_pos_product_num order by coalesce(desadv_version,0), desadv_doctype desc) rn
				from dwh.bi_desadv_position_trans_x5_molvest ord
					where doc_chain_id is not null
					and desadv_buyer_gln is not null
					and desadv_supplier_gln is not null
					and desadv_ord_number is not null
					and desadv_ord_date is not null
					and desadv_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

drop table dwh.bi_recadv_position_uniq_x5_molvest;
create table dwh.bi_recadv_position_uniq_x5_molvest
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
				--Корректировка идет не по позициям, а по всему заказу, поэтому надо вычилять её иначе, иначе ошибки в заказах где была замена позиции
			,row_number() over (partition by doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date, recadv_pos_product_num order by coalesce(recadv_version,0), recadv_doctype desc) rn
				from dwh.bi_recadv_position_trans_x5_molvest ord
					where doc_chain_id is not null
					and recadv_buyer_gln is not null
					and recadv_supplier_gln is not null
					and recadv_ord_number is not null
					and recadv_ord_date is not null
					and recadv_pos_product_num is not null
) sq
where rn=1
order by 1,2,3,4,5,6;

create index bi_order_position_uniq_x5_molvest_idx1 on dwh.bi_order_position_uniq_x5_molvest (ord_date);
create index bi_order_position_uniq_x5_molvest_idx2 on dwh.bi_order_position_uniq_x5_molvest (doc_chain_id);
create index bi_order_position_uniq_x5_molvest_idx3 on dwh.bi_order_position_uniq_x5_molvest (ord_number,ord_date,ord_supplier_gln,ord_buyer_gln,ord_doctype);
create index bi_ordrsp_position_uniq_x5_molvest_idx1 on dwh.bi_ordrsp_position_uniq_x5_molvest (doc_chain_id);
create index bi_desadv_position_uniq_x5_molvest_idx1 on dwh.bi_desadv_position_uniq_x5_molvest (doc_chain_id);
create index bi_recadv_position_uniq_x5_molvest_idx1 on dwh.bi_recadv_position_uniq_x5_molvest (doc_chain_id);

analyze verbose dwh.bi_order_position_uniq_x5_molvest;
analyze verbose dwh.bi_ordrsp_position_uniq_x5_molvest;
analyze verbose dwh.bi_desadv_position_uniq_x5_molvest;
analyze verbose dwh.bi_recadv_position_uniq_x5_molvest;

--Загрузка очищенных документов
drop table dwh.bi_order_position_clean_x5_molvest;
create table dwh.bi_order_position_clean_x5_molvest
as
select *
	from dwh.bi_order_position_uniq_x5_molvest
		where ord_doctype in ('O','R')
		and ord_type in ('O','R');

create index bi_order_position_clean_x5_molvest_idx1 on dwh.bi_order_position_clean_x5_molvest (doc_chain_id);
create index bi_order_position_clean_x5_molvest_idx2 on dwh.bi_order_position_clean_x5_molvest (ord_number);
analyze verbose dwh.bi_order_position_clean_x5_molvest;

--Убираем отмены и возвраты (Они убираются автоматом, возврат имеет новую версию, поэтому фильтруется по rn=1 и ord_doctype in ('O','R'))
--alter table dwh.bi_order_position_uniq_x5_molvest add del_mrk varchar(1);
--delete from dwh.bi_order_position_clean_x5_molvest o1
--update dwh.bi_order_position_uniq_x5_molvest o1
--	set del_mrk = 'y'
--	where exists (select 1
--					from dwh.bi_order_position_uniq_x5_molvest o2
--						where o2.ord_doctype in ('D','RETORD')
--						and o2.ord_buyer_gln=o1.ord_buyer_gln
--						and o2.ord_supplier_gln=o1.ord_supplier_gln
--						and o2.ord_number=o1.ord_number
--						and o2.ord_date=o1.ord_date);

--analyze verbose dwh.bi_order_position_clean_x5_molvest;

drop table dwh.bi_ordrsp_position_clean_x5_molvest;
create table dwh.bi_ordrsp_position_clean_x5_molvest
as
select *
	from dwh.bi_ordrsp_position_uniq_x5_molvest
		where ordrsp_doctype in ('O','R');

--Удаляем те позиции, где нельзя посчитать стоимость
delete from dwh.bi_ordrsp_position_clean_x5_molvest
	where case 
				when ordrsp_pos_price_no_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_no_vat		
				when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_pos_vat / 100)
				when ordrsp_pos_price_no_vat is null and ordrsp_pos_price_with_vat is not null and ordrsp_pos_vat is null and ordrsp_vat is not null and ordrsp_pos_orderedquantity is not null
					then ordrsp_pos_orderedquantity * ordrsp_pos_price_with_vat / (1 + ordrsp_vat / 100)
		 	 end = 0;

create index bi_ordrsp_position_clean_x5_molvest_idx1 on dwh.bi_ordrsp_position_clean_x5_molvest (doc_chain_id);
create index bi_ordrsp_position_clean_x5_molvest_idx2 on dwh.bi_ordrsp_position_clean_x5_molvest (ordrsp_buyer_gln,ordrsp_supplier_gln,ordrsp_ord_date,ordrsp_ord_number,ordrsp_pos_product_num);
analyze verbose dwh.bi_ordrsp_position_clean_x5_molvest;

drop table dwh.bi_desadv_position_clean_x5_molvest;
create table dwh.bi_desadv_position_clean_x5_molvest
as
select *
	from dwh.bi_desadv_position_uniq_x5_molvest;

delete from bi_desadv_position_clean_x5_molvest
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

create index bi_desadv_position_clean_x5_molvest_idx1 on dwh.bi_desadv_position_clean_x5_molvest (doc_chain_id);
create index bi_desadv_position_clean_x5_molvest_idx2 on dwh.bi_desadv_position_clean_x5_molvest (desadv_buyer_gln,desadv_supplier_gln,desadv_ord_date,desadv_ord_number,desadv_pos_product_num);
analyze verbose dwh.bi_desadv_position_clean_x5_molvest;

drop table dwh.bi_recadv_position_clean_x5_molvest;
create table dwh.bi_recadv_position_clean_x5_molvest
as
select *
	from dwh.bi_recadv_position_uniq_x5_molvest;

create index bi_recadv_position_clean_x5_molvest_idx1 on dwh.bi_recadv_position_clean_x5_molvest (doc_chain_id);
analyze verbose dwh.bi_recadv_position_clean_x5_molvest;

--Витрины заказов
drop table dwh.bi_order_clean_x5_molvest;
create table dwh.bi_order_clean_x5_molvest
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
	from dwh.bi_order_position_clean_x5_molvest
group by doc_chain_id, ord_buyer_gln, ord_supplier_gln, ord_number, ord_date
		,ord_delivery_date, ord_latest_delivery_date, ord_deliv_place
		,ord_doctype
		,ord_type;
		
drop table dwh.bi_ordrsp_clean_x5_molvest;
create table dwh.bi_ordrsp_clean_x5_molvest
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
			from dwh.bi_ordrsp_position_clean_x5_molvest ord
group by doc_chain_id, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_ord_number, ordrsp_ord_date
				,ordrsp_action
				,ordrsp_date
				,ordrsp_doctype;

delete from bi_ordrsp_clean_x5_molvest where ord_amount_ordrsp_calc is null;

drop table dwh.bi_desadv_clean_x5_molvest;
create table dwh.bi_desadv_clean_x5_molvest
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
			from dwh.bi_desadv_position_clean_x5_molvest ord
		group by doc_chain_id, desadv_buyer_gln, desadv_supplier_gln, desadv_ord_number, desadv_ord_date
				,desadv_delivery_date
				,desadv_doctype;

delete from bi_desadv_clean_x5_molvest where ord_amount_desadv_calc is null;

drop table dwh.bi_recadv_clean_x5_molvest;
create table dwh.bi_recadv_clean_x5_molvest
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
			from dwh.bi_recadv_position_clean_x5_molvest ord
		group by doc_chain_id, recadv_buyer_gln, recadv_supplier_gln, recadv_ord_number, recadv_ord_date
				,recadv_reception_date
				,recadv_doctype;

--Собираю общую витрину
drop table dwh.bi_orders_dm_clean_molvest;
create table dwh.bi_orders_dm_clean_molvest
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
			then 'Заказ отменен покупателем'
		when rsp.ordrsp_action = 27
			then 'Заказ отменен поставщиком'
		when rsp.ordrsp_ord_date is null and des.desadv_ord_date is null and rec.recadv_ord_date is null
			then 'Заказ не подтвержден'
		else 'Заказ подтвержден'
	 end ord_status
		from dwh.bi_order_clean_x5_molvest ord --1 572 416
			left join dwh.bi_ordrsp_clean_x5_molvest rsp --1 572 432
				on rsp.ordrsp_buyer_gln=ord.ord_buyer_gln
				and rsp.ordrsp_supplier_gln=ord.ord_supplier_gln
				and rsp.ordrsp_ord_date=ord.ord_date
				and rsp.ordrsp_ord_number=ord.ord_number
			left join dwh.bi_desadv_clean_x5_molvest des --1 572 469
				on des.desadv_buyer_gln=ord.ord_buyer_gln
				and des.desadv_supplier_gln=ord.ord_supplier_gln
				and des.desadv_ord_date=ord.ord_date
				and des.desadv_ord_number=ord.ord_number
			left join dwh.bi_recadv_clean_x5_molvest rec -- 1 573 929
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

--update dwh.bi_orders_dm_clean_molvest
--	set region_name='РќРёР¶РµРіРѕСЂРѕРґСЃРєР°СЏ (Р“РѕСЂСЊРєРѕРІСЃРєР°СЏ)'
--		where supplier_city in ('Рќ.РЅРѕРІРіРѕСЂРѕРґ','РќРёР¶РµРіРѕСЂРѕРґСЃРєР°СЏ РћР±Р»., РљРЅСЏРіРёРЅРёРЅСЃРєРёР№ Р -Рќ,РљРЅСЏРіРёРЅРёРЅРѕ');

delete from dwh.bi_orders_dm_clean_molvest where ord_date <= date'2017-11-01';

create index bi_orders_dm_clean_molvest_idx1 on dwh.bi_orders_dm_clean_molvest (ord_date, ord_buyer_gln, ord_supplier_gln, ord_number);
create index bi_orders_dm_clean_molvest_idx2 on dwh.bi_orders_dm_clean_molvest (ord_date, ord_buyer_gln);
create index bi_orders_dm_clean_molvest_idx3 on dwh.bi_orders_dm_clean_molvest (ord_date, ord_supplier_gln);
analyze verbose dwh.bi_orders_dm_clean_molvest;

drop table dwh.bi_order_position_dm_clean_molvest;
create table dwh.bi_order_position_dm_clean_molvest
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
	from dwh.bi_order_position_clean_x5_molvest ord
		left join dwh.bi_recadv_position_clean_x5_molvest rec
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

create index bi_order_position_dm_clean_molvest_idx1 on dwh.bi_order_position_dm_clean_molvest (ord_date, ord_buyer_gln, ord_supplier_gln, ord_number);

delete from dwh.bi_order_position_dm_clean_molvest where ord_date <= date'2017-11-01';

--update dwh.bi_order_position_dm_clean_molvest
--	set region_name='РќРёР¶РµРіРѕСЂРѕРґСЃРєР°СЏ (Р“РѕСЂСЊРєРѕРІСЃРєР°СЏ)'
--		where supplier_city in ('Рќ.РЅРѕРІРіРѕСЂРѕРґ','РќРёР¶РµРіРѕСЂРѕРґСЃРєР°СЏ РћР±Р»., РљРЅСЏРіРёРЅРёРЅСЃРєРёР№ Р -Рќ,РљРЅСЏРіРёРЅРёРЅРѕ');
--analyze verbose dwh.bi_order_position_dm_clean;
commit;