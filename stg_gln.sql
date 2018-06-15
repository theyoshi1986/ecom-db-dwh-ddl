--drop table stg_gln;
--truncate table stg_gln;

create table dwh.stg_gln
(intGlnID bigint,
 varGln bigint,
 varName varchar(100),
 varStreet varchar(100),
 varCity varchar(50),
 varcityRegexp varchar(50),
 intAccountID integer,
 intRetailerID integer,
 geodata_id bigint
);

create index stg_gln_idx1 on dwh.stg_gln (intGlnID);
create index stg_gln_idx2 on dwh.stg_gln (varGln);

analyze verbose dwh.stg_gln;
	
select * 
	from dwh.stg_gln;

--delete from dwh.stg_gln g
--	where not exists (select intaccountid from dwh.stg_account a where a.intaccountid=g.intaccountid);

--��������� ����
update dwh.stg_gln
	set varname = case when varname in ('��� "��������"') then '���� 1'
	  			       when varname in ('�� ������','��� "�������"','��� "����� ��� ��� �����", 1342') then '���� 2'
	  			       else '���� 3' end
		where varname in (select buyer_name
								from dwh.bi_orders_dm dm
							group by buyer_name)
			or varname in ('�� ������','��� "�������"','��� "����� ��� ��� �����", 1342');
							
--��������� �����������
update dwh.stg_gln
	set varname = '��������� '||width_bucket(vargln,1,9999999999999,10)
		where varname not in ('���� 1','���� 2','���� 3');



update stg_gln
	set varcityregexp = '������' where varcityregexp='�������� ����� ������,������';
update stg_gln
	set varcityregexp = '�����' where varcityregexp='�������� ����,�����';
update stg_gln
	set varcityregexp = '������' where varcityregexp='������, ����������� ��������, ��. 29';
update stg_gln
	set varcityregexp = '������' where varcityregexp='���.������ ���';
update stg_gln
	set varcityregexp = '������' where varcityregexp='#';
