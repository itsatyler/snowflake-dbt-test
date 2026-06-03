{{ config(materialized='table') }}


with src as (
  select * from {{source('lnd', 'raw_warehouses')}}
)
select
  md5(warehouse_id) as dim_warehouse_id,
  warehouse_id,
  warehouse_name,
  state,
  region
from src