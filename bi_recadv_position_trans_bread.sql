create table dwh.bi_recadv_position_trans_bread
as
select op.*
	from dwh.bi_recadv_position_trans_x5 op
		where 1=0;
			
--select * from bi_recadv_position_trans_bread;

create index bi_recadv_position_trans_bread_idx1 on dwh.bi_recadv_position_trans_bread (recadv_ord_number,recadv_supplier_gln, recadv_buyer_gln, recadv_pos_number);
create index bi_recadv_position_trans_bread_idx3 on dwh.bi_recadv_position_trans_bread (doc_chain_id);

analyze verbose dwh.bi_recadv_position_trans_bread;