
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
SELECT a.zip_code,a.first_name+' '+a.last_name as customer1,b.first_name+' '+b.last_name as customer2FROM sales.customers as  a, sales.customers b WHERE a.customer_id > b.customer_idAND a.zip_code = b.zip_codeORDER BY zip_code,customer1,customer2


-----6. Return first name, last name, e-mail and phone number of the customers------
select first_name, last_name,email,coalesce(phone, 'no number') phone

from sales.customers

-- ikinci yol
SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')FROM sales.customers;


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

-- doðru çözüm
SELECT DISTINCT product_name,list_priceFROM production.productsWHERE list_price > (SELECT AVG (list_price)FROM production.productsWHERE brand_id in (SELECT brand_idFROM production.brandsWHERE brand_name = 'Electra'OR brand_name='Heller'))ORDER by list_price

-- 3. yol
select distinct product_name, list_pricefrom production.productswhere list_price > (select avg(p.list_price)					from production.products p					inner join production.brands b					on b.brand_id = p.brand_id					where b.brand_name = 'Electra' or b.brand_name = 'Heller')order by list_price


-----9. Find the products that have no sales ------
SELECT product_idFROM production.productsEXCEPTSELECT product_idFROM sales.order_items

-- ikinci yol
SELECT product_idFROM production.productsWHERE product_id NOT IN (						SELECT product_id						FROM sales.order_items);


---- 10. Return the average number of sales orders in 2017 sales----
WITH cte_avg_sale AS(	SELECT staff_id, Count(order_id) as sales_count	FROM sales.orders	WHERE YEAR(order_date)=2017	GROUP BY staff_id	)SELECT AVG(sales_count) as 'Average Number of Sales'FROM cte_avg_sale

-- ikinci yol
SELECT COUNT(order_id) AS Count_of_SalesINTO Total_Orders_2017FROM sales.ordersWHERE YEAR(order_date) = 2017;SELECT COUNT(first_name) AS Count_of_StaffsINTO Staffs_Sold_2017FROM sales.staffsWHERE staff_id IN (				SELECT staff_id				FROM sales.orders				WHERE YEAR(order_date) = 2017);SELECT A.Count_of_Sales / B.Count_of_Staffs AS 'Average Number of Sales'FROM Total_Orders_2017 A, Staffs_Sold_2017 B;

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
select s.first_name, s.last_name, year(o.order_date) as year, avg((i.list_price-i.discount)*i.quantity) as avg_amountfrom sales.staffs sinner join sales.orders oon s.staff_id=o.staff_idinner join sales.order_items ion o.order_id=i.order_idgroup by s.first_name, s.last_name, year(o.order_date)order by first_name, last_name, year(o.order_date)


-- view daha kýsa yol farklý yol

CREATE VIEW sales.staff_sales (        first_name,         last_name,        year,         avg_amount)AS     SELECT         first_name,        last_name,        YEAR(order_date),        AVG(list_price * quantity) as avg_amount    FROM        sales.order_items i    INNER JOIN sales.orders o        ON i.order_id = o.order_id    INNER JOIN sales.staffs s        ON s.staff_id = o.staff_id    GROUP BY         first_name,         last_name,         YEAR(order_date);--------------SELECT      * FROM     sales.staff_salesORDER BY 	first_name,	last_name,	year;

