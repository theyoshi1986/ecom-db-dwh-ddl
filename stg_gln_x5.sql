create table dwh.stg_gln_x5
as
select g.*
	from dwh.stg_gln g
		inner join dwh.stg_account a
			on a.intaccountid=g.intaccountid
		where a.varcompanyname like 'Торговый дом "ПЕРЕКРЕСТОК';
