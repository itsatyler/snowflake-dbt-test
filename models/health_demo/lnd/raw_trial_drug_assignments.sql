{{ config(materialized='table') }}

select 
  *
from {{ ref('trial_drug_assignments') }}