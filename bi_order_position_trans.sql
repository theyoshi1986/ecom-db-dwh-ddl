create table bi_order_position_trans
as
select op.*, g.intaccountid
	from dwh.bi_order_position op
		inner join dwh.stg_gln g
			on g.vargln=op.ord_supplier_gln
			or g.vargln=op.ord_byer_gln;
			
select * from bi_order_position_trans;

create index bi_order_position_trans_idx1 on bi_order_position_trans (ord_date);
create index bi_order_position_trans_idx2 on bi_order_position_trans (ord_number,ord_date,pos_number);

analyze verbose bi_order_position_trans;
