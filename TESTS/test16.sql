/*1. Найти ProductSubcategoryID из Production.Product,
где мин вес такого ProductSubcategoryID больше 150. */

SELECT * FROM Production.Product

SELECT ProductSubcategoryID, MIN(Weight) AS Min_Weight
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING MIN(Weight) > 150 

/*2. Найти самый дорогой продукт (поле StandardCost) из Production.Product. (4 способа)*/

SELECT Name, StandardCost
FROM (SELECT Name, StandardCost, 
RANK() OVER (ORDER BY StandardCost DESC) as rnk
FROM Production.Product) a
WHERE rnk=1

SELECT TOP 1 WITH TIES Name, StandardCost
FROM Production.Product
ORDER BY StandardCost DESC

SELECT Name, StandardCost
FROM Production.Product
WHERE StandardCost = (SELECT MAX(StandardCost) AS MaxCost
FROM Production.Product)

SELECT Name, StandardCost
FROM (SELECT Name, StandardCost, MAX(StandardCost) OVER () as MaxCost
FROM Production.Product) a
WHERE StandardCost=MaxCost


3. Найти страны, в которые за последний год не было куплено ни одного тура. (схема GROUP2)

SELECT t.Country
FROM Tours_dim t LEFT JOIN 
(SELECT IDTour
FROM Sales_fct 
WHERE YEAR(DataSales) BETWEEN YEAR(DATEADD(year, -1,getdate())) AND YEAR(GETDATE())) s
 ON t.IDTour=s.IDTour
	WHERE s.IDTour IS NULL 


4. Найти для каждого менеджера кол-во продаж за последние 15 лет.  (схема GROUP2)

SELECT m.FirstName, m.LastName,  COUNT(s.IDSale) AS cnt
FROM Sales_fct s JOIN Managers_dim m ON s.IDManager=m.IDManager
WHERE YEAR(s.DataSales) BETWEEN YEAR(DATEADD(year, -15,getdate())) AND YEAR(GETDATE())
GROUP BY m.FirstName, m.LastName



5. 
Users (
    id bigint NOT NULL,
    email varchar(255) NOT NULL
);

Notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    category varchar(100),
    is_read boolean DEFAULT false
);

Найти список категорий для пользователя alex@gmail.com, в которых более 50 непрочитанных нотификаций

SELECT category, COUNT (is_read) AS cnt
FROM Notifications n JOIN Users u ON n.user_id=u.id
WHERE u.email = 'alex@gmail.com'
GROUP BY category
HAVING COUNT (is_read) > 50