
--review table isnt 1 row per order, this code is to identify order ids with multiple reviews per order
SELECT order_id,
	   COUNT(order_id) as countrows
FROM [ecommerce2].[dbo].olist_order_reviews_dataset
GROUP BY order_id
HAVING COUNT(order_id) >1

/*inspecting the reviews for said order
  we see 2 separate reviews at 2 different dates*/
SELECT *
FROM ecommerce2.dbo.olist_order_reviews_dataset
WHERE order_id = '09a38776c4e31230864f867821174daa'

--Checking how many items in order
SELECT *
FROM ecommerce2.dbo.olist_order_items_dataset
WHERE order_id = '09a38776c4e31230864f867821174daa'

-- checking order table for delivery date
SELECT *
FROM ecommerce2.dbo.olist_orders_dataset
WHERE order_id = '09a38776c4e31230864f867821174daa'