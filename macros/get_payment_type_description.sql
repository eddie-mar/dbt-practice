{#
    This macro returns the description of the payment_type
    dbt.safe_cast can be case cast( {{ payment_type }} as integer)
#}

{% macro get_payment_type_description(payment_type) -%}

    case {{ dbt.safe_cast("payment_type", api.Column.translate_type("integer")) }}
        when 1 then 'Credit Card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
        else 'EMPTY'
    end

{%- endmacro %}