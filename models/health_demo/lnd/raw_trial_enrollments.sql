{{ config(materialized='table') }}

select 
  *
from {{ ref('trial_enrollments') }}