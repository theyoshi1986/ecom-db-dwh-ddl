create table dwh.bi_order_position_trans_bread
as
select *
	from dwh.bi_order_position_trans_x5
		where 1=0;
			
--select * from bi_order_position_x5;

create index bi_order_position_trans_bread_idx1 on dwh.bi_order_position_trans_bread (ord_date);
create index bi_order_position_trans_bread_idx2 on dwh.bi_order_position_trans_bread (ord_number,ord_date,pos_number);

analyze verbose dwh.bi_order_position_trans_bread;