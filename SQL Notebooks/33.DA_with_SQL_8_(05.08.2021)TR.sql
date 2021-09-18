------------ DAwSQL Session 8 (05.08.2021)Tr ---------------

-- �r�nlerin stok say�lar�n� bulunuz

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id

SELECT product_id
FROM production.stocks
GROUP BY product_id
ORDER BY 1

SELECT *, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks

SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks

-- Markalara g�re ortalama bisiklet fiyatlar�n� hem Group By hem de window Functions ile hesaplay�n�z.

SELECT brand_id, AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id;

SELECT DISTINCT brand_id, AVG(list_price) OVER(PARTITION BY brand_id) AS avg_price
FROM production.products

-- 1. ANALYTIC AGGREGATE FUNCTIONS --

-- MIN() -MAX() - AVG() - SUM() - COUNT()

-- T�m bisikletler aras�nda en ucuz bisikletin fiyat�

SELECT TOP 1 product_name, MIN(list_price) OVER()
FROM production.products

SELECT	DISTINCT TOP 1 brand_id,MIN(list_price) OVER (PARTITION BY brand_id) min_price
FROM	production.products
ORDER BY min_price

-- Herbir kategorideki en ucuz bisikletin fiyat�

SELECT	DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id) 
FROM	production.products

-- Products tablosunda ka� farkl� bisiklet var

SELECT DISTINCT COUNT(product_id) OVER() AS num_of_bayk
FROM production.products

-- oder items tablosunda toplam ka� farkl� bisiklet var

SELECT COUNT(DISTINCT product_id)
FROM sales.order_items

SELECT DISTINCT COUNT(product_id) OVER() AS num_of_bike
FROM (
	  SELECT product_id
	  FROM sales.order_items
	  ) AS A


-- Herbir kategoride toplam ka� farkl� bisikletin bulundu�u

SELECT DISTINCT category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products


-- Herbir kategorideki herbir  markada ka� farkl� bisikletin bulundu�u

SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products

-- WF ile tek select'te herbir kategoride ka� farkl� marka oldu�unu hesaplayabilir misiniz?


SELECT	category_id, count (DISTINCT brand_id)
FROM	production.products
GROUP BY category_id

--

SELECT DISTINCT category_id, COUNT(brand_id) OVER(PARTITION BY category_id)
FROM production.products

SELECT DISTINCT category_id, COUNT(brand_id) OVER(PARTITION BY category_id)
FROM (
	  SELECT DISTINCT category_id, brand_id
	  FROM production.products
	  ) AS A


---- 2. ANALYTIC NAVIGATION FUNCTIONS

--first_value() - last_value() - lead() - lag()

--Order tablosuna a�a��daki gibi yeni bir s�tun ekleyiniz:
--1. Herbir personelin bir �nceki sat���n�n sipari� tarihini yazd�r�n�z (LAG fonksiyonunu kullan�n�z)

SELECT *, LAG(order_date, 1) OVER(PARTITION BY staff_id ORDER BY order_date, order_id) AS prev_order_date
FROM sales.orders -- Personele g�re demeseydi partititon by hesaba kat�lmazd�


SELECT *, LAG(order_date, 1) OVER(ORDER BY order_date, order_id) AS prev_order_date
FROM sales.orders

--1. Herbir personelin bir sonraki sat���n�n sipari� tarihini yazd�r�n�z (LAG fonksiyonunu kullan�n�z)

SELECT	*, LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

--

SELECT	*, LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

----------------------

-- Window Frame

SELECT category_id, product_id, 
	   COUNT(*) OVER() AS TOT_ROW   
FROM production.products

--

SELECT DISTINCT category_id, product_id, 
	   COUNT(*) OVER() AS total_row,
	   COUNT(*) OVER(PARTITION BY category_id) AS num_of_row,
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) AS num_of_row
FROM production.products

--

SELECT category_id,
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS prev_with_current
FROM production.products

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
SELECT	category_id,

--


		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--1. T�m bisikletler aras�nda en ucuz bisikletin ad� (FIRST_VALUE fonksiyonunu kullan�n�z)
SELECT	FIRST_VALUE(product_name) OVER ( ORDER BY list_price)
FROM	production.products

--�r�n�n yan�na list price' �n� nas�l eklersiniz?

SELECT	 DISTINCT FIRST_VALUE(product_name) OVER ( ORDER BY list_price) , min (list_price) over ()
FROM	production.products


--2. Herbir kategorideki en ucuz bisikletin ad� (FIRST_VALUE fonksiyonunu kullan�n�z)

select distinct category_id, FIRST_VALUE(product_name) over (partition by category_id order by list_price)
from production.products


--3. T�m bisikletler aras�nda en ucuz bisikletin ad� (LAST_VALUE fonksiyonunu kullan�n�z)

SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products


-- 3. ANALYTIC NUMBERING FUNCTIONS --

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()

--1. Herbir kategori i�inde bisikletlerin fiyat s�ralamas�n� yap�n�z (artan fiyata g�re 1'den ba�lay�p birer birer artacak)

SELECT category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products

--2. Ayn� soruyu ayn� fiyatl� bisikletler ayn� s�ra numaras�n� alacak �ekilde yap�n�z (RANK fonksiyonunu kullan�n�z)

SELECT category_id, list_price,
	  ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
	  RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM production.products

--3. Ayn� soruyu ayn� fiyatl� bisikletler ayn� s�ra numaras�n� alacak �ekilde yap�n�z (DENSE_RANK fonksiyonunu kullan�n�z)

SELECT category_id, list_price,
	  ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
	  RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	  DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM production.products


--4. Herbir kategori i�inde bisikletierin fiyatlar�na g�re bulunduklar� y�zdelik dilimleri yazd�r�n�z. (CUME_DIST fonksiyonunu kullan�n�z)
--5. Herbir kategori i�inde bisikletierin fiyatlar�na g�re bulunduklar� y�zdelik dilimleri yazd�r�n�z. (PERCENT_RANK fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products

--6. Herbir kategorideki bisikletleri artan fiyata g�re 4 gruba ay�r�n. M�mk�nse her grupta ayn� say�da bisiklet olacak.
--(NTILE fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products
