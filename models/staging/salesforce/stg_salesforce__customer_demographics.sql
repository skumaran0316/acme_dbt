with source as (
    select * from {{ source('salesforce', 'customer_demographics') }}
)

select
    customer_id,
    age,
    case
        when lower(gender) in ('m', 'male') then 'M'
        when lower(gender) in ('f', 'female') then 'F'
        else 'Other'
    end as gender,
    initcap(country) as country,
    upper(loyalty_status) as loyalty_status,
    CURRENT_TIMESTAMP AS record_loaded_ts
from source
