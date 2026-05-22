select *from {{ ref('int_line_items') }}

where round(EXTENDED_PRICE_EUR / 0.86, 2)
    != round(EXTENDED_PRICE_USD, 2)