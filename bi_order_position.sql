-- drop table bi_order_position;
-- truncate table bi_order_position;

create table bi_order_position
(doc_chain_id numeric,
 ord_number varchar(70),
 ord_date date,
 ord_delivery_date date,
 ord_delivery_time varchar(100),
 ord_earliest_delivery_date date,
 ord_latest_delivery_date date,
 ord_shipment_date date,
 ord_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 ord_contract_number varchar(150),
 ord_deliv_place bigint,
 ord_currency varchar(100),
 ord_transportation varchar(350),
 ord_trans_route varchar(150),
 ord_blanc_ord_num varchar(150),
 ord_doc_type varchar(10),
 ord_supplier_gln bigint,
 ord_byer_gln bigint,
 ord_type varchar(350),
 pos_number numeric,
 pos_orderedquantity numeric,
 pos_units_in_box numeric,
 pos_orderedquantity_box numeric,
 pos_unit_name varchar(100),
 pos_vat numeric, --Ставку хранить целым числом, например 0, 10, 18
 pos_price_with_vat numeric,
 pos_price_no_vat numeric,
 pos_product_num bigint,
 pos_description varchar(1500),
 pos_condition_status varchar(100)
);

create index bi_order_position_idx1 on bi_order_position (ord_date);
create index bi_order_position_idx2 on bi_order_position (doc_chain_id);
create index bi_order_position_idx3 on bi_order_position (ord_number);
create index bi_order_position_idx4 on bi_order_position (ord_byer_gln);
create index bi_order_position_idx5 on bi_order_position (ord_supplier_gln);
create index bi_order_position_idx7 on bi_order_position (ord_date, ord_byer_gln, ord_supplier_gln);

analyze verbose dwh.bi_order_position;
 
--������ ����
select * from dwh.bi_order_position
	where pos_condition_status is not null
	    or pos_condition_status is not null
		or ord_transportation is not null
		or ord_trans_route is not null
		or pos_description is not null;

grant select on bi_order_position to bi_user;