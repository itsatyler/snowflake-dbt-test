{{ config(materialized='view') }}

select
  cast(end_date as date) as end_date,
  case
    when phase = 'Phase IV' then cast('Phase 4' as varchar)
    when phase = 'Phase III' then cast('Phase 3' as varchar)
    when phase = 'Phase II' then cast('Phase 2' as varchar)
    when phase = 'Phase I' then cast('Phase 1' as varchar)
    else cast(phase as varchar)
  end as phase,
  cast(sponsor_name as varchar) as sponsor_name,
  cast(lower(trim(status)) as varchar) as status,
  cast(therapeutic_area as varchar) as therapeutic_area,
  cast(upper(trim(trial_id)) as varchar) as trial_id,
  cast(upper(trim(trial_name)) as varchar) as trial_name,
  cast(updated_at as date) as updated_at
from {{ source('lnd', 'raw_clinical_trials') }}