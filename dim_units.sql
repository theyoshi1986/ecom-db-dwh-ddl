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

--comment on table dwh.dim_units is 'Справочник единиц измерения';

INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(1, 'бочка', 'бочка', '', 'ZBC', 1, 1);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(2, 'голова', 'голова', '', 'ZHD', 1, 2);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(4, 'доза', 'доза', '639', 'ZDZ', 1, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(13, 'млн. доз', 'млн. доз', '', '', 1000000, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(19, 'тыс. доз', 'тыс. доз', '', 'ZTD', 1000, 4);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(5, 'канистра', 'канистра', '', '', 1, 5);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(6, 'кг', 'кг', '166', 'KGM', 1, 6);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(18, 'тонна', 'тонна', '168', 'TNE', 1000, 6);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(7, 'коробка', 'коробка', '', '', 1, 7);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(3, 'грамм', 'грамм', '163', 'GRM', 1000, 9);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(9, 'мг', 'миллиграмм', '161', 'MGM', 1, 9);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(10, 'метр', 'метр', '006', 'MTR', 1, 10);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(20, 'тыс. м', 'тыс. м', '', 'ZTM', 1000, 10);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(11, 'мешок', 'мешки', '', 'ZMS', 1, 11);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(8, 'литр', 'литр', '112', 'LTR', 1000, 12);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(12, 'мл', 'миллилитр', '111', 'MLT', 1, 12);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(15, 'проба', 'проба', '', '', 1, 15);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(16, 'пучок', 'пучок', '', 'ZPC', 1, 16);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(17, 'семья', 'семья', '896', '', 1, 17);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(22, 'упаковка', 'упаковка', '778', 'NMP', 1, 22);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(23, 'флакон', 'флакон', '872', 'ZFL', 1, 23);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(14, 'млн. шт.', 'млн. шт.', '799', 'MIO', 1000000, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(21, 'тыс. шт.', 'тыс. шт.', '798', 'MIL', 1000, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(24, 'шт.', 'шт.', '796', 'PCE', 1, 24);
INSERT INTO dwh.dim_units
(unit_id, unit_name, unit_full_name, unit_code_okei, unit_code_iso, unit_conversion_factor, unit_base_id)
VALUES(25, 'экз.', 'экз.', '', '', 1, 25);
commit;

update dwh.dim_units
	set unit_code_iso = 'CT'
		where unit_name='коробка';