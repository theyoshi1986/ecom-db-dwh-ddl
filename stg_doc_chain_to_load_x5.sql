create table dwh.stg_doc_chain_to_load_x5
as
select *
	from stg_doc_chain_to_load stg
		where exists (select doc_chain_id
								from bi_order_position_uniq_x5 op where op.doc_chain_id=stg.intchainid)
			and varbody is not null;

create index stg_doc_chain_to_load_x5_idx1 on dwh.stg_doc_chain_to_load_x5 (intchainid);

analyse verbose dwh.stg_doc_chain_to_load_x5;