--drop table dwh.dim_units;
create table dwh.dim_units
(unit_id integer
,unit_name varchar(250)
,unit_full_name varchar(250)
,unit_code_iso varchar(5)
,unit_code_okei varchar(5)
,unit_conversion_factor numeric
,unit_base_id integer
);

select * from dwh.dim_units;

--comment on table dwh.dim_units is '���������� ������ ���������';

INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(1, '�����', '�����', '', 'ZBC', 1, 1);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(2, '������', '������', '', 'ZHD', 1, 2);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(4, '����', '����', '639', 'ZDZ', 1, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(13, '���. ���', '���. ���', '', '', 1000000, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(19, '���. ���', '���. ���', '', 'ZTD', 1000, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(5, '��������', '��������', '', '', 1, 5);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(6, '��', '��', '166', 'KGM', 1, 6);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(18, '�����', '�����', '168', 'TNE', 1000, 6);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(7, '�������', '�������', '', '', 1, 7);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(3, '�����', '�����', '163', 'GRM', 1000, 9);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(9, '��', '����������', '161', 'MGM', 1, 9);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(10, '����', '����', '006', 'MTR', 1, 10);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(20, '���. �', '���. �', '', 'ZTM', 1000, 10);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(11, '�����', '�����', '', 'ZMS', 1, 11);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(8, '����', '����', '112', 'LTR', 1000, 12);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(12, '��', '���������', '111', 'MLT', 1, 12);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(15, '�����', '�����', '', '', 1, 15);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(16, '�����', '�����', '', 'ZPC', 1, 16);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(17, '�����', '�����', '896', '', 1, 17);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(22, '��������', '��������', '778', 'NMP', 1, 22);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(23, '������', '������', '872', 'ZFL', 1, 23);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(14, '���. ��.', '���. ��.', '799', 'MIO', 1000000, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(21, '���. ��.', '���. ��.', '798', 'MIL', 1000, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(24, '��.', '��.', '796', 'PCE', 1, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(25, '���.', '���.', '', '', 1, 25);
commit;

update dwh.dim_units
	set unit_code_iso = 'CT'
		where unit_name='�������';