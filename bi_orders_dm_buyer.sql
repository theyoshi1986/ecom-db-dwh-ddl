--������ �� ���� ����������� �������� ��� "�����������
--drop table dwh.bi_orders_dm_buyer;
create table dwh.bi_orders_dm_buyer
as
/*bi_orders_dm_bck20180416 + ��� ������ �������� ��� "�����������*/
select *
	from bi_orders_dm
		where supplier_name in ('�������','�� ��������','��������� ���������� �5','����','����� ����','�������� "������� ���','��������� �.�.','����','�������� ��������','�������','������������ ������','�������������� �������������')
except
select * from dwh.bi_orders_dm_bck20180416 /*��� ���� ���������� ���������� ����������*/;

create index bi_orders_dm_buyer_idx1 on dwh.bi_orders_dm_buyer (ord_date);

analyze verbose bi_orders_dm_buyer;

update dwh.bi_orders_dm_buyer
	set supplier_city = '���������'
		where supplier_name = '������������ ������'
		and supplier_city = '������������� ���., ������������ �-�,���������';

update dwh.bi_orders_dm_buyer
	set supplier_city = '������ ��������'
		where supplier_name = '�������'
		and supplier_city = '�.��������';