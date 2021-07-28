/*Question: List customers who have an order prior to the
last order of a customer named Sharyn Hopkins and are residents
of the city of San Diego.*/

with T1 as
(
select MAX(b.order_date) as last_order
from sales.customers A,  sales.orders B
where A.customer_id = B.customer_id 
and first_name = 'Sharyn' 
and last_name = 'Hopkins'
)

select A.customer_id, first_name, last_name, city,order_date from sales.customers A, sales.orders B, T1 C
where A.customer_id = B.customer_id
and B.order_date < C.last_order
and city = 'San Diego'

-- 0'dan 9 a kadar herbir rakam bir satýrda olacak þekilde bir tablo oluþturalým.

with T1 as
(
select 0 number
union all
select number +1
from T1
where number < 10
)
select * from t1


-- Question: Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soy isimlerini listeleyin
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento' 
UNION ALL
SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'

--
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento' or city = 'Monroe'

-- 3 yol
SELECT last_name
FROM sales.customers
WHERE city in ('Sacramento','Monroe')


-- 2016 ve 2017 yýlýnda ürünleri olan markalarý getirin.
-- write a query that return brands that have products for both 2016 and 2017
select brand_name 
from production.brands A, production.products B
where A.brand_id = B.brand_id
and model_year = 2016

intersect

select brand_name 
from production.brands A, production.products B
where A.brand_id = B.brand_id
and model_year = 2017

--- diðer tol
SELECT	*
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)

-- write a query that returns customers who have orders for both 2016,2017 and 2018

select first_name, last_name
from sales.customers A, sales.orders B
where A.customer_id = B.customer_id
and YEAR(order_date) = 2016

intersect

select first_name, last_name
from sales.customers A, sales.orders B
where A.customer_id = B.customer_id
and YEAR(order_date) = 2017

intersect

select first_name, last_name
from sales.customers A, sales.orders B
where A.customer_id = B.customer_id
and YEAR(order_date) = 2018


-- ikinci yol 
SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						) 

----Question: Write a query that returns only products ordered in 2017 (not ordered in other years).
SELECT brand_name, product_name, model_year
FROM production.brands A,production.products B
WHERE A.brand_id=B.brand_id AND 
model_year =2017
EXCEPT
SELECT brand_name, product_name, model_year
FROM production.brands A,production.products B
WHERE A.brand_id=B.brand_id AND
model_year=2016

--- write a query that returns only products ordered in 2017 (not ordered in other years)
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and year(order_date) = 2017

except

select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and YEAR(order_date) <> 2017

-- ikinci yol
SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)



select distinct order_status,
	case order_status when 1 then 'pending'
					  when 2 then 'Processing'
					  when 3 then 'Rejected'
					  when 4 then 'Completed'
	end as Mean_of_Status
from sales.orders

-- Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

select email,case
			when email like '%yahoo%' then 'yahoo'
			when email like '%gmail%' then 'gmail'
			when email like '%hotmail%' then 'hotmail'
			else 'other'
		end as mail_provider
from sales.customers


-- Question: Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT email,
		CASE        WHEN email LIKE '%gmail%' THEN 'GMAIL'
					WHEN email LIKE '%hotmail%' THEN 'HOTMAIL'
					WHEN email LIKE '%yahoo%' THEN 'YAHOO'
					ELSE 'OTHER'
		END AS email_service_providers
FROM sales.customers