select *
from ecommerce.dbo.customer_dim
where customer_unique_id in (
    select customer_unique_id
    from ecommerce.dbo.customer_dim
    group by customer_unique_id
    having count(*) > 1
)
order by customer_unique_id ;
-- results show duplicates were due to differing zipcodes for some customer orders