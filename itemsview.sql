USE [ecommerce]
GO

/****** Object:  View [dbo].[orderitems]    Script Date: 05/09/2025 11:34:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[orderitems] as 
	SELECT 
	i.order_id,
	o.customer_unique_id,
	i.order_item_id,
	i.seller_id,
	round(i.price,2) price,
	round(i.freight_value,2) freight_value,
	round((i.price+ i.freight_value),2) total,
	product_category_english,
	o.order_status,
	o.payment_type,
	o.review_score,
	o.order_purchase_timestamp as order_datetime,
	o.order_delivered_customer_date as deliver_date,
	o.order_estimated_delivery_date as estimated_delivery

	from ecommerce.dbo.olist_order_items_dataset i
	left join ecommerce.dbo.olist_orders_dataset o
	on i.order_id = o.order_id

GO

