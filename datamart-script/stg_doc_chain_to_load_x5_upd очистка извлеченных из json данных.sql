--Уникальные строки позиций УПД + очистка и стандартизация
drop table dwh.bi_upd_position_clean_x5;
create table dwh.bi_upd_position_clean_x5
as
select *
	from (
		select 
		 row_number() over (partition by coalesce(upd_order_number, upd_pos_order_number)
		 								,coalesce(upd_order_date,date'1000-01-01')
		 								,coalesce(upd_sender_gln, gS.vargln, -1)
		 								,coalesce(upd_recipient_gln, gR.vargln, -1)
		 								,upd_pos_product_num 
		 								 order by upd_date desc) rn
		,intdocid
		,intchainid
		,upd_number
		,upd_date
		,upd_knd
		,upd_type
		,upd_creator
		,upd_sender, upd_recipient, upd_id_sender, upd_id_receiver
		,coalesce(upd_order_number, upd_pos_order_number) upd_order_number
		,upd_order_date
		,coalesce(upd_sender_gln, gS.vargln) upd_sender_gln
		,coalesce(upd_recipient_gln, gR.vargln) upd_recipient_gln
		,upd_file_create_date||replace(upd_file_create_time,'.',':') upd_file_create_timestamp
		,upd_pos_number
		,upd_pos_description
		,u.unit_id upd_pos_unit_id
		,case 
			when upd_pos_amount_no_vat > 0
				then upd_pos_amount_no_vat
			when (upd_pos_amount_no_vat is null or upd_pos_amount_no_vat = 0) and upd_pos_unit_price_no_vat is not null and upd_pos_quantity is not null
				then upd_pos_unit_price_no_vat * upd_pos_quantity
			when upd_pos_amount_no_vat is null and upd_pos_unit_price_no_vat is null and upd_pos_amount_with_vat is not null
				then upd_pos_amount_with_vat / (1 + coalesce(upd_pos_vat,10) / 100)
		 end upd_pos_amount_no_vat
		,case 
			when upd_pos_amount_with_vat > 0
				then upd_pos_amount_with_vat 
			when (upd_pos_amount_with_vat is null or upd_pos_amount_with_vat = 0) and upd_pos_unit_price_no_vat is not null and upd_pos_quantity is not null
				then upd_pos_unit_price_no_vat * upd_pos_quantity * (1 + coalesce(upd_pos_vat,10) / 100)
		 end upd_pos_amount_with_vat
		,upd_pos_product_num
		,upd_pos_quantity
		,upd_pos_unit_price_no_vat
		,coalesce(upd_pos_vat,10) upd_pos_vat
			from dwh.bi_upd_position_trans_x5 trn
				inner join dwh.dim_units u
					on u.unit_code_okei=(trn.upd_pos_unit_code)::varchar
				left join dwh.stg_gln2sos sS
					on sS.varguid=trn.upd_sender
				left join dwh.stg_gln gS
					on gs.intglnid=sS.intglnid
				left join dwh.stg_gln2sos sR
					on sR.varguid=trn.upd_recipient
				left join dwh.stg_gln gR
					on gR.intglnid=sR.intglnid) sq
where rn=1
	and upd_pos_amount_no_vat is not null
order by upd_order_number, upd_order_date, upd_sender_gln, upd_recipient_gln;

analyze verbose bi_upd_position_clean_x5;

--Очищенные УПД
drop table dwh.bi_upd_clean_x5;
create table dwh.bi_upd_clean_x5
as
select 
 intdocid
,intchainid
,upd_number
,upd_date
,upd_knd
,upd_type
,upd_creator
,upd_sender
,upd_recipient
,upd_id_sender
,upd_id_receiver
,upd_order_number
,upd_order_date
,upd_sender_gln
,upd_recipient_gln
,upd_file_create_timestamp
,sum(upd_pos_amount_no_vat) upd_amount_no_vat
,sum(upd_pos_amount_with_vat) upd_amount_with_vat
,upd_pos_vat
	from dwh.bi_upd_position_clean_x5
group by intdocid
,intchainid
,upd_number
,upd_date
,upd_knd
,upd_type
,upd_creator
,upd_sender
,upd_recipient
,upd_id_sender
,upd_id_receiver
,upd_order_number
,upd_order_date
,upd_sender_gln
,upd_recipient_gln
,upd_file_create_timestamp
,upd_pos_vat
order by upd_order_number, upd_order_date, upd_sender_gln, upd_recipient_gln;

analyze verbose dwh.bi_upd_clean_x5;

--drop table dwh.bi_upd_dm_x5;
create table dwh.bi_upd_dm_x5
as
select 
 intchainid
,upd_number
,upd_date
,upd_knd
,upd_type
,upd_creator
,upd_sender
,upd_recipient
,upd_id_sender
,upd_id_receiver
,upd_order_number
,upd_order_date
,upd_sender_gln
,upd_recipient_gln
,max(upd_file_create_timestamp) upd_file_create_timestamp_max
,sum(upd_amount_no_vat) upd_amount_no_vat
,sum(upd_amount_with_vat) upd_amount_with_vat
,upd_pos_vat
	from dwh.bi_upd_clean_x5
group by intchainid
,upd_number
,upd_date
,upd_knd
,upd_type
,upd_creator
,upd_sender
,upd_recipient
,upd_id_sender
,upd_id_receiver
,upd_order_number
,upd_order_date
,upd_sender_gln
,upd_recipient_gln
,upd_pos_vat
order by upd_order_number, upd_order_date, upd_sender_gln, upd_recipient_gln;

analyze verbose bi_upd_clean_x5;