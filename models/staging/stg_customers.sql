{{ config( materialized= 'view' ) }}

select
        id as customer_id,
        name

    from `dbt-best-practices-dev.jaffle_shop_raw.customers`