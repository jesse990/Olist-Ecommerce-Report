CREATE VIEW product_pairs AS
WITH product_orders AS (
  SELECT order_id, product_category
  FROM orderitems
  GROUP BY order_id, product_category
),
pairs AS (
  SELECT 
    a.product_category AS category_1,
    b.product_category AS category_2
  FROM product_orders a
  JOIN product_orders b 
    ON a.order_id = b.order_id AND a.product_category < b.product_category
)
SELECT 
  category_1,
  category_2,
  CONCAT(category_1, ', ', category_2) AS pair,
  COUNT(*) AS pair_count
FROM pairs
GROUP BY category_1, category_2;
