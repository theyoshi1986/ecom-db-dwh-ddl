-------------------------------------
--Отчет по срокам поставки для сети
-------------------------------------
drop table dwh.bi_delivery_time_report_agg;
create table dwh.bi_delivery_time_report_agg
as
select
-- gln1.varName buyer_name
 a1.varcompanyname buyer_name
--,'Поставщик '||substr(gln2.varName,6,1) supplier_name
,a2.varcompanyname supplier_name
,gln2.varcityregexp supplier_city
,ord.ord_number
,ord.ord_date
,ord.ord_delivery_date
,recadv.recadv_date
,recadv.recadv_reception_date
,round(coalesce(recadv.recadv_reception_date,current_date)-ord.ord_delivery_date,2) order_delivery_delay
    from dwh.bi_doc_order_agg ord
        left join dwh.bi_doc_recadv_agg recadv
        	on ord.ord_number=recadv.recadv_ord_number
        	and ord.ord_buyer_gln=recadv.recadv_byer_gln
        	and ord.ord_supplier_gln=recadv.recadv_supplier_gln
    	inner join dwh.stg_gln gln1
    		on ord.ord_buyer_gln=gln1.vargln
    	inner join dwh.stg_account a1
    		on a1.intaccountid=gln1.intaccountid
    	inner join dwh.stg_gln gln2
    		on ord.ord_supplier_gln=gln2.vargln
    	inner join dwh.stg_account a2
    		on a2.intaccountid=gln2.intaccountid
order by ord.ord_date, gln2.varcityregexp;

create table dwh.bi_delivery_time_report_agg_tmp
as
select sq.*, row_number() over () rnk
	from dwh.bi_delivery_time_report_agg sq;

update dwh.bi_delivery_time_report_agg_tmp
	set recadv_date = case	
						when width_bucket(rnk,1,6000000,10) between 1 and 8 then ord_delivery_date + width_bucket(rnk,1,6000000,10)
							else null
					  end
		where recadv_date is null;

update dwh.bi_delivery_time_report_agg_tmp
	set recadv_reception_date = recadv_date
		where recadv_reception_date is null
			and recadv_date is not null;

alter table dwh.bi_delivery_time_report_agg rename to bi_delivery_time_report_agg_todel;
alter table dwh.bi_delivery_time_report_agg_tmp rename to bi_delivery_time_report_agg;
drop table dwh.bi_delivery_time_report_agg_todel;

create index bi_delivery_time_report_agg_idx on dwh.bi_delivery_time_report_agg (ord_date, buyer_name, supplier_city);

select
 ord_number
,ord_date
,ord_delivery_date
,recadv_date
,recadv_reception_date
,round(coalesce(recadv_reception_date,current_date)-ord_delivery_date,2) order_delivery_delay
    from dwh.bi_delivery_time_report_agg ord
		where ord_date between ${par_dt_from} and ${par_dt_to}
			and supplier_name = ${par_supplier}
			and supplier_city = ${par_city}
order by ord_date

--drop table dwh.rep_delivery_time_cityes;
--create table dwh.rep_delivery_time_cityes
--as
--select distinct dc.region_name supplier_region, gln1.varcityregexp supplier_city, gln2.varname buyer_name, ord_date, ord. supplier_name
--    from dwh.bi_doc_order_agg ord
--    	inner join dwh.stg_gln gln1
--    		on ord.ord_supplier_gln=gln1.vargln
--    	inner join dwh.stg_gln gln2
--    		on ord.ord_buyer_gln=gln2.vargln
--    	inner join dwh.dim_city dc
--    		on gln1.varcityregexp=dc.city_name
--order by 1;

drop table dwh.rep_delivery_time_cityes_new;
create table dwh.rep_delivery_time_cityes_new
as
select distinct supplier_name, buyer_name, supplier_city, ord_date
	from dwh.bi_delivery_time_report_agg;

drop table dwh.rep_delivery_time_regions;
create table dwh.rep_delivery_time_regions
as
select distinct dc.region_name supplier_region, a2.varcompanyname buyer_name, ord_date
    from dwh.bi_doc_order_agg ord
    	inner join dwh.stg_gln gln1
    		on ord.ord_supplier_gln=gln1.vargln
    	inner join dwh.stg_gln gln2
    		on ord.ord_buyer_gln=gln2.vargln
    	inner join dwh.dim_city dc
    		on gln1.varcityregexp=dc.city_name
    	inner join dwh.stg_account a1
    		on a1.intaccountid=gln1.intaccountid
    	inner join dwh.stg_account a2
    		on a2.intaccountid=gln2.intaccountid
order by 1;

drop table dwh.rep_delivery_time_buyers;
create table dwh.rep_delivery_time_buyers
as
select distinct a1.varcompanyname buyer_name, ord_date
    from dwh.bi_doc_order_agg ord
        inner join dwh.stg_gln gln1
    		on ord.ord_buyer_gln=gln1.vargln
    	inner join dwh.stg_account a1
    		on a1.intaccountid=gln1.intaccountid
		where ord.ord_date between '2018-01-01' and '2018-04-01'
order by a1.varcompanyname;

drop table dwh.rep_delivery_time_suppliers;
create table dwh.rep_delivery_time_suppliers
as
select distinct supplier_name, ord_date
    from dwh.bi_delivery_time_report_agg ord
		where ord.ord_date between '2018-01-01' and '2018-04-01';
	