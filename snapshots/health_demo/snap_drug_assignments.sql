{% snapshot snap_drug_assignments %}

{{
  config(
    target_schema='snapshots',
    unique_key='assignment_id',
    strategy='check',
    check_cols=[
      'trial_id',
      'drug_id',
      'arm_label',
      'frequency',
      'dosage_mg',
    ]
  )
}}

select *
from {{ ref('int_trial_drug_assignments') }}

{% endsnapshot %}