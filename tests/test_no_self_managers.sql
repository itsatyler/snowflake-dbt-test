select *
from {{ ref('dim_employees') }}
where employee_id = manager_id