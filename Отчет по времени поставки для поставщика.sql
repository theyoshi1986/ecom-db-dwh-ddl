--buyerRegOrdCountGraphSql
select
 dm.region_name
,extract(year from ord_date)||'-'||right('0'||(extract(month from ord_date))::varchar,2) mnth
,count(1) orders_count
    from dwh.bi_orders_dm_clean_molvest dm
		where ord_date between ${par_dt_from} and ${par_dt_to}
			and ord_status = 'Заказ подтвержден'
group by 1,2
order by 2;

--buyerRegOrdSumGraphSql
select
 dm.region_name
,extract(year from ord_date)||'-'||right('0'||(extract(month from ord_date))::varchar,2) mnth
,round(sum(ord_amount_order_calc),2)/1000 ord_amount_req_calc
    from dwh.bi_orders_dm_clean_molvest dm
		where ord_date between ${par_dt_from} and ${par_dt_to}
			and ord_status = 'Заказ подтвержден'
group by 1,2
order by 2;

--buyerSupplOrdShortageCntSql
select
 extract(year from ord_date)||'-'||right('0'||(extract(month from ord_date))::varchar,2) mnth
,round(sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then 1 else 0 end)::numeric / count(1)::numeric * 100,2) ord_shortage_prc
	from dwh.bi_orders_dm_clean_molvest
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
group by 1
order by 1;

--buyerSupplOrdShortageSumSql
select extract(year from ord_date)||'-'||right('0'||(extract(month from ord_date))::varchar,2) mnth
,sum(case
		when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0)
			then ord_amount_order_calc - coalesce(ord_amount_recadv_calc,0)
			else 0
	 end) / sum(ord_amount_order_calc) * 100 ord_shortage_prc
	from dwh.bi_orders_dm_clean_molvest
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and ord_date between ${par_dt_from} and ${par_dt_to}
group by 1
order by 1;

--ordShortageCntGraphSql
select ord_date
,sum(case when ord_amount_order_calc = coalesce(ord_amount_recadv_calc,0) then 1 else 0 end) orders_without_shortage_cnt
,sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then 1 else 0 end) orders_with_shortage_cnt
	from dwh.bi_orders_dm_clean_molvest
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
				or ${par_year_month} = '1000-01')
			and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by ord_date
order by 1;

--ordShortageSumGraphSql
select ord_date
,round(sum(case when ord_amount_order_calc = coalesce(ord_amount_recadv_calc,0) then ord_amount_order_calc else 0 end),2) orders_without_shortage_amount
,round(sum(case when ord_amount_order_calc <> coalesce(ord_amount_recadv_calc,0) then ord_amount_order_calc - coalesce(ord_amount_recadv_calc,0) else 0 end),2) orders_with_shortage_amount
	from dwh.bi_orders_dm_clean_molvest
		where ord_status = 'Заказ подтвержден'
			and recadv_reception_date is not null
			and (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
				or ${par_year_month} = '1000-01')
			and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by ord_date
order by 1;

--ordStatusGraphSql
select 'Кол-во' as "metric", 'Вовремя' as "measure", sum(case when ord_delivery_status='Доставлен в срок' then 1 else 0 end) as "value"
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Кол-во', 'Задержка', sum(case when ord_delivery_status='Доставлен c опозданием' then 1 else 0 end)
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Кол-во', 'Опережение',sum(case when ord_delivery_status='Доставлен раньше' then 1 else 0 end) 
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Кол-во', 'Не доставлено',sum(case when ord_delivery_status='Не доставлен' then 1 else 0 end)
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
			and ord_status = 'Заказ подтвержден'
union all
select 'Сумма', 'Вовремя', sum(case when ord_delivery_status='Доставлен в срок' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Сумма', 'Задержка', sum(case when ord_delivery_status='Доставлен c опозданием' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Сумма', 'Опережение',sum(case when ord_delivery_status='Доставлен раньше' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
union all
select 'Сумма', 'Не доставлено',sum(case when ord_delivery_status='Не доставлен' then ord_amount_order_calc else 0 end)/1000
    from dwh.bi_orders_dm_clean_molvest dm
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
			and ord_status = 'Заказ подтвержден'
;

--docTypeCorrelationSql
select
'order' doc_type
,supplier_name
,count(1) orders_count
    from dwh.bi_orders_dm_clean_molvest
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
            	or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
        	and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by supplier_name
union all
select
'ordrsp' doc_type
,supplier_name
,count(1) orders_with_ordrsp_count
    from dwh.bi_orders_dm_clean_molvest
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
            and ordrsp_date is not null
            and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by supplier_name
union all
select
'desadv' doc_type
,supplier_name
,count(1) orders_with_desadv_count
	from dwh.bi_orders_dm_clean_molvest
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
        		or ${par_year_month} = '1000-01')
        	and ord_date between ${par_dt_from} and ${par_dt_to}
        	and desadv_delivery_date is not null
        	and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by supplier_name
union all
select
'recadv' doc_type
,supplier_name
,count(1) orders_with_recadv_count
	from dwh.bi_orders_dm_clean_molvest
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
				or ${par_year_month} = '1000-01')
			and ord_date between ${par_dt_from} and ${par_dt_to}
        	and recadv_reception_date is not null
        	and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
group by supplier_name
union all
select
'СЧФДОП' doc_type
,supplier_name
,count(1) orders_with_recadv_count
    from dwh.bi_orders_dm_clean_molvest ord
		inner join dwh.bi_upd_dm_molvest upd
			on ord.ord_number=upd.upd_order_number
		   and (ord.ord_date=upd.upd_order_date
		   	or upd.upd_order_date is null)
		   and ord.ord_buyer_gln=upd.upd_recipient_gln
		   and ord.ord_supplier_gln=upd.upd_sender_gln
        where (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
				or ${par_year_month} = '1000-01')
			and ord_date between ${par_dt_from} and ${par_dt_to}
        	and recadv_reception_date is not null
        	and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
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
			from dwh.bi_orders_dm_clean_molvest
				where ord_status = 'Заказ подтвержден'
					and (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
						or ${par_year_month} = '1000-01')
					and ord_date between ${par_dt_from} and ${par_dt_to}
					and (region_name = ${par_region}
                		or ${par_region} = 'Все регионы')
		group by ord_date
		union all
		select date_actual
		,0
			from dwh.dim_date
				where (date_actual between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
						or ${par_year_month} = '1000-01')
					and date_actual between ${par_dt_from} and ${par_dt_to}
		) sq
group by ord_date
order by ord_date;

--ordDeliveryDelayTimeGraphSql
select ord_date
,max(recadv_order_delivery_delay_avg) recadv_order_delivery_delay_avg
    from (
		select ord_date
		,round((extract(day from avg(recadv_order_delivery_delay))*24+
		 extract(hour from avg(recadv_order_delivery_delay))+
		 extract(minute from avg(recadv_order_delivery_delay))/60+
		 extract(second from avg(recadv_order_delivery_delay))/60/60)::numeric,2) recadv_order_delivery_delay_avg
			from dwh.bi_orders_dm_clean_molvest
				where ord_status = 'Заказ подтвержден'
					and (ord_date between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
						or ${par_year_month} = '1000-01')
					and ord_date between ${par_dt_from} and ${par_dt_to}
					and (region_name = ${par_region}
                		or ${par_region} = 'Все регионы')
		group by ord_date
		union all
		select date_actual
		,0
			from dwh.dim_date
				where (date_actual between (${par_year_month}||'-01')::date and (${par_year_month}||'-01')::date + interval '1' month - interval '1' day
						or ${par_year_month} = '1000-01')
					and date_actual between ${par_dt_from} and ${par_dt_to}
		) sq
group by ord_date
order by ord_date;


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
    from dwh.bi_orders_dm_clean_molvest
        where ord_date = ${par_dt}
			and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
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
	from dwh.bi_order_position_dm_clean_molvest o
		left join dwh.dim_units u
			on o.unit_id=u.unit_id
		where ord_date = ${par_dt}
            and (region_name = ${par_region}
                or ${par_region} = 'Все регионы')
            and ord_number = ${par_ord_num}
order by o.pos_product_num;