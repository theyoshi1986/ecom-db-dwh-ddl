create table bi_desadv_position_trans
as
select desadv.*
	from dwh.bi_desadv_position desadv
		inner join dwh.bi_order_position_trans ordr
			on ordr.ord_number=desadv.desadv_ord_number
			and ordr.ord_date=desadv.desadv_ord_date
			and ordr.pos_number=desadv.desadv_pos_number;

create index bi_desadv_position_trans_idx1 on bi_desadv_position_trans (desadv_ord_number,desadv_ord_date,desadv_pos_number);
create index bi_desadv_position_trans_idx2 on bi_desadv_position_trans (doc_chain_id);

analyze verbose bi_desadv_position_trans;