with source as (
    select * from {{ source('zendesk', 'support_tickets') }}
)

select
    ticket_id,
    customer_id,
    lower(trim(ticket_status)) as ticket_status,
    cast(created_at as timestamp) as created_at,
    cast(closed_at as timestamp) as closed_at,
    lower(trim(category)) as category
from source
