Select * from `Looker.Dashboard`;

Select extract(month from TransDate) as TransMonth,		
count(Transaction) as Total_Transactions		
FROM		
`Looker.Dashboard`	
group by 1		
order by 1 asc, 2 desc;		


Select extract(month from TransDate) as TransMonth,		
Sum(LineTotal) as Total_Revenue	
FROM		
`Looker.Dashboard`	
group by 1		
order by 1 asc, 2 desc;		


Select Location as Lokasi,		
count(Transaction) as Total_Transactions		
FROM		
`Looker.Dashboard`	
group by 1		
order by 1 asc, 2 desc;		

Select Location as Lokasi,		
Category as Kategori,
count(distinct Product) AS Produk
FROM		
`Looker.Dashboard`	
group by 1,2		
order by 3 desc;	

SELECT				
(CASE WHEN Extract (MONTH from TransDate) IN (1,2, 3) THEN 'WINTER'				
				
WHEN Extract (MONTH from TransDate) IN (4, 5, 6) THEN 'SPRING'				
				
WHEN Extract (MONTH from TransDate) IN (7, 8, 9) THEN 'SUMMER'				
				
WHEN Extract (MONTH from TransDate) IN (10, 11, 12) THEN 'AUTUMN'				
				
END) as Season				
,SUM(LineTotal)	as Total_Revenue		
				
FROM `Looker.Dashboard`				
Group by 1				
Order By 2;

SELECT Category as Kategori,			
count(Transaction) as Total_Transactions			
FROM `Looker.Dashboard`					
GROUP BY 1			
ORDER BY 1 DESC;

SELECT Distinct Location as Lokasi,			
Product as Produk,
count(Product)	as total	
FROM `Looker.Dashboard`					
GROUP BY 1,2
ORDER BY 1,3 DESC;

SELECT				
Location,
extract(month from TransDate) as TransMonth,	
(CASE WHEN Extract (MONTH from TransDate) IN (1, 2, 3) THEN 'WINTER'				
				
WHEN Extract (MONTH from TransDate) IN (4, 5, 6) THEN 'SPRING'				
				
WHEN Extract (MONTH from TransDate) IN (7, 8, 9) THEN 'SUMMER'				
				
WHEN Extract (MONTH from TransDate) IN (10, 11, 12) THEN 'AUTUMN'				
				
END) as Season,
Category,
SUM(LineTotal)	as Revenue
FROM `Looker.Dashboard`	
WHERE TransDate between '2022-01-01' and '2022-12-31'				
Group by 1,2,3,4				
Order By 2,5 DESC;

SELECT Distinct Location as Lokasi,	
Category,
extract(month from TransDate) as TransMonth,	
count(Product)	as total	
FROM `Looker.Dashboard`	
WHERE TransDate between '2022-01-01' and '2022-12-31'					
GROUP BY 1,2,3
ORDER BY 1,2 ASC,3 DESC;

SELECT Category as Kategori,	
Product as Produk,		
count(Transaction) as Total_Transactions			
FROM `Looker.Dashboard`					
GROUP BY 1,2		
ORDER BY 1 DESC;

SELECT Category as Kategori,	
Product as Produk,		
count(Product) as Total	
FROM `Looker.Dashboard`					
GROUP BY 1,2		
ORDER BY 1 DESC;

SELECT Location as Lokasi,
extract(month from TransDate) as TransMonth,
Category as Kategori,			
count(Transaction) as Total_Transactions			
FROM `Looker.Dashboard`					
GROUP BY 1,2,3			
ORDER BY 1,2,3 DESC;

SELECT
distinct Product as Produk,
Category as Kategori, 
sum(LineTotal) as Total_Revenue
from `Looker.Dashboard`	
group by 1,2
order by 3 asc;


Create or replace Model
`Looker.KMeansModel`
OPTIONS
(MODEL_TYPE = 'KMEANS',
NUM_CLUSTERS=3,
KMEANS_INIT_METHOD = 'RANDOM') AS
Select
Distinct Product,
Sum(LineTotal) as Total_Revenue
FROM `Looker.Dashboard`					
GROUP BY 1;

With Kmeans as (
  Select
Distinct Product,
Sum(LineTotal) as Total_Revenue
FROM `Looker.Dashboard`					
GROUP BY 1
order by 2 desc
)
Select *
EXCEPT (nearest_centroids_distance)
FROM
ML.PREDICT(
  MODEL `Looker.KMeansModel`,
  (
    SELECT *
    FROM
      Kmeans));
