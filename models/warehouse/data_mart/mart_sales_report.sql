{{ config(materialized='table') }}

with returns as (
  select
    p.product_id,
    p.product_name,
    p.category,
    r.return_id,
    o.fct_order_items_id
  from {{ref('fct_returns')}} r
  left join {{ref('fct_order_items')}} o on r.fct_order_items_id = o.fct_order_items_id
  left join {{ref('dim_products')}} p on o.dim_product_id = p.dim_product_id
)
select
  p.category,
  p.product_name,
  count(distinct f.fct_orders_id) as total_orders,
  count(distinct f.order_item_id) as total_order_items,
  sum(f.quantity) as total_units_sold,
  sum(f.line_total) as gross_sales,
  count(r.return_id) as total_returns,
  sum(f.discount_amount) as total_discount,
  round(avg(f.unit_price),2) as avg_unit_price
from {{ref('fct_order_items')}} f
left join {{ref('dim_products')}} p on f.dim_product_id = p.dim_product_id
left join returns r on f.fct_order_items_id = r.fct_order_items_id
GROUP BY
  p.category,
  p.product_name