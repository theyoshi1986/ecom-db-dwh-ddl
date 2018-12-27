--drop TABLE dwh.stg_pos_description;

CREATE TABLE dwh.stg_pos_description (
	gtin bigint NOT NULL,
	pos_name varchar(2000) NOT NULL,
	pos_name_cln varchar(2000) NOT NULL,
	id_group_item integer null,
	weigth_value varchar(2000),
	weigth_measure varchar(2000)
);

select * from stg_pos_description;