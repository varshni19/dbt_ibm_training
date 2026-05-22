SELECT
sp.*,
ac.average_available_quantity,
ac.average_supply_cost
    FROM {{ref('supplier_parts')}} as sp
        JOIN {{ref('average_cost')}} as ac
        ON
        ac.part_key = sp.part_key
