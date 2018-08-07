create table dwh.bi_order_position_trans_magnoliya
as
select *
	from dwh.bi_order_position_trans_x5
		where 1=0;
			
--select * from bi_order_position_x5;

create index bi_order_position_trans_magnoliya_idx1 on bi_order_position_trans_magnoliya (ord_date);
create index bi_order_position_trans_magnoliya_idx2 on bi_order_position_trans_magnoliya (ord_number,ord_date,pos_number);

analyze verbose bi_order_position_trans_magnoliya;