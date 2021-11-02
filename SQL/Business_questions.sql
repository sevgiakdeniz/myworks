
1. What categories of tech products does Magist have?
USE magist


SELECT product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english IN ('electronics','watches_gifts','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY product_category_name_english;






2. How many products of these tech categories have been sold (within the time window of the database snapshot)?
 What percentage does that represent from the overall number of products sold?

detailed of technology products
SELECT product_category_name_translation.product_category_name_english, COUNT( orders.order_id) as count
FROM order_items
INNER JOIN products ON order_items.product_id = products.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
INNER JOIN orders ON order_items.order_id = orders.order_id
WHERE order_status IN ('delivered') and  product_category_name_translation.product_category_name_english IN ('electronics','watches_gifts','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY product_category_name_translation.product_category_name_english
 

detailed of total product
SELECT product_category_name_translation.product_category_name_english, COUNT( orders.order_id)
FROM order_items
INNER JOIN products ON order_items.product_id = products.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
INNER JOIN orders ON order_items.order_id = orders.order_id
WHERE order_status IN ('delivered')
GROUP BY product_category_name_translation.product_category_name_english
 
Total number of products sold
SELECT COUNT( orders.order_id)
FROM order_items
INNER JOIN products ON order_items.product_id = products.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
INNER JOIN orders ON order_items.order_id = orders.order_id
WHERE order_status IN ('delivered');



Total number of TECH Products that are sold
SELECT (COUNT( orders.order_id))
FROM order_items
INNER JOIN products ON order_items.product_id = products.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
INNER JOIN orders ON order_items.order_id = orders.order_id
WHERE order_status IN ('delivered') and  product_category_name_translation.product_category_name_english IN ('electronics','watches_gifts','computers_accessories','pc_gamer','computers','consoles_games','telephony')



3.What’s the average price of the products being sold?

SELECT ROUND(AVG(price),0)
FROM order_items
INNER JOIN orders
ON order_items.order_id = orders.order_id
WHERE order_status IN ('delivered')







4.Are expensive tech products popular? *

SELECT 
product_category_name_translation.
product_category_name_english,
max(order_items.price),count(order_items.product_id) AS count
FROM order_items                               
INNER JOIN products ON products.product_id = order_items.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY product_category_name_translation.product_category_name_english



SELECT p.product_category_name, pt.product_category_name_english as 'ENGLISH',
    MAX(oi.price) AS 'Most Expensive',
    CASE 
    WHEN COUNT(DISTINCT p.product_id) >= 1000 THEN "HOT" 
    WHEN COUNT(DISTINCT p.product_id) >= 750  THEN "ON HIGH DEMAND"
    WHEN COUNT(DISTINCT p.product_id) >= 500  THEN "AVERAGE DEMAND"
    WHEN COUNT(DISTINCT p.product_id) >= 250  THEN "LOW DEMAND"
    WHEN COUNT(DISTINCT p.product_id) <  250  THEN "NOT INTERESTING"
    END AS Popularity
FROM products p
JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
JOIN order_items oi ON p.product_id = oi.product_id
    WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony','watches_gifts')
GROUP BY p.product_category_name
ORDER BY MAX(oi.price) DESC;




							 
SELECT 
    order_items.product_id,
    product_category_name_english,
    COUNT(order_items.product_id) AS count,
    max(price) as max_price
FROM
    order_items
        INNER JOIN
    products ON products.product_id = order_items.product_id
INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY order_items.product_id
order by max_price desc






SELECT 
    products.product_category_name, product_category_name_translation.product_category_name_english as 'Name in english',
    COUNT(DISTINCT products.product_id) AS n_products,
    CASE 
    WHEN COUNT(DISTINCT products.product_id) >= 1000 THEN "Hign popularity"
    WHEN COUNT(DISTINCT products.product_id) >= 500  THEN "Low popularity"
    ELSE "no popularity"
    END AS Popularity
FROM products
JOIN product_category_name_translation
    ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY products.product_category_name
ORDER BY COUNT(products.product_id) DESC;


5In relation to the sellers:

How many sellers are there?
SELECT COUNT(DISTINCT seller_id)
FROM order_items


select YEAR() from order_payments


SELECT seller_id, 
YEAR(order_purchasetimestamp) AS year,
MONTH(order_purchasetimestamp) AS month,
ROUND(AVG(price),0)
order_item_id
FROM orders
INNER JOIN order_items ON orders.order_id = order_items.order_id
WHERE YEAR(order_purchase_timestamp) = "2018"
GROUP BY MONTH(order_purchase_timestamp);


6.What’s the average monthly revenue of Magist’s sellers?


SELECT 
YEAR(order_purchase_timestamp) AS year,
MONTH(order_purchase_timestamp) AS month, Round(AVG(payment_value))
FROM order_payments
INNER JOIN orders ON order_payments.order_id = orders.order_id
Group by year,month 
order by year,month asc


SELECT sum(payment_value) / (SELECT TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp) , MAX(order_purchase_timestamp)) FROM orders)
FROM order_payments



SELECT TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp) , MAX(order_purchase_timestamp)) FROM orders
SELECT MIN(order_purchase_timestamp) FROM orders

select 





SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY s.seller_id, date;


















#7.What’s the average revenue of sellers that sell tech products?

SELECT 
    product_category_name_translation.product_category_name_english AS p_name,
    ROUND(AVG(order_payments.payment_value)) AS average_revenue
FROM
    order_items
        INNER JOIN
    order_payments ON order_items.order_id = order_payments.order_id
        INNER JOIN
    products ON order_items.product_id = products.product_id
        INNER JOIN
    product_category_name_translation ON product_category_name_translation.product_category_name = products.product_category_name
WHERE
    product_category_name_english IN ('electronics' , 'computers_accessories',
        'pc_gamer',
        'computers',
        'consoles_games',
        'telephony')
GROUP BY p_name;




SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
 JOIN order_items oi ON s.seller_id = oi.seller_id
 JOIN orders o ON oi.order_id = o.order_id
 JOIN products p ON oi.product_id = p.product_id
 JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','watches_gifts')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear;





SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON o


SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear;






# 8.What’s the average time between the order being placed and the product being delivered?

USE magist
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
FROM orders










SELECT CONCAT(DAY(order_delivered_customer_date),"/",MONTH(order_delivered_customer_date)) AS day_delivered,
CONCAT(DAY(order_purchase_timestamp),"/",MONTH(order_purchase_timestamp)) AS time_purchased,
DAY(order_delivered_customer_date) - DAY(order_purchase_timestamp) AS difference
FROM orders;



#9.How many orders are delivered on time vs orders delivered with a delay?






10. Is there any pattern for delayed orders, e.g. big products being delayed more often?





