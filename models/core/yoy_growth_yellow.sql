{{
    config(
        materialized='table'
    )
}}

with yellow_quarterly as (
    select *,
    lag(revenue_quarterly, 4, 0) over (order by 
        revenue_year,
        case revenue_quarter
            when 'Q1' then 1
            when 'Q2' then 2
            when 'Q3' then 3
            when 'Q4' then 4
            else 0
        end) as prev_year_revenue
    from {{ ref("fct_taxi_trips_quarterly_revenue") }}
    where service_type="Yellow"
)

select
    service_type,
    revenue_year,
    revenue_quarter,
    year_quarter,
    revenue_quarterly,
    prev_year_revenue,
    case
        when prev_year_revenue=0 then null
        else ((revenue_quarterly - prev_year_revenue)/ prev_year_revenue) * 100
    end as year_over_year_growth

from yellow_quarterly
order by revenue_year,
    case revenue_quarter
        when 'Q1' then 1
        when 'Q2' then 2
        when 'Q3' then 3
        when 'Q4' then 4
    end

