{{ config(materialized='table') }}

select distinct
  md5(sales_channel) as dim_sales_channels_id,
  sales_channel, 
  current_timestamp() as last_updated
from {{source('lnd', 'raw_orders')}}
