
  create view "contosodb"."dbt_schema"."int_contoso__stores__dbt_tmp"
    
    
  as (
    SELECT 
STOREKEY,
STORENAME,
CASE
    WHEN STATUS = 'On' THEN 'Active'
    WHEN STATUS = 'Off' THEN 'Closed'
    ELSE 'No Status'
END AS STORESTATUS
FROM PUBLIC.DIMSTORES
  );