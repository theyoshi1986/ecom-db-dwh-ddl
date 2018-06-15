--drop table stg_doc_chain_to_load;
--truncate table stg_doc_chain_to_load;

create table stg_doc_chain_to_load
(intChainID integer,
 intDocID integer,
 intTypeId integer,
 varBody text);

create index stg_doc_chain_to_load_idx1 on dwh.stg_doc_chain_to_load (intChainID);
create index stg_doc_chain_to_load_idx2 on dwh.stg_doc_chain_to_load (intDocID);
 
select *
	from dwh.stg_doc_chain_to_load;
	
--alter table dwh.stg_doc_chain_to_load rename to stg_doc_chain_to_load_bck20180404;