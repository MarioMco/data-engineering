{{
    config(materialized='incremental', 
           unique_key = 'SALESKEY' )
}}
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

{% if is_incremental() %}
WHERE DATEKEY >= (SELECT MAX(DATEKEY) FROM {{ this }})
{% endif %}