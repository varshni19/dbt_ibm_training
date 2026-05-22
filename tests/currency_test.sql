select *from {{ ref('int_statistics') }}

where round(INVENTORY_VALUE_EUR / 0.86, 2)
    != round(INVENTORY_VALUE_USD, 2)