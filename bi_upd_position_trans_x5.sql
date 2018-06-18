-- drop table dwh.bi_upd_position_trans_x5;
-- truncate table dwh.bi_upd_position_trans_x5;

create table dwh.bi_upd_position_trans_x5
(
inttypeid bigint,
intchainid bigint,
intdocid bigint,
upd_based_on_other varchar(10),
upd_file_name varchar(500),
upd_number varchar(100),
upd_date date,
upd_currency_code varchar,
upd_knd integer,
upd_type varchar(6),
upd_file_create_date date,
upd_file_create_time varchar(8),
upd_creator varchar(500),
upd_id_sender varchar(128),
upd_id_receiver varchar(128),
upd_format_version varchar(50),
upd_software_version varchar (100),
upd_sender varchar(128),
upd_recipient varchar(128),
upd_order_number varchar(100),
upd_order_date date,
upd_pos_order_number varchar(200),
upd_sender_gln bigint,
upd_recipient_gln bigint,
upd_pos_number integer,
upd_pos_description varchar(1000),
upd_pos_unit_code integer,
upd_pos_quantity numeric,
upd_pos_unit_price_no_vat numeric,
upd_pos_amount_no_vat numeric,
upd_pos_vat numeric,
upd_pos_amount_with_vat numeric,
upd_pos_product_num bigint
);

create index bi_upd_position_trans_x5_idx1 on bi_upd_position_trans_x5 (intdocid);

analyze verbose dwh.bi_upd_position_trans_x5;