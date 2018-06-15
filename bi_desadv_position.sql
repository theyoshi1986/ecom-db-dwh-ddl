-- drop table bi_desadv_position;
-- truncate table bi_desadv_position;

create table bi_desadv_position
(doc_chain_id numeric,
 desadv_number varchar(70),
 desadv_ord_number varchar(70),
 desadv_ord_date date,
 desadv_supplier_gln bigint,
 desadv_byer_gln bigint,
 desadv_deliv_place bigint,
 desadv_date date,
 desadv_delivery_date date,
 desadv_delivery_time varchar(100),
 desadv_deliv_note_date date,
 desadv_deliv_note_num varchar(150),
 desadv_pos_number numeric,
 desadv_pos_deliveredquantity numeric,
 desadv_pos_amount_no_vat numeric,
 desadv_pos_amount_with_vat numeric,
 desadv_pos_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 desadv_pos_price_with_vat numeric,
 desadv_pos_price_no_vat numeric,
 desadv_pos_product_num bigint,
 desadv_packages_amount numeric,
 desadv_info varchar(300),
 desadv_pos_orderedquantity numeric,
 desadv_pos_unit_name varchar(50),
 desadv_pos_units_in_box numeric,
 desadv_pos_orderedquantity_box numeric,
 desadv_pos_description varchar(1000),
 desadv_pos_condition_status varchar(100)
);
 
create index bi_desadv_position_idx1 on bi_desadv_position (desadv_ord_number, desadv_ord_date, desadv_pos_number);
create index bi_desadv_position_idx2 on bi_desadv_position (doc_chain_id);

select * from bi_desadv_position
	where desadv_byer_gln is not null
		or desadv_supplier_gln is not null;