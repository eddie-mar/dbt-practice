{#
    This macro returns the quarter for a given month.
#}

{% macro get_quarter(datetime) %}
    
    case extract(month from {{datetime}})
        {% for i in range(1,13) %}
            when {{i}} then 'Q{{(i + 2) // 3}}'
        {% endfor %}
        else 'EMPTY'
        end

{%- endmacro %}