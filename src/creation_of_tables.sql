--TABLES CREATION 

-- DELETING ALL THE PREVIOUSLY CREATED TABLES (including foreign keys )
ALTER TABLE shipping_info
DROP CONSTRAINT shipping_info_shipping_country_rates_id_fkey;

ALTER TABLE shipping_info
DROP CONSTRAINT shipping_info_agreementid_fkey;

ALTER TABLE shipping_info
DROP CONSTRAINT shipping_info_shipping_transfer_id_fkey;


DROP TABLE IF EXISTS shipping_country_rates CASCADE;
DROP TABLE IF EXISTS shipping_agreement CASCADE;
DROP TABLE IF EXISTS shipping_transfer CASCADE;
DROP TABLE IF EXISTS shipping_info CASCADE;
DROP TABLE IF EXISTS shipping_status CASCADE;


--shipping_country_rates

CREATE TABLE shipping_country_rates(
   id SERIAL PRIMARY KEY,
   shipping_country text ,
   shipping_country_base_rate NUMERIC(4,3) --changed from numeric(14,3), 14 is too much
    
);

--shipping_agreement
CREATE TABLE shipping_agreement(
    agreementid BIGINT PRIMARY KEY,
    agreement_number varchar(15), --although 9 would be already enough
    agreement_rate NUMERIC(4,3),
    agreement_commission NUMERIC(4,3)
);

--shipping_transfer
CREATE TABLE shipping_transfer(
    transfer_type_id SERIAL PRIMARY KEY,
    transfer_type varchar(5),
    transfer_model text,
    shipping_transfer_rate NUMERIC(4,3)
);

--shipping_info
CREATE TABLE shipping_info(
    shippingid BIGINT PRIMARY KEY,
    shipping_country_rates_id BIGINT,
    agreementid BIGINT,
    shipping_transfer_id BIGINT, 
    shipping_plan_datetime TIMESTAMP, 
    payment_amount NUMERIC(14,2),
    vendorid BIGINT,
FOREIGN KEY (shipping_country_rates_id) REFERENCES shipping_country_rates(id) ON UPDATE cascade,
FOREIGN KEY (agreementid) REFERENCES shipping_agreement(agreementid) ON UPDATE cascade,
FOREIGN KEY (shipping_transfer_id) REFERENCES shipping_transfer(transfer_type_id) ON UPDATE cascade);

--shipping_status
CREATE TABLE shipping_status(
    shippingid BIGINT PRIMARY KEY,
    status TEXT,
    state TEXT,
    shipping_start_fact_datetime TIMESTAMP,
    shipping_end_fact_datetime TIMESTAMP
);
