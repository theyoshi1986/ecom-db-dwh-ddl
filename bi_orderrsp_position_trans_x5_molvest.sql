create table bi_orderrsp_position_trans_x5_molvest
as
select op.*
	from dwh.bi_orderrsp_position_trans_x5 op
		where 1=0;
			
create index bi_orderrsp_position_trans_x5_molvest_idx1 on bi_orderrsp_position_trans_x5_molvest (ordrsp_ord_date,ordrsp_byer_gln,ordrsp_supplier_gln,ordrsp_pos_number);
create index bi_orderrsp_position_trans_x5_molvest_idx2 on bi_orderrsp_position_trans_x5_molvest (doc_chain_id);

analyze verbose bi_orderrsp_position_trans_x5_molvest;
