create table bi_orderrsp_position_trans_x5
as
select op.*
	from dwh.bi_orderrsp_position op
		inner join dwh.stg_gln_x5 g
			on g.vargln=op.ordrsp_byer_gln;
			
create index bi_orderrsp_position_trans_x5_idx1 on bi_orderrsp_position_trans_x5 (ordrsp_ord_date,ordrsp_byer_gln,ordrsp_supplier_gln,ordrsp_pos_number);
create index bi_orderrsp_position_trans_x5_idx2 on bi_orderrsp_position_trans_x5 (doc_chain_id);

analyze verbose bi_orderrsp_position_trans_x5;

alter table bi_orderrsp_position_trans_x5 rename column ordrsp_byer_gln to ordrsp_buyer_gln;
alter table bi_orderrsp_position_trans_x5 add ordrsp_version int;
alter table bi_orderrsp_position_trans_x5 add ordrsp_doctype varchar(10);
