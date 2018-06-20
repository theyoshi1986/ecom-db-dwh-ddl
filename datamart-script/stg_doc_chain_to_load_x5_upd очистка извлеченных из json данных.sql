--Уникальные строки позиций УПД + очистка и стандартизация
drop table dwh.bi_upd_position_clean_x5_trn0;
create table dwh.bi_upd_position_clean_x5_trn0
as
select
 intdocid
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
,(upd_file_create_date||' '||replace(upd_file_create_time,'.',':'))::timestamp upd_file_create_timestamp
,upd_pos_number
,upd_pos_description
,u.unit_id upd_pos_unit_id
,case 
	when upd_pos_amount_no_vat > 0
		then upd_pos_amount_no_vat
	when (upd_pos_amount_no_vat is null or upd_pos_amount_no_vat = 0) and upd_pos_unit_price_no_vat is not null and upd_pos_quantity is not null
		then upd_pos_unit_price_no_vat * upd_pos_quantity
	when upd_pos_amount_no_vat is null and upd_pos_unit_price_no_vat is null and upd_pos_amount_with_vat is not null
		then upd_pos_amount_with_vat / (1 + coalesce(upd_pos_vat,0) / 100)
 end upd_pos_amount_no_vat
,case 
	when upd_pos_amount_with_vat > 0
		then upd_pos_amount_with_vat 
	when (upd_pos_amount_with_vat is null or upd_pos_amount_with_vat = 0) and upd_pos_unit_price_no_vat is not null and upd_pos_quantity is not null
		then upd_pos_unit_price_no_vat * upd_pos_quantity * (1 + coalesce(upd_pos_vat,0) / 100)
 end upd_pos_amount_with_vat
,upd_pos_product_num
,upd_pos_quantity
,upd_pos_unit_price_no_vat
,coalesce(upd_pos_vat,0) upd_pos_vat
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
			on gR.intglnid=sR.intglnid
		inner join dwh.stg_gln g1
			on g1.vargln=coalesce(upd_sender_gln, gS.vargln)
		inner join dwh.stg_account a1
			on a1.intaccountid=g1.intaccountid
	where a1.varcompanyname in ('Молвест','ТД Айсберри','Самарский хлебозавод №5','СМАК','Карат Плюс','Компания "Хлебный Дом','Гуковская М.Ю.','ХЛЕБ','ТОРГОВАЯ КОМПАНИЯ','Каравай','Княгининское молоко','Зеленодольский хлебокомбинат');

create index bi_upd_position_clean_x5_trn0_idx2 on dwh.bi_upd_position_clean_x5_trn0 (intdocid);
analyze verbose bi_upd_position_clean_x5_trn0;

drop table dwh.bi_upd_position_clean_x5;
create table dwh.bi_upd_position_clean_x5
as
select *
	from (select
			 row_number() over (partition by upd_order_number
			 								,coalesce(upd_order_date,date'1000-01-01')
			 								,upd_sender_gln
			 								,upd_recipient_gln
			 								,upd_pos_product_num
			 						order by upd_date desc
			 							 	,upd_pos_amount_no_vat desc
			 							 	,upd_pos_amount_with_vat desc
			 							 	,upd_pos_vat desc) rn
			,intdocid
			,intchainid
			,upd_number
			,upd_date
			,upd_knd
			,upd_type
			,upd_creator
			,upd_sender, upd_recipient, upd_id_sender, upd_id_receiver
			,upd_order_number
			,upd_order_date
			,upd_sender_gln
			,upd_recipient_gln
			,upd_file_create_timestamp
			,upd_pos_number
			,upd_pos_description
			,upd_pos_unit_id
			,upd_pos_amount_no_vat
			,upd_pos_amount_with_vat
			,upd_pos_product_num
			,upd_pos_quantity
			,upd_pos_unit_price_no_vat
			,upd_pos_vat
				from dwh.bi_upd_position_clean_x5_trn0 trn) sq
					where rn=1
						and coalesce(upd_pos_amount_no_vat,-1) <> 0;

--create index bi_upd_position_clean_x5_idx1 on dwh.bi_upd_position_clean_x5 (upd_pos_vat);
create index bi_upd_position_clean_x5_idx2 on dwh.bi_upd_position_clean_x5 (intdocid);
--create index bi_upd_position_clean_x5_idx3 on dwh.bi_upd_position_clean_x5 (intchainid);

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
--,upd_pos_vat
	from dwh.bi_upd_position_clean_x5
		where upd_pos_product_num not in (935,3354748)
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
--,upd_pos_vat
;

analyze verbose dwh.bi_upd_clean_x5;

drop table dwh.bi_upd_dm_x5;
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
--,upd_pos_vat
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
--,upd_pos_vat
order by upd_order_number, upd_order_date, upd_sender_gln, upd_recipient_gln;

analyze verbose bi_upd_clean_x5;