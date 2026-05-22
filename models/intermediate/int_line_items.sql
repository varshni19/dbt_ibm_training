select
    ORDER_ITEM_ID,
    ORDER_ID,
    PART_ID,
    SUPPLIER_ID,
    LINE_NUMBER,
    COMMENT,
    SHIP_MODE,
    SHIP_INSTRUCTIONS,
    QUANTITY,
    EXTENDED_PRICE as EXTENDED_PRICE_USD,

    {{ usd_eur('EXTENDED_PRICE') }}
        as EXTENDED_PRICE_EUR,

    DISCOUNT_PERCENTAGE,
    TAX_RATE,
    STATUS_CODE,
    RETURN_FLAG,
    SHIP_DATE,
    COMMIT_DATE,
    RECEIPT_DATE

from {{ ref('stg_line_items') }}