select d.productkey , d.productname, pc.productcategoryname  from public.dimproduct d 
join public.dimproductsubcategory ds 
on d.productsubcategorykey  = ds.productsubcategorykey 
join public.dimproductcategory pc 
on pc.productcategorykey = ds.productcategorykey