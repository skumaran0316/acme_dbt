with source as (
    select * from {{ source('salesforce', 'customers') }}
)

select
    id as customer_id,
    lower(trim(first_name)) as first_name,
    lower(trim(last_name)) as last_name,
    lower(trim(email)) as email,
    cast(signup_date as date) as signup_date,
    CURRENT_TIMESTAMP AS record_loaded_ts
from source
