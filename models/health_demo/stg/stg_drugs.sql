{{ config(materialized='view') }}

select
  cast(upper(trim(drug_id)) as varchar) as drug_id,
  cast(lower(trim(approval_status)) as varchar) as approval_status,
  cast(trim(drug_class) as varchar) as drug_class,
  cast(drug_name as varchar) as drug_name,
  cast(initcap(generic_name, '') as varchar) as generic_name,
  cast(trim(manufacturer) as varchar) as manufacturer,
  cast(updated_at as date) as updated_at
from {{ source('lnd', 'raw_drugs') }}