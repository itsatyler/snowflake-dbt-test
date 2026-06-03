{{ config(materialized="table") }}

with shipments as (
  select distinct shipment_status as status from {{source('lnd', 'raw_shipments')}}
),
orders as (
  select distinct order_status as status from {{source('lnd','raw_orders')}}
),
payments as (
  select distinct payment_status as status from {{source('lnd','raw_payments')}}
),
combined as (
  select status from shipments
  union
  select status from orders
  union
  select status from payments
)
select
  md5(status) as dim_status_id,
  status,
  current_timestamp() as last_updated
from combined