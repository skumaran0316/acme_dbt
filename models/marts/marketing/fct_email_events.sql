with src as (
    select * from {{ ref('stg_mailchimp__email_events') }}
),

dim_customers as (
    select customer_id, dim_customer_id
    from {{ ref('dim_customers') }}
)

select
    src.event_id,
    dc.dim_customer_id,
    src.event as event_type,
    src.event_time,
    current_timestamp as record_loaded_ts
from src
left join dim_customers dc
    on src.customer_id = dc.customer_id
