--buyerRegOrdCountGraphSql
select
 region_name
,supplier_name
,count(1) orders_count
    from dwh.bi_orders_dm_clean dm
		where ord_date between ${par_dt_from} and ${par_dt_to}
			and ord_status = 'Заказ подтвержден'
group by region_name, supplier_name
order by 2;

--buyerRegOrdSumGraphSql
select
 region_name
,supplier_name
,round(sum(ord_amount_order_calc),2)/1000 ord_amount_req_calc
    from dwh.bi_orders_dm_clean dm
		where ord_date between ${par_dt_from} and ${par_dt_to}
			and ord_status = 'Заказ подтвержден'
group by region_name, supplier_name
order by 2;

--buyerSupplOrdShortageCntSql
select supplier_name
,round(sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then 1 else 0 end)::numeric / count(1)::numeric * 100,2) ord_shortage_prc
	from dwh.bi_orders_dm_clean
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
group by supplier_name
order by 1;

--buyerSupplOrdShortageSumSql
select supplier_name
,sum(case
		when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0)
			then ord_amount_order_calc - coalesce(ord_amount_recadv_calc,0)
			else 0
	 end) / sum(ord_amount_order_calc) * 100 ord_shortage_prc
	from dwh.bi_orders_dm_clean
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
group by supplier_name
order by 1;

--ordShortageCntGraphSql
select ord_date
,sum(case when ord_amount_order_calc = coalesce(ord_amount_recadv_calc,0) then 1 else 0 end) orders_without_shortage_cnt
,sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then 1 else 0 end) orders_with_shortage_cnt
	from dwh.bi_orders_dm_clean
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
			and supplier_name = ${par_supplier}
			and region_name = ${par_region}
group by ord_date
order by 1;

--ordShortageSumGraphSql
select ord_date
,round(sum(case when ord_amount_order_calc = coalesce(ord_amount_recadv_calc,0) then ord_amount_order_calc else 0 end),2) orders_without_shortage_amount
,round(sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then ord_amount_order_calc - coalesce(ord_amount_recadv_calc,0) else 0 end),2) orders_with_shortage_amount
	from dwh.bi_orders_dm_clean
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
			and supplier_name = ${par_supplier}
			and region_name = ${par_region}
group by ord_date
order by 1;

--ordStatusGraphSql
select 'Кол-во' as "metric", 'Вовремя' as "measure", sum(case when ord_delivery_status='Доставлен в срок' then 1 else 0 end) as "value"
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}	
union all
select 'Кол-во', 'Задержка', sum(case when ord_delivery_status='Доставлен c опозданием' then 1 else 0 end)
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
union all
select 'Кол-во', 'Опережение',sum(case when ord_delivery_status='Доставлен раньше' then 1 else 0 end) 
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
union all
select 'Кол-во', 'Не доставлено',sum(case when ord_delivery_status='Не доставлен' then 1 else 0 end)
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
			and ord_status = 'Заказ подтвержден'
union all
select 'Сумма', 'Вовремя', sum(case when ord_delivery_status='Доставлен в срок' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
union all
select 'Сумма', 'Задержка', sum(case when ord_delivery_status='Доставлен c опозданием' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
union all
select 'Сумма', 'Опережение',sum(case when ord_delivery_status='Доставлен раньше' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
union all
select 'Сумма', 'Не доставлено',sum(case when ord_delivery_status='Не доставлен' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean dm
        where dm.ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
			and region_name = ${par_region}
			and ord_status = 'Заказ подтвержден'
;

--docTypeCorrelationSql
select
'order' doc_type
,supplier_name
,count(1) orders_count
    from dwh.bi_orders_dm_clean
        where ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier} 
group by supplier_name
union all
select
'ordrsp' doc_type
,supplier_name
,count(1) orders_with_ordrsp_count
    from dwh.bi_orders_dm_clean
        where ord_date between ${par_dt_from} and ${par_dt_to}
            and supplier_name = ${par_supplier}
            and ordrsp_date is not null
group by supplier_name
union all
select
'desadv' doc_type
,supplier_name
,count(1) orders_with_desadv_count
	from dwh.bi_orders_dm_clean
        where ord_date between ${par_dt_from} and ${par_dt_to}
        	and supplier_name = ${par_supplier}
        	and desadv_delivery_date is not null
group by supplier_name
union all
select
'recadv' doc_type
,supplier_name
,count(1) orders_with_recadv_count
	from dwh.bi_orders_dm_clean
        where ord_date between ${par_dt_from} and ${par_dt_to}
        	and supplier_name = ${par_supplier}
        	and recadv_reception_date is not null
group by supplier_name;

--ordReactionTimeGraphSql
select ord_date
,max(order_reaction_interval) order_reaction_interval
    from (
		select ord_date
		,round((extract(day from avg(least(order_reaction_interval,desadv_order_delivery_delay)))*24+
		 extract(hour from avg(least(order_reaction_interval,desadv_order_delivery_delay)))+
		 extract(minute from avg(least(order_reaction_interval,desadv_order_delivery_delay)))/60+
		 extract(second from avg(least(order_reaction_interval,desadv_order_delivery_delay)))/60/60)::numeric,2) order_reaction_interval
			from dwh.bi_orders_dm_clean
				where ord_status = 'Заказ подтвержден'
					and ord_date between ${par_dt_from} and ${par_dt_to}
					and supplier_name = ${par_supplier}
					and region_name = ${par_region}
		group by ord_date
		union all
		select date_actual
		,0
			from dwh.dim_date
				where date_actual between ${par_dt_from} and ${par_dt_to}
		) sq
group by ord_date
order by ord_date
limit 15;

--ordDeliveryDelayTimeGraphSql
select ord_date
,max(recadv_order_delivery_delay_avg) recadv_order_delivery_delay_avg
    from (
		select ord_date
		,round((extract(day from avg(recadv_order_delivery_delay))*24+
		 extract(hour from avg(recadv_order_delivery_delay))+
		 extract(minute from avg(recadv_order_delivery_delay))/60+
		 extract(second from avg(recadv_order_delivery_delay))/60/60)::numeric,2) recadv_order_delivery_delay_avg
			from dwh.bi_orders_dm_clean
				where ord_status = 'Заказ подтвержден'
					and ord_date between ${par_dt_from} and ${par_dt_to}
					and supplier_name = ${par_supplier}
					and region_name = ${par_region}
		group by ord_date
		union all
		select date_actual
		,0
			from dwh.dim_date
				where date_actual between ${par_dt_from} and ${par_dt_to}
		) sq
group by ord_date
order by ord_date
limit 15;

--Витрина по kpi
drop table dwh.bi_orders_dm_kpi_clean;
create table dwh.bi_orders_dm_kpi_clean
as
select 
 supplier_name
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
			,ord_delivery_status
			,ord_status
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
group by 1,2
order by 2,3 desc;

--ordSupplierKpiChartSql
select
 supplier_product_family
,supplier_name
,supplier_kpi_prc
,supplier_shortage_kpi_prc
,supplier_delivery_delay_kpi_prc
    from dwh.bi_orders_dm_kpi_clean
order by 1,3 desc;

--ordSupplierKpiTabSql
select
 supplier_product_family
,supplier_name
,pos_amount_order_calc
,supplier_shortage_penalty
,supplier_delivery_delay_penalty
,supplier_kpi_prc
,supplier_shortage_kpi_prc
,supplier_delivery_delay_kpi_prc
    from dwh.bi_orders_dm_kpi_clean
order by supplier_product_family, supplier_kpi_prc desc;


--Детализация до заказов
--detailTabSql
select ord_number, supplier_city
,case
	when coalesce(ord_amount_order_calc,-1) <> coalesce(ord_amount_recadv_calc,0) then 'Недопоставка'
	when coalesce(ord_amount_order_calc,-1) = coalesce(ord_amount_recadv_calc,0) then 'Поставка в полном объеме'
 end ord_amount_status
,ord_delivery_status
,ord_delivery_date, ord_latest_delivery_date
,ord_amount_order_calc, ord_amount_ordrsp_calc, ord_amount_desadv_calc, ord_amount_recadv_calc
,ordrsp_date, desadv_delivery_date, recadv_reception_date
    from dwh.bi_orders_dm_clean
        where supplier_name = ${par_supplier}
            and ord_date = ${par_dt}
            and region_name = ${par_region}
            and ord_status = 'Заказ подтвержден'
    		and recadv_reception_date is not null;

--Детализация до позиций
--detailPosTabSql
select o.pos_product_num, o.pos_description
,case
	when coalesce(pos_amount_order_calc,-1) <> coalesce(pos_amount_recadv_calc,0) then 'Недопоставка'
	when coalesce(pos_amount_order_calc,-1) = coalesce(pos_amount_recadv_calc,0) then 'Поставка в полном объеме'
 end pos_amount_status
,o.pos_amount_order_calc, pos_orderedquantity::varchar||' '||u.unit_name pos_orderedquantity
,o.pos_amount_recadv_calc, recadv_pos_acceptedquantity::varchar||' '||u.unit_name recadv_pos_acceptedquantity
	from dwh.bi_order_position_dm_clean o
		left join dwh.dim_units u
			on o.unit_id=u.unit_id
		where supplier_name = ${par_supplier}
            and ord_date = ${par_dt}
            and region_name = ${par_region}
            and ord_number = ${par_ord_num}
order by o.pos_product_num;