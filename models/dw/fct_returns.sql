{{config(materialized='table')}}

select
  md5(r.return_id) as fct_returns_id,
  r.return_id,
  o.fct_orders_id,
  oi.fct_order_items_id,
  r.return_reason,
  r.return_timestamp,
  r.refund_amount
from {{source('lnd', 'raw_returns')}} r
left join {{ref('fct_orders')}} o
  on r.order_id = o.order_id
left join {{ref('fct_order_items')}} oi
  on r.order_item_id = oi.order_item_id