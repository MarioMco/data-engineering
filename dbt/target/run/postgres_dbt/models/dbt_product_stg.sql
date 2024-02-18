
  create view "contosodb"."dbt_schema"."dbt_product_stg__dbt_tmp"
    
    
  as (
    select d.productkey , d.productname, pc.productcategoryname  from public.dimproduct d 
join public.dimproductsubcategory ds 
on d.productsubcategorykey  = ds.productsubcategorykey 
join public.dimproductcategory pc 
on pc.productcategorykey = ds.productcategorykey
  );