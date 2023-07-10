-- What is the total amount each customer spent at the restaurant?
SELECT s.customer_id,
       SUM(m.price) total_amount_spent_by__each_customer
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
 GROUP BY 1
 ORDER BY 1;
 
 -- How many days has each customer visited the restaurant?
 SELECT s.customer_id,
        COUNT(s.order_date) no_of_days_visited_by_each_customer
   FROM dannys_diner.sales s
   GROUP BY 1
   ORDER BY 1;
   
-- What was the first item from the menu purchased by each customer? 
WITH ITEM AS
(
SELECT s.customer_id,
       m.product_name,
       ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) 
Rolling_number
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
 ORDER BY s.order_date, 1
)
SELECT customer_id,
       product_name
  FROM ITEM
 WHERE Rolling_number = 1; 
 
-- 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT s.customer_id,
       COUNT(m.product_id) Number_of_purchased_time
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;
 
-- 5.Which item was the most popular for each customer?
WITH POPULAR_ITEM AS
(
SELECT s.customer_id,
       m.product_name,
       COUNT(m.product_id) Number_of_purchased_time,
       DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(m.product_id) DESC) Rank_item
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
 GROUP BY 1,2
)
SELECT customer_id,
       Number_of_purchased_time
  FROM POPULAR_ITEM
 WHERE Rank_item = 1;

-- 6.Which item was purchased first by the customer after they became a member?
WITH first_purchased_item AS
(
SELECT s.customer_id,
       m.product_name,
       s.order_date,
       ms.join_date,
       ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) Rolling_number
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
  JOIN dannys_diner.members ms
    ON s.customer_id = ms.customer_id
 WHERE s.order_date >= ms.join_date
)
SELECT customer_id,
       product_name,
       order_date,
       join_date
  FROM first_purchased_item
 WHERE Rolling_number = 1;

-- 7.Which item was purchased just before the customer became a member?
WITH first_purchased_item AS
(
SELECT s.customer_id,
       m.product_name,
       s.order_date,
       ms.join_date,
       ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) Rolling_number
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
  JOIN dannys_diner.members ms
    ON s.customer_id = ms.customer_id
 WHERE s.order_date < ms.join_date
)
SELECT customer_id,
       product_name,
       order_date,
       join_date
  FROM first_purchased_item
 WHERE Rolling_number = 1;


 
 
 
 
 
 
 
 
