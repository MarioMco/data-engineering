
  create view "contosodb"."dbt_schema"."stg_contoso__products__dbt_tmp"
    
    
  as (
    select * from public.dimproducts
  );