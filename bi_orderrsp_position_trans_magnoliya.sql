create table dwh.bi_orderrsp_position_trans_magnoliya
as
select op.*
	from dwh.bi_orderrsp_position_trans_x5 op
		where 1=0;

--select * from dwh.bi_orderrsp_position_trans_magnoliya;
			
create index bi_orderrsp_position_trans_magnoliya_idx1 on dwh.bi_orderrsp_position_trans_magnoliya (ordrsp_ord_date, ordrsp_buyer_gln, ordrsp_supplier_gln, ordrsp_pos_number);
create index bi_orderrsp_position_trans_magnoliya_idx2 on dwh.bi_orderrsp_position_trans_magnoliya (doc_chain_id);

analyze verbose dwh.bi_orderrsp_position_trans_magnoliya;
