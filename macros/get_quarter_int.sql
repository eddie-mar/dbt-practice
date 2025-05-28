{#
    This macro returns the quarter for a given month (number only)
#}

{% macro get_quarter_int(datetime) %}
    
    case extract(month from {{datetime}})
        {% for i in range(1,13) %}
            when {{i}} then {{(i + 2) // 3}}
        {% endfor %}
        else 'EMPTY'
        end

{%- endmacro %}