-- добавка для идемпотентности
DELETE FROM mart.f_sales WHERE date_id = (SELECT date_id from mart.d_calendar WHERE date_actual='{{ds}}');


insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, "status") --changed
select dc.date_id, 
       item_id, 
       customer_id, 
       city_id, 
       quantity, 
       (CASE WHEN status='refunded' THEN payment_amount*(-1) ELSE payment_amount END) as payment_amount,  --changed
       "status" from staging.user_order_log uol --changed
left join mart.d_calendar as dc on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';
