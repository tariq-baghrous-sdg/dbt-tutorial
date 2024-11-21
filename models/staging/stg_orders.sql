{{ config( materialized= 'view' ) }}


select
        id as order_id,
        customer as customer_id,
        ordered_at,

    from `dbt-best-practices-dev.jaffle_shop_raw.orders`