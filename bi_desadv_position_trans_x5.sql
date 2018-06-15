create table bi_desadv_position_trans_x5
as
select desadv.*
	from dwh.bi_desadv_position desadv
		inner join dwh.bi_order_position_trans_x5 ordr
			on ordr.ord_number=desadv.desadv_ord_number
			and ordr.ord_date=desadv.desadv_ord_date
			and ordr.pos_number=desadv.desadv_pos_number;

create index bi_desadv_position_trans_x5_idx1 on bi_desadv_position_trans_x5 (desadv_ord_number,desadv_ord_date,desadv_pos_number);
create index bi_desadv_position_trans_x5_idx2 on bi_desadv_position_trans_x5 (doc_chain_id);

analyze verbose bi_desadv_position_trans_x5;

alter table bi_desadv_position_trans_x5 rename column desadv_byer_gln to desadv_buyer_gln;
alter table bi_desadv_position_trans_x5 add desadv_version int;
alter table bi_desadv_position_trans_x5 add desadv_doctype varchar(10);