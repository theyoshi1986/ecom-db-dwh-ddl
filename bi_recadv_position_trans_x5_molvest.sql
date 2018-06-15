create table dwh.bi_recadv_position_trans_x5_molvest
as
select op.*
	from dwh.bi_recadv_position_trans_x5 op
		where 1=0;
			
--select * from bi_recadv_position_trans;

--drop index bi_recadv_position_trans_idx1;
create index bi_recadv_position_trans_x5_molvest_idx1 on bi_recadv_position_trans_x5_molvest (recadv_ord_number,recadv_supplier_gln,recadv_byer_gln,recadv_pos_number);
create index bi_recadv_position_trans_x5_molvest_idx3 on bi_recadv_position_trans_x5_molvest (doc_chain_id);

analyze verbose bi_recadv_position_trans_x5_molvest;