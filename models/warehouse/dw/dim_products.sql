{{ config(materialized="table") }}

with src as (
  select * from {{ source('lnd', 'raw_products')}}
)
select
  md5(product_id) as dim_product_id,
  product_id,
  sku,
  product_name,
  category,
  standard_cost,
  list_price,
  is_active,
  current_date() as last_updated
from src
