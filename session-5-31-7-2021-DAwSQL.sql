-- List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.


SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles'
											)
					)

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset)

--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17')

insert t_date_time (A_time) 
values(TIMEFROMPARTS(13,0,0,0,0))

select * from t_date_time

insert into t_date_time (A_date) 
values (DATEFROMPARTS (2021,05,17))

insert into t_date_time (A_datetime) 
values (DATETIMEFROMPARTS (2021,05,17,20,0,2,0))

INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,00,00,0,0));
INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));
select convert(varchar, getdate(), 6)
INSERT INTO t_date_time (A_datetime) VALUES (DATETIMEFROMPARTS(2021,05,17, 20,0,0,0));
INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time


--- datediff
select a_date,
		A_datetime,
		datediff(day,a_date,a_datetime)
from t_date_time


select DATEDIFF(day, order_date, shipped_date), order_date,shipped_date
from sales.orders
where order_id between 1 and 10


select DATEADD(D,5,order_date), order_date,shipped_date
from sales.orders
where order_id = 1

select DATEADD(YEAR,5,order_date), order_date,shipped_date
from sales.orders
where order_id = 1


select EOMONTH(order_date),order_date
from sales.orders

select ISDATE(cast(order_date as nvarchar)), order_date
from sales.orders


select ISDATE('123201212')

select GETDATE()

select CURRENT_TIMESTAMP


insert  t_date_time
values(GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

select * from t_date_time


---If the product has not been shipped yet, it will be marked as "Not Shipped",
select *,
case 
		when order_status  =  4 then 'not shipped'
		when order_status  in (1,2,3) then 'shipped' end as 'Cargo Status'
from sales.orders

/*If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow".*/

select *,
case 
	when order_date is null then 'not shipped'
	when DATEDIFF(DAY,order_date,shipped_date) = 0 then 'fast' 
	when DATEDIFF(DAY,order_date,shipped_date) <= 2 then   'normal' 
	when DATEDIFF(DAY,order_date,shipped_date) >=3 then 'slow' end as 'Kargo Speed',
	datediff(DAY,order_date,shipped_date) as datediff
from sales.orders


select *,
	case 
	when shipped_date is null then 'Not Shipped'
	when order_date=shipped_date then 'Fast'
	when datediff(day, order_date, shipped_date)<=2 then 'Normal'
	when datediff(day, order_date, shipped_date )>=3 then 'Slow'
	end as speed
from sales.orders

-- write a query returns orders that are shipped more than two days after the ordered date

select *
from sales.orders
where DATEDIFF(DAY,order_date,shipped_date) > 2

--

select *,DATEDIFF(DAY,order_date,shipped_date) as date_diff
from sales.orders
where DATEDIFF(DAY,order_date,shipped_date) > 2


--Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week.

select sum(case
			when DATENAME(Dw,order_date) = 'monday' then 1 else 0 end) As Monday,
			sum(case
			when DATENAME(Dw,order_date) = 'Tuesday' then 1 else 0 end) As Tuesday,
			sum(case
			when DATENAME(Dw,order_date) = 'Wednesday' then 1 else 0 end) As Wednesday,
			sum(case
			when DATENAME(Dw,order_date) = 'Thursday' then 1 else 0 end) As Thursday,
			sum(case
			when DATENAME(Dw,order_date) = 'Friday' then 1 else 0 end) As Friday,
			sum(case
			when DATENAME(Dw,order_date) = 'Saturday' then 1 else 0 end) As Saturday,
			sum(case
			when DATENAME(Dw,order_date) = 'Sunday' then 1 else 0 end) As Sunday
from sales.orders
where DATEDIFF(DAY,order_date,shipped_date) > 2


select state, year(order_date) as years ,month(order_date) as months,COUNT(distinct order_id) as number_of_orders
from sales.orders A, sales.customers B
where A.customer_id = B.customer_id
group by state,year(order_date),month(order_date),year(order_date)
order by state,years,months