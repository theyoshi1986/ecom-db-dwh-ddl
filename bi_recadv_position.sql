-- drop table bi_recadv_position;
-- truncate table bi_recadv_position;

create table bi_recadv_position
(doc_chain_id numeric,
 recadv_number varchar(70),
 recadv_ord_number varchar(70),
 recadv_ord_date date,
 recadv_supplier_gln bigint,
 recadv_byer_gln bigint,
 recadv_deliv_place bigint,
 recadv_date date,
 recadv_reception_date date,
 recadv_deliv_note_date date,
 recadv_deliv_note_num varchar(150),
 recadv_doctype varchar(10),
 recadv_pos_number numeric,
 recadv_pos_acceptedquantity numeric,
 recadv_pos_deliveredquantity numeric,
 recadv_pos_orderedquantity numeric,
 recadv_pos_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 recadv_pos_price_with_vat numeric,
 recadv_pos_price_no_vat numeric,
 recadv_pos_product_num bigint,
 recadv_packages_amount numeric,
 recadv_info varchar(1000),
 recadv_pos_deltaquantity numeric,
 recadv_pos_description varchar(1500),
 recadv_pos_condition_status varchar(100),
 recadv_pos_amount_no_vat numeric,
 recadv_pos_amount_with_vat numeric
);

create index bi_recadv_position_idx1 on bi_recadv_position (recadv_ord_number);
create index bi_recadv_position_idx2 on bi_recadv_position (doc_chain_id);
create index bi_recadv_position_idx3 on bi_recadv_position (recadv_ord_number, recadv_pos_number, recadv_byer_gln, recadv_supplier_gln);
 
select * from bi_recadv_position
	where recadv_ord_date is not null
		or recadv_packages_amount is not null
		or recadv_info is not null
		or recadv_pos_deltaquantity is not null
		or recadv_pos_condition_status is not null;