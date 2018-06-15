create table bi_recadv_position_trans
as
select op.*, g.intaccountid
	from dwh.bi_recadv_position op
		inner join dwh.stg_gln g
			on g.vargln=op.recadv_byer_gln
			or g.vargln=op.recadv_supplier_gln;
			
--select * from bi_recadv_position_trans;

--drop index bi_recadv_position_trans_idx1;
create index bi_recadv_position_trans_idx1 on bi_recadv_position_trans (recadv_ord_number,recadv_supplier_gln,recadv_byer_gln,recadv_pos_number);
create index bi_recadv_position_trans_idx2 on bi_recadv_position_trans (recadv_ord_number,recadv_pos_number);
create index bi_recadv_position_trans_idx3 on bi_recadv_position_trans (doc_chain_id);

analyze verbose bi_recadv_position_trans;