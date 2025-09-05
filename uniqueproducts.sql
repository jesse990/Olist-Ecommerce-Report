USE [ecommerce]
GO

/****** Object:  View [dbo].[uniqueproducts]    Script Date: 05/09/2025 12:18:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uniqueproducts] as 
with rankedcustomer as(
	select *,
		row_number() over(partition by product_id order by order_id) as rownum
	from ecommerce.dbo.olist_order_items_dataset)

select product_id,
	   round(price,2) as price,
	   replace(product_category_english, '_',' ') as product_category
from rankedcustomer
where rownum = 1
	   
GO

