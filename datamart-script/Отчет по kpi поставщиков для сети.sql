--Витрина по kpi поставщиков для сети

drop table dwh.bi_orders_dm_kpi_by_month_clean;
create table dwh.bi_orders_dm_kpi_by_month_clean
as
select 
 (extract(year from sq.ord_date)::varchar||'-'||right('0'||extract(month from sq.ord_date),2))::varchar kpi_year_month
,supplier_name
,group_name supplier_product_family
--,ord_delivery_status
--,count(1) ord_cnt
,round(sum(pos_amount_order_calc),2) pos_amount_order_calc
--,round(sum(pos_amount_recadv_calc),2) pos_amount_recadv_calc
--,round(sum(pos_amount_order_calc),2)-round(sum(pos_amount_recadv_calc),2) ord_shortage
,round(sum(supplier_shortage_penalty),2) supplier_shortage_penalty
,round(sum(supplier_delivery_delay_penalty),2) supplier_delivery_delay_penalty
,round((1-(sum(supplier_delivery_delay_penalty)+sum(supplier_shortage_penalty))/sum(pos_amount_order_calc))*100,2) supplier_kpi_prc
,round((1-sum(supplier_shortage_penalty)/sum(pos_amount_order_calc))*100,2) supplier_shortage_kpi_prc
,round((1-sum(supplier_delivery_delay_penalty)/sum(pos_amount_order_calc))*100,2) supplier_delivery_delay_kpi_prc
    from (select
-- 			 supplier_product_family
			 pos.group_name
			,pos.supplier_name
--			,ord_delivery_status
			,ord_status
			,ord.ord_date
--			,ord_amount_order_calc
			,pos.pos_amount_order_calc
--			,ord_amount_recadv_calc
			,pos.pos_amount_recadv_calc
--			,round((1-(ord_amount_order_calc-ord_amount_recadv_calc)/ord_amount_order_calc)*100) ord_completeness_prc
			,case
				when round((1-(ord_amount_order_calc-ord_amount_recadv_calc)/ord_amount_order_calc)*100) < 95
				then (pos.pos_amount_order_calc-pos.pos_amount_recadv_calc)*.1
				else 0
			 end supplier_shortage_penalty
			,case 
				when ord_delivery_status in ('Доставлен c опозданием','Доставлен раньше')
				then pos.pos_amount_order_calc*.1
				else 0
			 end supplier_delivery_delay_penalty
				from dwh.bi_orders_dm_clean ord
					inner join dwh.bi_order_position_dm_clean pos
						 on pos.ord_supplier_gln=ord.ord_supplier_gln
						and pos.ord_date=ord.ord_date
						and pos.region_name=ord.region_name
						and pos.ord_number=ord.ord_number
					where ord_delivery_status in ('Доставлен c опозданием','Доставлен в срок','Доставлен раньше')
                        and group_name is not null) sq	
group by 1,2,3
order by 3,7 desc;

--Добавляем левых данных
alter table dwh.bi_orders_dm_kpi_by_month_clean add synth varchar(5);

--delete from dwh.bi_orders_dm_kpi_by_month_clean where synth = 'yes';
--select * from dwh.bi_orders_dm_kpi_by_month_clean;

insert into dwh.bi_orders_dm_kpi_by_month_clean
select
 (extract(year from ((kpi_year_month||'-01')::date - interval'1 month')::date)::varchar||'-'||right('0'||extract(month from ((kpi_year_month||'-01')::date - interval'1 month')::date),2))::varchar kpi_year_month 
,supplier_name
,supplier_product_family
,pos_amount_order_calc
,supplier_shortage_penalty
,supplier_delivery_delay_penalty
,round((supplier_kpi_prc - random())::numeric),2) supplier_kpi_prc
,supplier_shortage_kpi_prc
,supplier_delivery_delay_kpi_prc
,'yes' synth
	from dwh.bi_orders_dm_kpi_by_month_clean)sq;

insert into dwh.bi_orders_dm_kpi_by_month_clean
select
 (extract(year from ((kpi_year_month||'-01')::date - interval'2 month')::date)::varchar||'-'||right('0'||extract(month from ((kpi_year_month||'-01')::date - interval'2 month')::date),2))::varchar kpi_year_month 
,supplier_name
,supplier_product_family
,pos_amount_order_calc
,supplier_shortage_penalty
,supplier_delivery_delay_penalty
,round((supplier_kpi_prc - random())::numeric,2) supplier_kpi_prc
,supplier_shortage_kpi_prc
,supplier_delivery_delay_kpi_prc
,'yes' synth
	from dwh.bi_orders_dm_kpi_by_month_clean
		where synth is null;

--Kpi total dashboard

--parYearMonthSql
select distinct kpi_year_month
    from dwh.bi_orders_dm_kpi_by_month_clean
order by 1;

--totalKpiSql
select (kpi_year_month||'-01')::date kpi_date, round(avg(supplier_kpi_prc),2) kpi_value
    from dwh.bi_orders_dm_kpi_by_month_clean
--        where kpi_year_month=${par_year_month}
group by 1
order by 1;

--Kpi category dashboard
--kpiLastMonthSql
select f.supplier_product_family
,round(avg(supplier_kpi_prc),2) kpi_value
    from dwh.bi_orders_dm_kpi_by_month_clean f
        where kpi_year_month='2017-12'
group by 1
order by 2;

--kpiCategorySql
select (kpi_year_month||'-01')::date kpi_date
,f.supplier_product_family
,round(avg(supplier_kpi_prc),2) kpi_value
    from dwh.bi_orders_dm_kpi_by_month_clean f
--        where kpi_year_month=${par_year_month}
group by 1,2
order by 1,2;

--Kpi supplier dashboard

--kpiLastMonthSql
select 
 supplier_name
,round(supplier_kpi_prc,2) kpi_value
    from dwh.bi_orders_dm_kpi_by_month_clean f
        where supplier_product_family = ${par_category}
        	AND kpi_year_month='2017-12'
order by 2;


--kpiSupplierSql
select 
 (kpi_year_month||'-01')::date kpi_date
,supplier_name
,round(supplier_kpi_prc,2) kpi_value
    from dwh.bi_orders_dm_kpi_by_month_clean f
        where supplier_product_family = ${par_category}
order by 1,3 desc;

--kpiSuplierByDaySql
select 
 sq.ord_date kpi_year_month
,round((1-(sum(supplier_delivery_delay_penalty)+sum(supplier_shortage_penalty))/sum(pos_amount_order_calc))*100,2) supplier_kpi_prc
,round((1-sum(supplier_shortage_penalty)/sum(pos_amount_order_calc))*100,2) supplier_shortage_kpi_prc
,round((1-sum(supplier_delivery_delay_penalty)/sum(pos_amount_order_calc))*100,2) supplier_delivery_delay_kpi_prc
    from (select
--     		 supplier_product_family
			 pos.group_name
			,pos.supplier_name
--			,ord_delivery_status
			,ord_status
			,ord.ord_date
--			,ord_amount_order_calc
			,pos.pos_amount_order_calc
--			,ord_amount_recadv_calc
			,pos.pos_amount_recadv_calc
--			,round((1-(ord_amount_order_calc-ord_amount_recadv_calc)/ord_amount_order_calc)*100) ord_completeness_prc
			,case
				when round((1-(ord_amount_order_calc-ord_amount_recadv_calc)/ord_amount_order_calc)*100) < 95
				then (pos.pos_amount_order_calc-pos.pos_amount_recadv_calc)*.1
				else 0
			 end supplier_shortage_penalty
			,case 
				when ord_delivery_status in ('Доставлен c опозданием','Доставлен раньше')
				then pos.pos_amount_order_calc*.1
				else 0
			 end supplier_delivery_delay_penalty
				from dwh.bi_orders_dm_clean ord
					inner join dwh.bi_order_position_dm_clean pos
						 on pos.ord_supplier_gln=ord.ord_supplier_gln
						and pos.ord_date=ord.ord_date
						and pos.region_name=ord.region_name
						and pos.ord_number=ord.ord_number
					where ord_delivery_status in ('Доставлен c опозданием','Доставлен в срок','Доставлен раньше')
                        and group_name is not null) sq	
where supplier_name='ТОРГОВАЯ КОМПАНИЯ'
    and sq.ord_date between date'2018-01-07' and date'2018-01-24'
group by 1
order by 1
;

