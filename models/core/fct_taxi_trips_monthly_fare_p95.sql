{{
    config(
        materialized='table'
    )
}}

with trip_data as (
    select *,
    avg(fare_amount) 
        over (partition by extract(year from pickup_datetime), extract(month from pickup_datetime)) 
        as avg_revenue,
    percentile_cont(fare_amount, 0.97) 
        over (partition by extract(year from pickup_datetime), extract(month from pickup_datetime))
        as p97,
    percentile_cont(fare_amount, 0.95) 
        over (partition by extract(year from pickup_datetime), extract(month from pickup_datetime))
        as p95,
    percentile_cont(fare_amount, 0.90) 
        over (partition by extract(year from pickup_datetime), extract(month from pickup_datetime))
        as p90
    from {{ ref("fact_trips") }}
    where fare_amount > 0 and trip_distance > 0 and payment_type_description in ('Credit card', 'Cash')
)

select DISTINCT
    service_type,
    extract(year from pickup_datetime) as revenue_year,
    extract(month from pickup_datetime) as revenue_month,
    avg_revenue,
    p90,
    p95,
    p97
from trip_data
order by 1, 2, 3




