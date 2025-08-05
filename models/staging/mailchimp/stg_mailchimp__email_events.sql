with source as (
    select * from {{ source('mailchimp', 'email_events') }}
)

select
    event_id,
    customer_id,
    lower(trim(event)) as event,
    cast(event_time as timestamp) as event_time,
    CURRENT_TIMESTAMP AS record_loaded_ts
from source
