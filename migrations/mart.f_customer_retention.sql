INSERT INTO mart.f_customer_retention (new_customers_count, returning_customers_count, refunded_customer_count,
                                     period_id, item_id, new_customers_revenue, returning_customers_revenue, customers_refunded) 
with spl as (
SELECT dc.week_of_year as period_id,
       uol.customer_id,
       uol.item_id,
       count(uol.id) as order_count,
       count(CASE WHEN uol.status='refunded' THEN 1 ELSE 0 END) as refund_count,
       SUM(payment_amount) as payment_amount
from staging.user_order_log uol
left join mart.d_calendar dc
-- in case we need to analyse data over different years, use this code and CHANGE datatype to VARCHAR (!) while creating the table:

--(SELECT date_actual, ((regexp_split_to_array(week_of_year_iso , E'\\-+'))[1] || 
--                                                                         '-' || 
--                     (regexp_split_to_array(week_of_year_iso , E'\\-+'))[2]) as period_id from mart.d_calendar) as dc 

on uol.date_time::Date = dc.date_actual
group by period_id, uol.customer_id, uol.item_id
)
SELECT 
       SUM(CASE WHEN order_count=1 THEN 1 ELSE 0 END) as new_customers_count,
       SUM(CASE WHEN order_count>1 THEN 1 ELSE 0 END) as returning_customers_count,
       SUM(CASE WHEN refund_count>0 THEN 1 ELSE 0 END) as refunded_customer_count,
       period_id,
       item_id, 
       SUM(CASE WHEN order_count=1 THEN payment_amount ELSE 0 END) as new_customers_revenue,
       SUM(CASE WHEN order_count>1 THEN payment_amount ELSE 0 END) as returning_customers_revenue,
       SUM(refund_count) as customers_refunded
from spl
group by period_id, item_id
order by period_id, item_id
;
