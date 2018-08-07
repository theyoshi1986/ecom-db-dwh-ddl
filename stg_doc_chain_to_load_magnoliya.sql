create table dwh.stg_doc_chain_to_load_magnoliya
as
select *
	from stg_doc_chain_to_load_x5
		where 1=0;

select * from stg_doc_chain_to_load_magnoliya