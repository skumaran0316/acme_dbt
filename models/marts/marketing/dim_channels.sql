with all_channels as (
    select channel as channel from {{ ref('stg_google_analytics__web_sessions') }}
    union
    select event as channel from {{ ref('stg_mailchimp__email_events') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['channel']) }} as dim_channel_id,
    channel as channel_name,
    current_timestamp as record_loaded_ts,
    date(current_timestamp) as effective_start_date,
    date('9999-12-31') as effective_end_date,
    'Y' as is_current
from all_channels
