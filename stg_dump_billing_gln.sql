--drop table dwh.stg_dump_billing_gln;
create table dwh.stg_dump_billing_gln
(intGlnID bigint,
 varGlnName varchar,
 varCity varchar,
 intAccountID bigint,
 intRetailerID bigint,
 varGln bigint,
 varCompanyName varchar,
 varInnCode varchar,
 varKppCode varchar);
 
 select *
 	from stg_dump_billing_gln;

