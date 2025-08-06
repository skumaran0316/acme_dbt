with customers as (
    select * from {{ ref('stg_salesforce__customers') }}
),

demographics as (
    select * from {{ ref('stg_salesforce__customer_demographics') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as dim_customer_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    d.age,
    d.gender,
    d.country,
    d.loyalty_status,
    current_timestamp as record_loaded_ts,
    date(current_timestamp) as effective_start_date,
    9999/12/31 as effective_end_date,
    'Y' as is_current
from customers c
left join demographics d
    on c.customer_id = d.customer_id
