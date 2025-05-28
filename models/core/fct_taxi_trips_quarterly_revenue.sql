{{
    config(
        materialized='view'
    )
}}

with trips_data as (
    select *,
    extract(year from pickup_datetime) as revenue_year,
    {{ get_quarter("pickup_datetime") }} as revenue_quarter,
    concat (cast(extract(year from pickup_datetime) as string), '/', {{ get_quarter("pickup_datetime") }} ) as year_quarter,
    from {{ ref("fact_trips") }}
)

select
    service_type,
    year_quarter,
    revenue_year,
    revenue_quarter,

    -- analyses
    count(tripid) as total_quarterly_trips,
    avg(passenger_count) as avg_quarterly_passenger_count,
    avg(trip_distance) as avg_quarterly_trip_distance,
    sum(total_amount) as revenue_quarterly,
    

from trips_data
group by service_type, year_quarter, revenue_year, revenue_quarter