
      
  
    

  create  table "contosodb"."dbt_schema"."stg_contoso__sales__dbt_tmp"
  
  
    as
  
  (
    
SELECT 
SALESKEY, 
CHANNELKEY, 
STOREKEY, 
PRODUCTKEY, 
UNITCOST, 
UNITPRICE, 
SALESQUANTITY, 
DISCOUNTQUANTITY, 
DISCOUNTAMOUNT, 
TOTALCOST, 
SALESAMOUNT, 
(SALESAMOUNT - TOTALCOST) AS PROFIT,
DATEKEY
FROM PUBLIC.FCTSALES


  );
  
  