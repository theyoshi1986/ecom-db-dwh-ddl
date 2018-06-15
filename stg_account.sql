--drop table dwh.stg_account;
create table dwh.stg_account
(intAccountID numeric,
 varCompanyName varchar(110),
 varAddress varchar(4000));

create index stg_account_idx1 on dwh.stg_account (intAccountID);
 
analyze verbose dwh.stg_account;

--delete from dwh.stg_account
--	where varcompanyname not in ('Маслозавод Нытвенский','Кораблик-Р');

select count(1) from dwh.stg_account;