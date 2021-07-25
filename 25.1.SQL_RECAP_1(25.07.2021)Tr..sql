---------------- SQL_RECAP_1(25.07.2021)Tr. --------------------------

----1. All the cities in the Texas and the numbers of customers in each city.---

SELECT A.city, COUNT(A.city) AS number_of_customer
FROM sales.customers AS A
WHERE A.state = 'TX'
GROUP BY A.city
ORDER BY A.city

----2. All the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

SELECT A.city, COUNT(A.city) AS number_of_customer
FROM sales.customers AS A
WHERE A.state = 'CA'
GROUP BY A.city
HAVING COUNT(A.city) > 5
ORDER BY COUNT(A.city) DESC;

-----3. The top 10 most expensive products------

SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_price DESC

-----4. Product name and list price of the products which are located in the store id 2 and the quantity is greater than 25------

SELECT A.product_name, A.list_price
FROM production.products AS A, production.stocks AS B
WHERE A.product_id = B.product_id AND B.store_id = 2 AND B.quantity > 25
ORDER BY product_name;

-----5. Find the customers who locate in the same zip code------

SELECT A.zip_code,
A.first_name+' '+A.last_name AS customer1,
B.first_name+' '+B.last_name AS customer2
FROM sales.customers AS A
JOIN sales.customers AS B
ON A.zip_code = B.zip_code
WHERE a.customer_id != b.customer_id
ORDER BY zip_code, customer1, customer2

-- 2. WAY

SELECT a.zip_code,



-----6. Return first name, last name, e-mail and phone number of the customers------

SELECT first_name+' '+last_name as full_name, email, COALESCE(phone, 'n/a') AS phone 
FROM sales.customers

-- 2. WAY

SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')


-----7. Find the sales order of the customers who lives in Houston order by order date------

SELECT order_id, order_date, customer_id

-- 2. WAY

SELECT A.order_id, A.order_date, B.customer_id

-----8. Find the products whose list price is greater than the average list price of all products with the Electra or Heller ------

SELECT DISTINCT A.product_name, A.list_price
FROM production.products AS A
WHERE A.list_price >   (SELECT AVG(B.list_price)
						FROM production.products AS B
						JOIN production.brands AS C
						ON B.brand_id = C.brand_id
						WHERE brand_name='Electra' OR brand_name='Heller'
						)
ORDER BY list_price;

-- 2. WAY

SELECT DISTINCT(product_name), list_price
FROM production.products
WHERE list_price > (
					SELECT AVG(list_price)
					FROM production.brands A
					INNER JOIN production.products B
					ON A.brand_id = B.brand_id
					WHERE A.brand_name IN ('Electra', 'Heller'))
ORDER BY list_price ASC;

-- 3. WAY

SELECT DISTINCT product_name,list_price


-----9. Find the products that have no sales ------

SELECT product_id
FROM production.products
EXCEPT
SELECT product_id
FROM sales.order_items

-- 2. WAY

SELECT product_id


---- 10. Return the average number of sales orders in 2017 sales----

SELECT staff_id, COUNT(order_id) AS sales_count


WITH cte_avg_sale AS (

-- 2. WAY

--Total_Orders_2017 ad�nda bir Tablo olu�tur
SELECT COUNT(order_id) AS Count_of_Sales

-- 3.WAY

SELECT AVG(A.sales_amounts) AS 'Average Number of Sales'


----11  By using view get the sales by staffs and years using the AVG() aggregate function:

SELECT S.first_name, S.last_name, YEAR(O.order_date) as year, AVG((I.list_price - I.discount) * I.quantity) AS avg_amount

-- 2. WAY

CREATE VIEW sales.staff_sales (first_name, last_name, year, avg_amount)

-- 3. WAY

CREATE VIEW view_table AS
