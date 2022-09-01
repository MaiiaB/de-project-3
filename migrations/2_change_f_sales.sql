--ALTER TABLE mart.f_sales DROP COLUMN status;

ALTER TABLE mart.f_sales
ADD status VARCHAR(10) DEFAULT 'shipped';
