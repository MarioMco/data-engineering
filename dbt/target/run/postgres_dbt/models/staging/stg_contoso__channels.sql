
  create view "contosodb"."dbt_schema"."stg_contoso__channels__dbt_tmp"
    
    
  as (
    SELECT
CHANNELKEY,
CHANNELNAME
FROM PUBLIC.DIMCHANNEL
  );