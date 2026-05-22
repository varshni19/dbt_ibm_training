select *from {{ ref('int_orders') }}

where round(TOTAL_PRICE_EUR / 0.86, 2)
    != round(TOTAL_PRICE_USD, 2)

    