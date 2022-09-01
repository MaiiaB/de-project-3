# Проект 3

/src/dags/code_sprint3.py - dag file 


**Дополнительные SQL скрипты:**


/migrations/1_change_uol.sql - script to add column "status" to the table staging.user_order_log

/migrations/2_change_f_sales.sql - script to add column "status" to mart.f_sales

/migrations/3_create_f_customer_retention.sql - script to create mart.f_customer_retention


**Скрипты миграции, используемые внутри DAG "Maiia_final_customer_retention":**


/migrations/mart.d_city.sql

/migrations/mart.d_customer.sql

/migrations/mart.d_item.sql

/migrations/mart.f_customer_retention.sql

/migrations/mart.f_sales.sql




