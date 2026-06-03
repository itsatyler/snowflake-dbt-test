{{ config(materialized='table') }}

select 
  *
from {{ source('seed','clinical_trials') }}