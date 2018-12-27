--drop table dwh.stg_dump_billing;
create table dwh.stg_dump_billing
(intRecID bigint,
varSenderGLN	bigint,
varRecipientGLN	bigint,
varDate	Date,
intTypeID	Integer,
intDocID	bigint);