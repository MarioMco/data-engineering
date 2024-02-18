
  create view "contosodb"."dbt_schema"."dbt_channel_stg__dbt_tmp"
    
    
  as (
    select * from public.dim_channel
  );