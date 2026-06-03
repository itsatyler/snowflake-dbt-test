{{ config(materialized='table') }}

select
  p.category,
  p.product_name,
  count(distinct f.fct_orders_id) as total_orders,
  count(distinct f.order_item_id) as total_order_items,
  sum(f.quantity) as total_units_sold,
  sum(f.line_total) as gross_sales,
  sum(f.discount_amount) as total_discount,
  round(avg(f.unit_price),2) as avg_unit_price
from {{ref('fct_order_items')}} f
left join {{ref('dim_products')}} p on f.dim_product_id = p.dim_product_id
GROUP BY
  p.category,
  p.product_name