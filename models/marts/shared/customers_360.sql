{{ config(materialized='view') }}

-- Transactions aggregated at dim_customer_id level
with transactions as (
    select
        dim_customer_id,
        count(*) as total_transactions,
        sum(amount) as total_spent,
        max(transaction_date) as last_transaction_date
    from {{ ref('fct_transactions') }}
    group by dim_customer_id
),

-- Web sessions aggregated at dim_customer_id level
web_sessions as (
    select
        dim_customer_id,
        count(*) as total_sessions,
        max(session_start) as last_session_start
    from {{ ref('fct_web_sessions') }}
    group by dim_customer_id
),

-- Email events aggregated at dim_customer_id level
email_events as (
    select
        dim_customer_id,
        sum(case when event_type = 'open' then 1 else 0 end) as email_opens,
        sum(case when event_type = 'click' then 1 else 0 end) as email_clicks,
        max(event_time) as last_email_event_time
    from {{ ref('fct_email_events') }}
    group by dim_customer_id
),

-- Support tickets aggregated at dim_customer_id level
support_tickets as (
    select
        dim_customer_id,
        count(*) as total_tickets,
        max(created_at) as last_ticket_created
    from {{ ref('fct_support_tickets') }}
    group by dim_customer_id
),

-- Current customer and demographic data
current_customers as (
    select 
        dim_customer_id,
        customer_id,
        first_name,
        last_name,
        email,
        signup_date,
        age,
        gender,
        country,
        loyalty_status
    from {{ ref('dim_customers') }}
    where is_current = 'Y'
)

-- Final Customer 360 view
select
    c.dim_customer_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    c.age,
    c.gender,
    c.country,
    c.loyalty_status,
    coalesce(t.total_transactions, 0) as total_transactions,
    coalesce(t.total_spent, 0.0) as total_spent,
    t.last_transaction_date,
    coalesce(ws.total_sessions, 0) as total_sessions,
    ws.last_session_start,
    coalesce(e.email_opens, 0) as email_opens,
    coalesce(e.email_clicks, 0) as email_clicks,
    e.last_email_event_time,
    coalesce(s.total_tickets, 0) as total_tickets,
    s.last_ticket_created
from current_customers c
left join transactions t on c.dim_customer_id = t.dim_customer_id
left join web_sessions ws on c.dim_customer_id = ws.dim_customer_id
left join email_events e on c.dim_customer_id = e.dim_customer_id
left join support_tickets s on c.dim_customer_id = s.dim_customer_id
