{{
    config(
        tags=['unit-test']
    )
}}

{% set options = {"mocking_strategy": "FULL"}%}

{% call dbt_unit_testing.test('customers', 'should show customer_id without orders', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.expect() %}
    select 1 as customer_id
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('customers', 'should show customer name', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 'John' as first_name, 'Doe' as last_name
  {% endcall %}
  
  {% call dbt_unit_testing.expect() %}
    select 'John' as first_name, 'Doe' as last_name
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('customers', 'should sum order values to calculate customer_lifetime_value', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_orders', options) %}
    select 1 as order_id, 1 as customer_id
    UNION ALL
    select 2 as order_id, 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_payments', options) %}
    select 1 as order_id, 10 as amount
    UNION ALL
    select 2 as order_id, 10 as amount
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
    select 1 as customer_id, 20 as customer_lifetime_value
  {% endcall %}
{% endcall %}


UNION ALL

{% call dbt_unit_testing.test('customers', 'should calculate the number of orders', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_orders', options) %}
    select 1 as order_id, 1 as customer_id
    UNION ALL
    select 2 as order_id, 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_payments', options) %}
    select 1 as order_id, 0 as amount
    UNION ALL
    select 2 as order_id, 0 as amount
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
    select 1 as customer_id, 2 as number_of_orders
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('customers', 'should calculate most recent order', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_orders', options) %}
    select 1 as order_id, 1 as customer_id, '2020-10-01'::Timestamp as order_date
    UNION ALL
    select 2 as order_id, 1 as customer_id, '2021-01-02'::Timestamp as order_date
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_payments', options) %}
    select 1 as order_id
    UNION ALL
    select 2 as order_id
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
    select 1 as customer_id, '2021-01-02'::Timestamp as most_recent_order
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('customers', 'should calculate first order', options) %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers', options) %}
    select 1 as customer_id
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_orders', options) %}
    select 1 as order_id, 1 as customer_id, '2020-10-01'::Timestamp as order_date
    UNION ALL
    select 2 as order_id, 1 as customer_id, '2021-01-02'::Timestamp as order_date
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_payments', options) %}
    select 1 as order_id
    UNION ALL
    select 2 as order_id
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
    select 1 as customer_id, '2020-10-01'::Timestamp as first_order
  {% endcall %}
{% endcall %}