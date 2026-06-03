{{config(materialized='table')}}

select
  md5(p.payment_id) as fct_payment_id,
  p.payment_id,
  o.fct_orders_id,
  p.payment_timestamp,
  s.dim_status_id,
  p.payment_amount
from {{source('lnd','raw_payments')}} p
left join {{ref('fct_orders')}} o 
  on p.order_id = o.order_id
left join {{ref('dim_status')}} s
  on p.payment_status = s.status