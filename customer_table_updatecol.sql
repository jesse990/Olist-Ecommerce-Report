

update c
set 
	c.Rscore = s.Rscore,
	c.Fscore = s.Fscore,
	c.Mscore = s.Mscore,
	c.RFMscore = s.RFMScore,
	c.customer_category = s.customer_category

FROM ecommerce.dbo.olist_customers_dataset as c
left join customer_segmentation as s
	on c.customer_unique_id = s.customer_unique_id;