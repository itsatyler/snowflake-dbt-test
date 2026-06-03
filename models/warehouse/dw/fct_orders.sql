{{config(materialized='table')}}

select
    md5(o.order_id) as fct_orders_id,
    o.order_id,
    c.dim_customer_id,
    o.order_timestamp,
    s.dim_status_id,
    sc.dim_sales_channels_id,
    w.dim_warehouse_id,
    o.promo_code
from {{source('lnd','raw_orders')}} o
left join {{ref('dim_customers')}} c 
  on o.customer_id = c.customer_id
left join {{ref('dim_warehouses')}} w 
  on o.warehouse_id = w.warehouse_id
left join {{ref('dim_sales_channels')}} sc 
  on o.sales_channel = sc.sales_channel
left join {{ref('dim_status')}} s 
  on o.order_status = s.status