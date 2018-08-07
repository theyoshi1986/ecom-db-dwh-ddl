create table dwh.bi_desadv_position_trans_bread
as
select *
	from dwh.bi_desadv_position_trans_x5
		where 1=0;

create index bi_desadv_position_trans_bread_idx1 on dwh.bi_desadv_position_trans_bread (desadv_ord_number,desadv_ord_date,desadv_pos_number);
create index bi_desadv_position_trans_bread_idx2 on dwh.bi_desadv_position_trans_bread (doc_chain_id);

analyze verbose dwh.bi_desadv_position_trans_bread;