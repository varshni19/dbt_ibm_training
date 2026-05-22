{{
    config(
        materialized='incremental',
        unique_key='nation_id',
        incremental_strategy='merge'
    )
}}

with source_data as (

    select
        nation_id,
        name,
        region_id,
        comment,

        md5(
            concat(
                coalesce(name,''),
                coalesce(region_id,0),
                coalesce(comment,'')
            )
        ) as hash_value

    from {{ ref('stg_nations') }}

),

final as (

    select *
    from source_data

    {% if is_incremental() %}

    where nation_id not in (

        select nation_id
        from {{ this }}

    )

    or hash_value not in (

        select hash_value
        from {{ this }}

    )

    {% endif %}

)

select * from final