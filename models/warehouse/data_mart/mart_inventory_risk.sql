{{ config(materialized='table')}}

with inventory_summary as (
    select
        i.snapshot_date,
        p.product_id,
        p.product_name,
        p.category,
        sum(i.quantity_on_hand) as total_quantity_on_hand,
        sum(i.quantity_available) as total_quantity_available,
        sum(i.quantity_reserved) as total_quantity_reserved,
        sum(i.reorder_point) as reorder_point,
        case 
            when sum(i.quantity_available) < sum(i.reorder_point) then 'Critical'
            when sum(i.quantity_available) < sum(i.reorder_point) * 1.5 then 'Warning'
            else 'Healthy'
        end as inventory_risk
    from {{ref('fct_inventory_snapshots')}} i
    left join {{ref('dim_products')}} p on i.dim_product_id = p.dim_product_id
    group by i.snapshot_date, p.product_id, p.product_name, p.category
)
select
    *,
    round(avg(total_quantity_available) over (partition by product_name order by snapshot_date rows between 6 preceding and current row)) as rolling_7_day_avg_available,
    round(avg(total_quantity_available) over (partition by product_name order by snapshot_date rows between 13 preceding and current row)) as rolling_14_day_avg_available
from inventory_summary
order by snapshot_date desc