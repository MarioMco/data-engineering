
  create view "contosodb"."dbt_schema"."dbt_factonlinesales_stg__dbt_tmp"
    
    
  as (
    select productkey, salesquantity, salesamount, discountamount from public.factonlinesales
  );