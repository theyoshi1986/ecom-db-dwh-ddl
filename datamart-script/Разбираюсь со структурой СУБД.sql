-- Цепочка документов
select *
	from chains_docs
	where intdocid=1701804341
	or intChainID=310073
limit 100;

-- JSON документа
select *
	from docs_body
	where intDocID=1976577602
limit 100;

-- инфа по номеру документа
select /*ind.*, */dt.varType, ds.varStatus, db.varBody
	from index_vardocnum ind
		inner join docs_body db
			on ind.intDocID=db.intDocID
		inner join docs d
			on d.intDocID=ind.intDocID
		inner join exite_main.doc_types dt
			on dt.intTypeID=d.intTypeID
		inner join exite_main.doc_statuses ds
			on d.intStatusID=ds.intStatusID
	where varIndex='BRC212212';
	
-- 2 3 4 5
select *
	from exite_main.doc_types
	where vartype in ('order','recadv','desadv','ordrsp')
;

select *
	from exite_main.doc_statuses
	where 1=1;

select *
	from docs d
		inner join docs_body db
			on db.intDocID=d.intDocID
	where 1=1
	  and intTypeID in (2/*,3,4,5*/)
-- 	and (db.intDocID=646642
-- 	or d.intFromDocID=646642)
-- 	and varDateChanged>=CURRENT_DATE-1
	and db.intDocID=1701804341
limit 3;

select *
	from orders_sequences
	where 1=1
	and intValue=9111626218
limit 200;


--Ищем по индексу заказов

select *
	from index_varorderdate
	where varIndex >= CURRENT_DATE-1/24;

select *
	from chains_docs cd
		inner join docs d
			on d.intDocID=cd.intDocID
		left join docs_body db
			on db.intDocID=cd.intDocID
	where cd.intChainID=234894251
-- order by cd.intDocID
limit 50;

--Выгружаю json заказы

select db.varBody, d.intTypeID
	from index_varorderdate ordd
		inner join docs d
			on d.intDocID=ordd.intDocID
		inner join docs_body db
			on db.intDocID=ordd.intDocID
	where ordd.varIndex >= CURRENT_DATE-1
        and d.intTypeID in (2,5,4,3)
		and length(db.varBody) > 0
limit 1000;

-- Выгружаю справочник GLN
select varGln, varname, varStreet, varCity
	from exite_ru.glns;
	

----------------- sandbox

-- 22млн заказов в месяц. Заказы старше 3х месяцев архивируются
select  count(*) cnt, concat(EXTRACT(YEAR from varIndex),EXTRACT(MONTH from varIndex)) dt
	from exite_ru.index_varorderdate ordd
		inner join docs d
			on d.intDocID=ordd.intDocID
		inner join docs_body db
			on db.intDocID=ordd.intDocID
		where varIndex between date'2017-08-01' and current_date
			and d.intTypeID in (2,5,4,3)
			and length(db.varBody) > 0
group by concat(EXTRACT(YEAR from varIndex),EXTRACT(MONTH from varIndex))
order by concat(EXTRACT(YEAR from varIndex),EXTRACT(MONTH from varIndex)) desc;