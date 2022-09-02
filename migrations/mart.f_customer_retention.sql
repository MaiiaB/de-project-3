-- Максиму Попову: 
-- Привет, спасибо за ревью. У меня вопрос по поводу того как делать коррекции.
-- Ты написал, что у меня не соблюдается идемпотентность и что в этом скрипте мне
-- нужно удалять данные за недельный период перед вставкой.
-- Мне не очень понятно как это сделать если мы, например, рассчитываем эту витрину в среду, чтобы иметь данные за
-- последние 7 дней, потому что в данной витрине я могу удалить только по номеру недели в году, а не по дням. 
-- То есть если я удалю данные за неделю которая сейчас, то получается имеет смысл рассчитывать это витрину только в вс вечером
-- Или я что-то не понимаю?
-- Если я запускаю пайплайн среду, то получается, чтобы данные за чт,пт,сб и вс занеслись успешно, то мне нужно еще и за прошлую неделю данные удалить.
-- В общем, я затрудняюсь найти здесь оптимальное решение, подскажи пожалуйста как надо

DELETE FROM mart.f_customer_retention WHERE period_id = (SELECT extract('week' from current_date)); -- удаление данных за эту неделю

DELETE FROM mart.f_customer_retention WHERE period_id = (SELECT extract('week' from current_date))-1; -- удаление данных за предыдущую неделю

-- Еще можно удалить все данные вообще, но тогда тут не будут сохраняться расчеты за предыдущие недели

--DELETE FROM mart.f_customer_retention;


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
-- in case we need to analyse data over different years, CHANGE datatype to INT (!) while creating the table:

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
