--DROP TABLE IF EXISTS mart.f_customer_retention;

-- corrected query: 

CREATE TABLE mart.f_customer_retention(
        new_customers_count INT, 
        returning_customers_count INT,
        refunded_customer_count INT,
        period_name VARCHAR(20) DEFAULT 'weekly',
        period_id INT,  
        item_id BIGINT,
        new_customers_revenue NUMERIC(14,2),
        returning_customers_revenue NUMERIC(14,2),
        customers_refunded INT, 
        PRIMARY KEY (period_id, item_id))
        ;

