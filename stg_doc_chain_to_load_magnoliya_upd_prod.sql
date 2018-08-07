create table dwh.stg_doc_chain_to_load_magnoliya_upd_prod
as
select *
	from dwh.stg_doc_chain_to_load_x5
		where 1=0;
	
alter table dwh.stg_doc_chain_to_load_magnoliya_upd_prod alter column intchainid type bigint;
alter table dwh.stg_doc_chain_to_load_magnoliya_upd_prod alter column intdocid type bigint;
	
select * from dwh.stg_doc_chain_to_load_magnoliya_upd_prod