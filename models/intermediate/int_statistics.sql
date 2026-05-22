

with final as (

    select

        ps.PS_PARTKEY as part_id,
        p.P_NAME as PART_NAME,
        s.S_NAME as SUPPLIER_NAME,
        s.s_suppkey as supplier_id,


        ------------------------------------------------------------------
        -- Audit Columns
        ------------------------------------------------------------------

        current_user() as LOADED_BY,

        current_timestamp() as LOADED_TIME,

        ------------------------------------------------------------------
        -- Inventory Value USD
        ------------------------------------------------------------------

        ps.PS_AVAILQTY * ps.PS_SUPPLYCOST
            as INVENTORY_VALUE_USD,

        ------------------------------------------------------------------
        -- Unit Margin
        ------------------------------------------------------------------

        p.P_RETAILPRICE - ps.PS_SUPPLYCOST
            as UNIT_MARGIN,

        ------------------------------------------------------------------
        -- Margin Percent
        ------------------------------------------------------------------

        round(
            coalesce(
                (
                    (p.P_RETAILPRICE - ps.PS_SUPPLYCOST)
                    / nullif(p.P_RETAILPRICE,0)
                ) * 100,
                0
            ),
            2
        ) as MARGIN_PERCENT,

        ------------------------------------------------------------------
        -- Inventory Level
        ------------------------------------------------------------------

        case

            when ps.PS_AVAILQTY >= 8000
                then 'HIGH'

            when ps.PS_AVAILQTY >= 3000
                then 'MEDIUM'

            else 'LOW'

        end as INVENTORY_LEVEL,

        ------------------------------------------------------------------
        -- Supplier Financial Health
        ------------------------------------------------------------------

        case

            when s.S_ACCTBAL > 5000
                then 'PREMIUM'

            when s.S_ACCTBAL <= 0
                then 'RISK'

            else 'STANDARD'

        end as SUPPLIER_FINANCIAL_HEALTH,

        ------------------------------------------------------------------
        -- Supplier Data Status
        ------------------------------------------------------------------

        case

            when s.S_PHONE is null
                 or s.S_ADDRESS is null

                then false

            else true

        end as SUPPLIER_DATA_STATUS,

        ------------------------------------------------------------------
        -- Margin Status Normal
        ------------------------------------------------------------------

        case

            when ps.PS_SUPPLYCOST > p.P_RETAILPRICE
                then false

            else true

        end as MARGIN_STATUS_NORMAL

    from {{ source('src','partsupps') }} ps

    join {{ source('src','parts') }} p
        on ps.PS_PARTKEY = p.P_PARTKEY

    join {{ source('src','suppliers') }} s
        on ps.PS_SUPPKEY = s.S_SUPPKEY

)

select

    *,

    ------------------------------------------------------------------
    -- Inventory Value EUR
    ------------------------------------------------------------------

    {{ usd_eur('INVENTORY_VALUE_USD') }}
        as INVENTORY_VALUE_EUR

from final