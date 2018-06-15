create table dwh.bi_ordrsp_agg
as
select distinct ordrsp_ord_number, ordrsp_ord_date, ordrsp_supplier_gln, ordrsp_byer_gln, doc_chain_id
	from dwh.bi_orderrsp_position
		where ordrsp_ord_number is not null
			and ordrsp_ord_date is not null
			and ordrsp_supplier_gln is not null
			and ordrsp_byer_gln is not null;
	
create table dwh.bi_desadv_agg
as
select distinct desadv_ord_number, desadv_ord_date, desadv_supplier_gln, desadv_byer_gln, doc_chain_id
	from dwh.bi_desadv_position
		where desadv_ord_number is not null
			and desadv_ord_date is not null
			and desadv_supplier_gln is not null
			and desadv_byer_gln is not null;
	
create table dwh.bi_recadv_agg
as
select distinct recadv_ord_number, recadv_ord_date, recadv_supplier_gln, recadv_byer_gln, doc_chain_id
	from dwh.bi_recadv_position
		where recadv_ord_number is not null
			and recadv_ord_date is not null
			and recadv_supplier_gln is not null
			and recadv_byer_gln is not null;
	
create table dwh.bi_orders_agg
as
select distinct ord_number, ord_date, ord_supplier_gln, ord_byer_gln, doc_chain_id
	from dwh.bi_order_position
		where ord_number is not null
			and ord_date is not null
			and ord_supplier_gln is not null
			and ord_byer_gln is not null;

select * from dwh.bi_order_position o
	inner join dwh.bi_recadv_position r
		on o.doc_chain_id=r.doc_chain_id
	
--drop table dwh.bi_ordrsp_agg;
--drop table dwh.bi_desadv_agg;
--drop table dwh.bi_recadv_agg;
--drop table dwh.bi_orders_agg;

select * from dwh.bi_desadv_agg;
select * from dwh.bi_recadv_agg;
select * from dwh.bi_orders_agg;
select * from dwh.bi_ordrsp_agg;

select count(1) cnt, count(ord_number) ordnum, count(ord_date) orddate, count(ord_byer_gln) buy, count(ord_supplier_gln) suppl
	from dwh.bi_orders_agg
	where ord_number is not null;

select count(1) cnt, count(ordrsp_ord_number) ordnum, count(ordrsp_ord_date) orddate, count(ordrsp_byer_gln) buy, count(ordrsp_supplier_gln) suppl
	from dwh.bi_ordrsp_agg
		where ordrsp_byer_gln is not null;

select count(1) cnt, count(desadv_ord_number) ordnum, count(desadv_ord_date) orddate, count(desadv_byer_gln) buy, count(desadv_supplier_gln) suppl
	from dwh.bi_desadv_agg
		where desadv_ord_number is not null;

select count(1) cnt, count(recadv_ord_number) ordnum, count(recadv_ord_date) orddate, count(recadv_byer_gln) buy, count(recadv_supplier_gln) suppl
	from dwh.bi_recadv_agg
		where recadv_ord_number is not null;

select doc_chain_id, count(1) cnt
	from dwh.bi_orders_agg
group by 1
having count(1)>1
order by count(1) desc;

select * from stg_doc_chain_to_load
	where intchainid=897240408;

--Stats by buyers
--drop table del_me_doc_chain_stats_byers;
create table del_me_doc_chain_stats_byers
as
select a.varcompanyname acc_varcompanyname
,count(ord.doc_chain_id) ord_cnt
,count(rsp.doc_chain_id) rsp_cnt
,count(des.doc_chain_id) des_cnt
,count(rec.doc_chain_id) rec_cnt
	from dwh.bi_orders_agg ord
		left join (select distinct doc_chain_id from bi_ordrsp_agg rsp) rsp
			on ord.doc_chain_id=rsp.doc_chain_id
--			and ord.ord_number=rsp.ordrsp_ord_number
--			and ord.ord_date=rsp.ordrsp_ord_date
--			and ord_byer_gln=rsp.ordrsp_byer_gln
--			and ord_supplier_gln=rsp.ordrsp_supplier_gln
		left join (select distinct doc_chain_id from bi_desadv_agg des) des
			on ord.doc_chain_id=des.doc_chain_id
--			and ord.ord_number=des.desadv_ord_number
--			and ord.ord_date=des.desadv_ord_date
--			and ord_byer_gln=des.desadv_byer_gln
--			and ord_supplier_gln=des.desadv_supplier_gln
		left join (select distinct doc_chain_id from bi_recadv_agg rec) rec
			on ord.doc_chain_id=rec.doc_chain_id
--			and ord.ord_number=rec.recadv_ord_number
--			and ord.ord_date=rec.recadv_ord_date
--			and ord_byer_gln=rec.recadv_byer_gln
--			and ord_supplier_gln=rec.recadv_supplier_gln
		left join dwh.stg_gln g
			on g.vargln=ord.ord_byer_gln
		left join dwh.stg_account a
			on a.intaccountid=g.intaccountid
	where ord.ord_byer_gln is not null --по ошибке загружены документы, которых по факту нет, не учитываем их
group by a.varcompanyname;

select sq.*
,round(rsp_cnt::numeric/ord_cnt::numeric,4) rsp_prc
,round(des_cnt::numeric/ord_cnt::numeric,4) des_prc
,round(rec_cnt::numeric/ord_cnt::numeric,4) rec_prc
	from del_me_doc_chain_stats_byers sq
order by rec_prc desc;

--Stats by suppliers
--drop table del_me_doc_chain_stats_suppl;
create table del_me_doc_chain_stats_suppl
as
select a.varcompanyname acc_varcompanyname
,count(ord.doc_chain_id) ord_cnt
,count(rsp.doc_chain_id) rsp_cnt
,count(des.doc_chain_id) des_cnt
,count(rec.doc_chain_id) rec_cnt
	from dwh.bi_orders_agg ord
		left join (select distinct doc_chain_id from bi_ordrsp_agg rsp) rsp
			on ord.doc_chain_id=rsp.doc_chain_id
--			and ord.ord_number=rsp.ordrsp_ord_number
--			and ord.ord_date=rsp.ordrsp_ord_date
--			and ord_byer_gln=rsp.ordrsp_byer_gln
--			and ord_supplier_gln=rsp.ordrsp_supplier_gln
		left join (select distinct doc_chain_id from bi_desadv_agg des) des
			on ord.doc_chain_id=des.doc_chain_id
--			and ord.ord_number=des.desadv_ord_number
--			and ord.ord_date=des.desadv_ord_date
--			and ord_byer_gln=des.desadv_byer_gln
--			and ord_supplier_gln=des.desadv_supplier_gln
		left join (select distinct doc_chain_id from bi_recadv_agg rec) rec
			on ord.doc_chain_id=rec.doc_chain_id
--			and ord.ord_number=rec.recadv_ord_number
--			and ord.ord_date=rec.recadv_ord_date
--			and ord_byer_gln=rec.recadv_byer_gln
--			and ord_supplier_gln=rec.recadv_supplier_gln
		left join dwh.stg_gln g
			on g.vargln=ord.ord_supplier_gln
		left join dwh.stg_account a
			on a.intaccountid=g.intaccountid
	where ord.ord_supplier_gln is not null --по ошибке загружены документы, которых по факту нет, не учитываем их
group by a.varcompanyname;

select sq.*
,round(rsp_cnt::numeric/ord_cnt::numeric,4) rsp_prc
,round(des_cnt::numeric/ord_cnt::numeric,4) des_prc
,round(rec_cnt::numeric/ord_cnt::numeric,4) rec_prc
	from del_me_doc_chain_stats_suppl sq
order by rec_prc desc;

--Stats for x5 by suppliers
--drop table del_me_doc_chain_stats_suppl;
create table del_me_doc_chain_stats_suppl_x5
as
select a.varcompanyname acc_varcompanyname
,count(ord.doc_chain_id) ord_cnt
,count(rsp.doc_chain_id) rsp_cnt
,count(des.doc_chain_id) des_cnt
,count(rec.doc_chain_id) rec_cnt
	from dwh.bi_orders_agg ord
		left join (select distinct doc_chain_id from bi_ordrsp_agg rsp) rsp
			on ord.doc_chain_id=rsp.doc_chain_id
--			and ord.ord_number=rsp.ordrsp_ord_number
--			and ord.ord_date=rsp.ordrsp_ord_date
--			and ord_byer_gln=rsp.ordrsp_byer_gln
--			and ord_supplier_gln=rsp.ordrsp_supplier_gln
		left join (select distinct doc_chain_id from bi_desadv_agg des) des
			on ord.doc_chain_id=des.doc_chain_id
--			and ord.ord_number=des.desadv_ord_number
--			and ord.ord_date=des.desadv_ord_date
--			and ord_byer_gln=des.desadv_byer_gln
--			and ord_supplier_gln=des.desadv_supplier_gln
		left join (select distinct doc_chain_id from bi_recadv_agg rec) rec
			on ord.doc_chain_id=rec.doc_chain_id
--			and ord.ord_number=rec.recadv_ord_number
--			and ord.ord_date=rec.recadv_ord_date
--			and ord_byer_gln=rec.recadv_byer_gln
--			and ord_supplier_gln=rec.recadv_supplier_gln
		left join dwh.stg_gln g
			on g.vargln=ord.ord_supplier_gln
		left join dwh.stg_account a
			on a.intaccountid=g.intaccountid
		inner join dwh.stg_gln_x5 g5
			on g5.vargln=ord.ord_byer_gln
	where ord.ord_supplier_gln is not null --по ошибке загружены документы, которых по факту нет, не учитываем их
group by a.varcompanyname;

select sq.*
,round(rsp_cnt::numeric/ord_cnt::numeric,4) rsp_prc
,round(des_cnt::numeric/ord_cnt::numeric,4) des_prc
,round(rec_cnt::numeric/ord_cnt::numeric,4) rec_prc
	from del_me_doc_chain_stats_suppl_x5 sq
order by rec_prc desc;

--Stats for Хлебозавод № 24 by buyers
--drop table del_me_doc_chain_stats_suppl;
create table del_me_doc_chain_stats_buy_hleb
as
select a.varcompanyname acc_varcompanyname
,count(ord.doc_chain_id) ord_cnt
,count(rsp.doc_chain_id) rsp_cnt
,count(des.doc_chain_id) des_cnt
,count(rec.doc_chain_id) rec_cnt
	from dwh.bi_orders_agg ord
		left join (select distinct doc_chain_id from bi_ordrsp_agg rsp) rsp
			on ord.doc_chain_id=rsp.doc_chain_id
--			and ord.ord_number=rsp.ordrsp_ord_number
--			and ord.ord_date=rsp.ordrsp_ord_date
--			and ord_byer_gln=rsp.ordrsp_byer_gln
--			and ord_supplier_gln=rsp.ordrsp_supplier_gln
		left join (select distinct doc_chain_id from bi_desadv_agg des) des
			on ord.doc_chain_id=des.doc_chain_id
--			and ord.ord_number=des.desadv_ord_number
--			and ord.ord_date=des.desadv_ord_date
--			and ord_byer_gln=des.desadv_byer_gln
--			and ord_supplier_gln=des.desadv_supplier_gln
		left join (select distinct doc_chain_id from bi_recadv_agg rec) rec
			on ord.doc_chain_id=rec.doc_chain_id
--			and ord.ord_number=rec.recadv_ord_number
--			and ord.ord_date=rec.recadv_ord_date
--			and ord_byer_gln=rec.recadv_byer_gln
--			and ord_supplier_gln=rec.recadv_supplier_gln
		left join dwh.stg_gln g
			on g.vargln=ord.ord_byer_gln
		left join dwh.stg_account a
			on a.intaccountid=g.intaccountid
		inner join dwh.stg_gln g5
			on g5.vargln=ord.ord_supplier_gln
		inner join dwh.stg_account a5
			on a5.intaccountid=g5.intaccountid
	where ord.ord_supplier_gln is not null --по ошибке загружены документы, которых по факту нет, не учитываем их
		and a5.varcompanyname = 'Хлебозавод № 24'
group by a.varcompanyname;

select sq.*
,round(rsp_cnt::numeric/ord_cnt::numeric,4) rsp_prc
,round(des_cnt::numeric/ord_cnt::numeric,4) des_prc
,round(rec_cnt::numeric/ord_cnt::numeric,4) rec_prc
	from del_me_doc_chain_stats_buy_hleb sq
order by rec_prc desc;



--Stats by suppliers
--drop table del_me_doc_chain_stats_suppl_detail;
create table del_me_doc_chain_stats_suppl_detail
as
select a.varcompanyname suppl_name
,a2.varcompanyname buyer_name
,count(ord.doc_chain_id) ord_cnt
,count(rsp.doc_chain_id) rsp_cnt
,count(des.doc_chain_id) des_cnt
,count(rec.doc_chain_id) rec_cnt
	from dwh.bi_orders_agg ord
		left join (select distinct doc_chain_id from bi_ordrsp_agg rsp) rsp
			on ord.doc_chain_id=rsp.doc_chain_id
--			and ord.ord_number=rsp.ordrsp_ord_number
--			and ord.ord_date=rsp.ordrsp_ord_date
--			and ord_byer_gln=rsp.ordrsp_byer_gln
--			and ord_supplier_gln=rsp.ordrsp_supplier_gln
		left join (select distinct doc_chain_id from bi_desadv_agg des) des
			on ord.doc_chain_id=des.doc_chain_id
--			and ord.ord_number=des.desadv_ord_number
--			and ord.ord_date=des.desadv_ord_date
--			and ord_byer_gln=des.desadv_byer_gln
--			and ord_supplier_gln=des.desadv_supplier_gln
		left join (select distinct doc_chain_id from bi_recadv_agg rec) rec
			on ord.doc_chain_id=rec.doc_chain_id
--			and ord.ord_number=rec.recadv_ord_number
--			and ord.ord_date=rec.recadv_ord_date
--			and ord_byer_gln=rec.recadv_byer_gln
--			and ord_supplier_gln=rec.recadv_supplier_gln
		left join dwh.stg_gln g
			on g.vargln=ord.ord_supplier_gln
		left join dwh.stg_account a
			on a.intaccountid=g.intaccountid
		left join dwh.stg_gln g2
			on g2.vargln=ord.ord_byer_gln
		left join dwh.stg_account a2
			on a2.intaccountid=g2.intaccountid
	where ord.ord_supplier_gln is not null --по ошибке загружены документы, которых по факту нет, не учитываем их
group by a.varcompanyname,a2.varcompanyname;

select sq.*
,round(rsp_cnt::numeric/ord_cnt::numeric,4) rsp_prc
,round(des_cnt::numeric/ord_cnt::numeric,4) des_prc
,round(rec_cnt::numeric/ord_cnt::numeric,4) rec_prc
	from del_me_doc_chain_stats_suppl_detail sq
order by rec_prc desc;
