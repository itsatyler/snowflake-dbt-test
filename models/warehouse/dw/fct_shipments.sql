{{config(materialized='table')}}

select
  md5(s.shipment_id) as fct_shipment_id,
  s.shipment_id,
  o.fct_orders_id,
  w.dim_warehouse_id,
  s.carrier,
  s.shipped_timestamp,
  s.delivered_timestamp,
  st.dim_status_id
from {{source('lnd','raw_shipments')}} s
left join {{ref('fct_orders')}} o
  on s.order_id = o.order_id
left join {{ref('dim_warehouses')}} w
  on s.warehouse_id = w.warehouse_id
left join {{ref('dim_status')}} st
  on s.shipment_status = st.status