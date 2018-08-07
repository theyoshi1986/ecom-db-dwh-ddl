create table dwh.stg_doc_chain_to_load_magnoliya_arch
as
select *
	from dwh.stg_doc_chain_to_load_x5
		where 1=0;

select * from dwh.stg_doc_chain_to_load_magnoliya_arch