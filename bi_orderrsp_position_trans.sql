create table bi_orderrsp_position_trans
as
select op.*, g.intaccountid
	from dwh.bi_orderrsp_position op
		inner join dwh.stg_gln g
			on g.vargln=op.ordrsp_supplier_gln
			or g.vargln=op.ordrsp_byer_gln;
			
--select * from bi_orderrsp_position_trans;
--drop index bi_orderrsp_position_trans_idx1;
create index bi_orderrsp_position_trans_idx1 on bi_orderrsp_position_trans (ordrsp_ord_date,ordrsp_byer_gln,ordrsp_supplier_gln,ordrsp_pos_number);
create index bi_orderrsp_position_trans_idx2 on bi_orderrsp_position_trans (doc_chain_id);

analyze verbose bi_orderrsp_position_trans;