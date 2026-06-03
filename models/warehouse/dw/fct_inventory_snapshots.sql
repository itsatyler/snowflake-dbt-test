{{ config(materialized='table') }}

SELECT
  md5(concat(lnd.snapshot_date, lnd.warehouse_id, lnd.product_id)) as fct_inventory_snapshots_id,
  lnd.snapshot_date,
  w.dim_warehouse_id,
  p.dim_product_id,
  lnd.quantity_on_hand,
  lnd.quantity_reserved,
  lnd.quantity_available,
  lnd.reorder_point
from {{source('lnd','raw_inventory_snapshots')}} lnd
left join {{ref('dim_products')}} p on lnd.product_id = p.product_id
left join {{ref('dim_warehouses')}} w on lnd.warehouse_id = w.warehouse_id