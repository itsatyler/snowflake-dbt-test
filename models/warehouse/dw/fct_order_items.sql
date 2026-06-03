{{ config(materialized='table') }}


with src as (
  select * from {{source('lnd','raw_order_items')}}
)
select
  md5(s.order_item_id) as fct_order_items_id,
  o.fct_orders_id,
  s.order_item_id,
  p.dim_product_id,
  s.quantity,
  s.unit_price,
  s.discount_amount,
  s.line_total
from src s
left join {{ ref('dim_products') }} p on s.product_id = p.product_id
left join {{ ref('fct_orders')}} o on s.order_id = o.order_id