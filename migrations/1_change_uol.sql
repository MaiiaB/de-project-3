--ALTER TABLE staging.user_order_log 
--DROP COLUMN status;

ALTER TABLE staging.user_order_log 
ADD status VARCHAR(10) DEFAULT 'shipped';
