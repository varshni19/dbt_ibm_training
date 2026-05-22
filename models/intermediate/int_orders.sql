-- SELECT *
-- FROM {{ ref('stg_orders') }}

{{ config(materialized='incremental',unique_key='order_id') }}

SELECT
{{ dbt_utils.generate_surrogate_key(['order_id', 'customer_id'])}} as order_key,
    order_id,
    order_date,
    customer_id,
    clerk_name,
    -- USD
    total_price AS total_price_usd,
    -- EUR
    {{ usd_eur('total_price') }}
        AS total_price_eur,
    status_code,
    priority_code,
    ship_priority,
    comment,
    upd_date
FROM {{ ref('stg_orders') }}


{% if dbt.is_incremental() %}
WHERE upd_date >
(
    SELECT MAX(upd_date)
    FROM {{ this }}
)
{% endif %}