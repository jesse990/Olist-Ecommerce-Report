USE [ecommerce]
GO

/****** Object:  View [dbo].[customer_segmentation]    Script Date: 05/09/2025 11:25:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[customer_segmentation] as

with base as (
    select 
        customer_unique_id,
        order_id,
        order_datetime,
        round(price, 2) + round(freight_value, 2) as itemvalue
    from ecommerce.dbo.orderitems

),

ordervalues as(
    select customer_unique_id,
           order_id,
           order_datetime,
           sum(itemvalue) as order_value,
           count(*) as item_count
    from base
    group by customer_unique_id, order_id, order_datetime),

orders as (
    select
        ov.customer_unique_id,
        datediff(quarter, max(order_datetime), '2018-10-17') as recency,
        count(distinct order_id) as frequency,
        case
            when sum(order_value) <=100 then 'low'
            when sum(order_value) > 100 and sum(order_value) <=250 then 'mid'
            when sum(order_value) > 250 and sum(order_value) <=400 then 'high'
            else 'veryhigh'
            end as mbins
    from ordervalues as ov
    group by ov.customer_unique_id),

rfm as (select
    customer_unique_id,
    case 
    when recency<= 2 then 4
    when recency<= 3 then 3
    when recency<= 4 then 2
    else 1 end as Rscore,
    
    case
    when frequency =1 then 1
    when frequency =2 then 2
    when frequency =3 then 3
    else 4 end as Fscore,

    case
    when mbins = 'low' then 1
    when mbins = 'mid' then 2
    when mbins = 'high' then 3
    else 4 end as Mscore
    from orders)

select customer_unique_id,
       Rscore,
       Fscore,
       Mscore,
       (Rscore + Fscore + Mscore) as rfmscore,

       case
        when (Rscore + Fscore + Mscore) <= 5 then 'low value'
        when (Rscore + Fscore + Mscore) <= 7 then 'mid value'
        when (Rscore + Fscore + Mscore) <= 8 then 'high value'
        else 'premium value'
       end as 'customercategory'
from rfm


GO

