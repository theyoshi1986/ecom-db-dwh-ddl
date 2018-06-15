create table bi_order_position_trans_x5
as
select op.*
	from dwh.bi_order_position op
		inner join dwh.stg_gln_x5 g
			on g.vargln=op.ord_byer_gln;
			
--select * from bi_order_position_x5;

create index bi_order_position_x5_idx1 on bi_order_position_trans_x5 (ord_date);
create index bi_order_position_x5_idx2 on bi_order_position_trans_x5 (ord_number,ord_date,pos_number);

analyze verbose bi_order_position_trans_x5;

alter table bi_order_position_trans_x5 rename column ord_byer_gln to ord_buyer_gln;
alter table bi_order_position_trans_x5 add ord_version int;
alter table bi_order_position_trans_x5 rename column ord_doc_type to ord_doctype;
