
  create view "contosodb"."dbt_schema"."stg_contoso__stores__dbt_tmp"
    
    
  as (
    SELECT * FROM PUBLIC.DIMSTORES
  );