-- drop table bi_orderrsp_position;
-- truncate table bi_orderrsp_position;

create table bi_orderrsp_position
(doc_chain_id numeric,
 ordrsp_number varchar(70),
 ordrsp_date date,
 ordrsp_time varchar(100),
 ordrsp_ord_number varchar(70),
 ordrsp_ord_date date,
 ordrsp_supplier_gln bigint,
 ordrsp_byer_gln bigint,
 ordrsp_deliv_place bigint,
 ordrsp_delivery_date date,
 ordrsp_delivery_time varchar(100),
 ordrsp_reason_decreace_quantity varchar(4000),
 ordrsp_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 ordrsp_currency varchar(100),
 ordrsp_action integer,
 ordrsp_pos_number numeric,
 ordrsp_pos_product_type numeric,
 ordrsp_pos_orderedquantity numeric,
 ordrsp_pos_acceptedquantity numeric,
 ordrsp_pos_orderedquantity_box numeric,
 ordrsp_pos_unit_name varchar(100),
 ordrsp_pos_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 ordrsp_pos_price_with_vat numeric,
 ordrsp_pos_price_no_vat numeric,
 ordrsp_pos_product_num bigint,
 ordrsp_pos_reason_decreace_quantity varchar(4000),
 ordrsp_pos_info varchar(1500),
 ordrsp_pos_description varchar(1500),
 ordrsp_pos_condition_status varchar(100)
);

create index bi_orderrsp_position_idx1 on bi_orderrsp_position (ordrsp_ord_number);
create index bi_orderrsp_position_idx2 on bi_orderrsp_position (doc_chain_id);
create index bi_orderrsp_position_idx3 on bi_orderrsp_position (ordrsp_date, ordrsp_byer_gln, ordrsp_supplier_gln, ordrsp_pos_number);
create index bi_orderrsp_position_idx4 on bi_orderrsp_position (ordrsp_byer_gln);
create index bi_orderrsp_position_idx5 on bi_orderrsp_position (ordrsp_supplier_gln);
 
select * from bi_orderrsp_position
	where ordrsp_pos_condition_status is not null
	or ordrsp_pos_reason_decreace_quantity is not null;