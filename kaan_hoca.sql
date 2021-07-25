
----1. All the cities in the Texas and the numbers of customers in each city.---

select city, COUNT(city) as 'number of customers' from sales.customers
where state = 'TX'
group by city
order by city

----2. All the cities in the California which has more than 5 customer, 
----by showing the cities which have more customers first.---

select city, COUNT(customer_id) as number_of_customers from sales.customers
where state = 'CA'
group by city
having COUNT(customer_id) > 5
order by number_of_customers desc

-----3. The top 10 most expensive products------
select top 10 product_name, list_price from production.products
order by list_price desc

-----4. Product name and list price of the products which are located in the store id 2 
-----and the quantity is greater than 25------
select product_name, list_price from production.products A, production.stocks B
where A.product_id = B.product_id
and store_id = 2
and quantity > 25
order by A.product_name

-----5. Find the customers who locate in the same zip code------
select zip_code,first_name, last_name  from sales.customers 
intersect 
select zip_code,first_name, last_name from sales.customers 

-- ikinci yol:
SELECT a.zip_code,


-----6. Return first name, last name, e-mail and phone number of the customers------
select first_name, last_name,email,coalesce(phone, 'no number') phone

from sales.customers

-- ikinci yol
SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')


-----7. Find the sales order of the customers who lives in Houston order by order date------
select order_id, order_date, A.customer_id from sales.orders A, sales.customers B
where A.customer_id = B.customer_id
and B.city = 'Houston'
order by A.order_date

-- ikinci yol


-----8. Find the products whose list price is greater than the average 
-----list price of all products with the Electra or Heller ------

select product_name, list_price from production.products
where list_price > 
			(select AVG(list_price) from production.products
				where product_name like '%heller%') 
or list_price > (select AVG(list_price) from production.products
				where product_name like '%Electra%') 
order by list_price

-- do�ru ��z�m
SELECT DISTINCT product_name,list_price

-- 3. yol
select distinct product_name, list_price


-----9. Find the products that have no sales ------
SELECT product_id

-- ikinci yol
SELECT product_id


---- 10. Return the average number of sales orders in 2017 sales----
WITH cte_avg_sale AS(

-- ikinci yol
SELECT COUNT(order_id) AS Count_of_Sales

-- 3. yol

----11  By using view get the sales by staffs and years using the AVG() aggregate function:

CREATE VIEW view_table AS

select A.order_id, item_id, product_id,customer_id,B.store_id, C.staff_id,quantity,list_price, discount,
C.first_name, C.last_name, year(order_date) as year

from sales.order_items A, sales.orders B, sales.staffs C

where A.order_id = B.order_id
and B.staff_id = C.staff_id;


select first_name, last_name,staff_id,year, avg((list_price-discount)*quantity) as avg_list_price from view_table
group by year,staff_id,first_name,last_name
order by year

-- ikinci yol
select s.first_name, s.last_name, year(o.order_date) as year, avg((i.list_price-i.discount)*i.quantity) as avg_amount


-- view daha k�sa yol farkl� yol

CREATE VIEW sales.staff_sales (
