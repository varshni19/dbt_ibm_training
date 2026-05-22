{{ config(

    pre_hook="
        copy into mkmotors_dev.staging.stg_dealership
        from @mkmotors_dev.staging.s3dealers/dealership.dat
        file_format = mkmotors_dev.staging.ff_csv_nohdr_dq
    ",

    post_hook=[
        "update mkmotors_dev.staging.stg_dealership
         set updated_date = current_timestamp()"
    ]

) }}

select *
from mkmotors_dev.staging.stg_dealership