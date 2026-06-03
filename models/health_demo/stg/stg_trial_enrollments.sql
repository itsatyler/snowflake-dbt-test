{{ config(materialized='view') }}

select
  lower(trim(current_status)) as current_status,
  {{ safe_cast('enrolled_date','date') }} as enrolled_date,
  upper(trim(enrollment_id)) as enrollment_id,
  upper(trim(patient_id)) as patient_id,
  upper(trim(trial_id)) as trial_id,
  {{ safe_cast('withdrawal_date','date') }} as withdrawal_date,
  {{ safe_cast('updated_at', 'date') }} as updated_at,
  withdrawal_reason
from {{ source('lnd','raw_trial_enrollments') }}