create table dwh.bi_desadv_position_trans_magnoliya
as
select *
	from dwh.bi_desadv_position_trans_x5
		where 1=0;

create index bi_desadv_position_trans_magnoliya_idx1 on bi_desadv_position_trans_magnoliya (desadv_ord_number,desadv_ord_date,desadv_pos_number);
create index bi_desadv_position_trans_magnoliya_idx2 on bi_desadv_position_trans_magnoliya (doc_chain_id);

analyze verbose bi_desadv_position_trans_magnoliya;