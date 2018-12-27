--Агрегирующая таблица фактов
create table dwh.stg_dump_billing_agg1
as
select varsendergln,varrecipientgln,vardate,inttypeid, count(intdocid) doccount
	from dwh.stg_dump_billing f
group by varsendergln,varrecipientgln,vardate,inttypeid
order by vardate,varsendergln,varrecipientgln,inttypeid;

select *
	from stg_dump_billing_agg1;

--drop index stg_dump_billing_agg1_idx1;
--drop index stg_dump_billing_agg1_idx2;
--drop index stg_dump_billing_agg1_idx3;
--drop index stg_dump_billing_agg1_idx4;

create index stg_dump_billing_agg1_idx1 on dwh.stg_dump_billing_agg1 (varsendergln, doccount);
create index stg_dump_billing_agg1_idx2 on dwh.stg_dump_billing_agg1 (varrecipientgln, doccount);
create index stg_dump_billing_agg1_idx3 on dwh.stg_dump_billing_agg1 (inttypeid, doccount);
create index stg_dump_billing_agg1_idx4 on dwh.stg_dump_billing_agg1 (vardate, doccount);

create index stg_dump_billing_agg1_idx5 on dwh.stg_dump_billing_agg1 (vardate, varsendergln, doccount);
create index stg_dump_billing_agg1_idx6 on dwh.stg_dump_billing_agg1 (vardate, varrecipientgln, doccount);
create index stg_dump_billing_agg1_idx7 on dwh.stg_dump_billing_agg1 (vardate, varsendergln, varrecipientgln, doccount);
create index stg_dump_billing_agg1_idx8 on dwh.stg_dump_billing_agg1 (vardate, varrecipientgln, varsendergln, doccount);

create index stg_dump_billing_agg1_idx9 on dwh.stg_dump_billing_agg1 (varsendergln, varrecipientgln, doccount);
create index stg_dump_billing_agg1_idx10 on dwh.stg_dump_billing_agg1 (varrecipientgln, varsendergln, doccount);

analyze stg_dump_billing_agg1;