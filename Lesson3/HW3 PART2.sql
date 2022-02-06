--вывести фамилию в верхнем регистре, имя в нижнем
SELECT UPPER(LastName), LOWER(FirstName) 
FROM Person.Person

--вывести фамилию и имя в одной колонке
SELECT CONCAT(LastName, ' ', FirstName) 
FROM Person.Person

-- ВЫВЕСТИ ФАМИЛИЮ ИМЯ И МИДЛНЭЙМ В ОДНУ КОЛОНКУ ЧЕРЕЗ ДЕФИС
SELECT CONCAT_WS('-', LastName, MiddleName, FirstName) 
FROM Person.Person

-- ИЗМЕНИТЬ ФОРМАТ ДАТЫ НА Great Britain English
SELECT ModifiedDate, FORMAT(ModifiedDate,'d','en-gb') AS Great Britain English
FROM Person.Person

-- ВЫВЕСТИ ПЕРВЫХ 8 СИМВОЛОВ ROWGUID
SELECT LEFT(rowguid, 8) AS PartID
FROM Person.Person

-- ПРОВЕРИТЬ, ЧТО ВСЕ rowguid ИМЕЮТ ПРАВИЛЬНУЮ ДЛИНУ, ЗНАЯ, ЧТО КОРРЕКТНАЯ ДЛИНА 36 СИМВОЛОВ
SELECT LEN(rowguid) AS Length, COUNT(1) AS Count
FROM Person.Person
GROUP BY LEN(rowguid) 

-- ВЫВЕСТИ ИМЕНА, ЗАПИСАННЫЕ В ОБРАТНОМ ПОРЯДКЕ, ДЛИНА КОТОРЫХ 5 СИМВОЛОВ, ПОСЧИТАТЬ,СГРУППИРОВАТЬ ПО ИМЕНИ
SELECT FirstName, REVERSE(FirstName) AS Reverse, COUNT(1) AS Cnt
FROM Person.Person  
WHERE LEN(FirstName)= 5  
GROUP BY FirstName
ORDER BY FirstName;  

-- ОКРУГЛИТЬ SalesYTD И SalesLastYear ДО 3 ЗНАКОВ
SELECT ROUND(SalesYTD,3),ROUND(SalesLastYear, 3) 
FROM Sales.SalesPerson

-- ИЗМЕНИТЬ ЧАСТЬ rowguid НАЧИНАЯ С 10 СИМВОЛА НА 0000
SELECT rowguid, STUFF(rowguid, 10, 4, '0000') AS NEW_rowguid
FROM Person.Person

-- СДЕЛАТЬ ИЗ FirstName Bobby BoBIK. 
SELECT FirstName, REPLACE(FirstName, 'BBY', 'BIK') AS NEW_NAME
FROM Person.Person
WHERE FirstName LIKE 'Bo%y'

-- ДОБЫТЬ НЕМНОЖКО ЗОЛОТИШКА ИЗ ВСЕХ ГОЛДБЕРГОВ. 
SELECT Firstname, SUBSTRING(Lastname, 1, 4) AS NEW_NAME
FROM Person.Person
WHERE Lastname = 'Goldberg'

--ПОЛУЧИТЬ В ОТДЕЛЬНЫХ КОЛОНКАХ ГОД/МЕСЯЦ ДЛЯ НАЧАЛА/КОНЦА СПЕЦИАЛЬНЫХ ПРЕДЛОЖЕНИЙ 
SELECT YEAR(StartDate) AS StartD_Year, MONTH(StartDate) AS StartD_Month, 
YEAR(EndDate) AS EndD_Year, MONTH(EndDate) AS EndD_Month
FROM Sales.SpecialOffer

--УЗНАТЬ СКОЛЬКО ДНЕЙ ДЕЙСТВОВАЛО СПЕЦИАЛЬНОЕ ПРЕДЛОЖЕНИЕ
SELECT StartDate, EndDate, 
DATEDIFF(day, StartDate, EndDate) as DATE_DIFF
FROM Sales.SpecialOffer

/*УЗНАТЬ ПОСЛЕДНИЙ ДЕНЬ МЕСЯЦА, В КОТОРОМ НАЧАЛО ДЕЙСТВОВАТЬ СПЕЦИЛЬНОЕ ПРЕДЛОЖЕНИЕ, 
ВМЕСТЕ С ТЕМ ВЫВЕСТИ ПОСЛЕДНИЙ ДЕНЬ ПРОШЛОГО И СЛЕДУЮЩЕГО МЕСЯЦА, ТАКЖЕ ВЫВЕСТИ ID и ОПИСАНИЕ ПРЕДЛОЖЕНИЯ*/
SELECT SpecialOfferID, Description,
EOMONTH ( StartDate ) AS 'Special_in_this_month', 
EOMONTH ( StartDate, 1 ) AS 'Special_in_next_month',  
EOMONTH ( StartDate, -1 ) AS 'Special_in_previous_month'  
FROM Sales.SpecialOffer

--ПОЛУЧИТЬ КВАДРАТ ЗНАЧЕНИЯ СКИДКИ. ВЫВЕСТИ ВМЕСТЕ С ОПИСАНИЕМ и ОРИГИНАЛЬНЫМ ЗНАЧЕНИЕМ СКИДКИ 
SELECT Description, DiscountPct, SQUARE(DiscountPct) AS Discount_Square 
FROM Sales.SpecialOffer

/*ОЦЕНИТЬ ВЕЛИЧИНУ СКИДКИ: 
ЕСЛИ СКИДКА СОСТАВЛЯЕТ ЗНАЧЕНИЕ БОЛЬШЕЕ ЛИБО РАВНОЕ 0.5 - ПОМЕТИТЬ КАК НАИВЫСШЕЕ ПРЕДЛОЖЕНИЕ,
ДЛЯ ОСТАЛЬНЫХ СЛУЧАЕВ ПОМЕТИТЬ КАК СТАНДАРТНОЕ ПРЕДЛОЖЕНИЕ*/
SELECT  SpecialOfferID, Description, DiscountPct,
IIF(DiscountPct>=0.5, 'Highest Offer', 'Standart Offer') AS 'Discount_Rate'
FROM Sales.SpecialOffer

--ДЛЯ ВСЕХ НОВЫХ ПРОДУКТОВ В СПЕЦ.ПРЕДЛОЖЕНИЯХ УСТАНОВИТЬ ВЕЛИЧИНУ СКИДКИ, РАВНУЮ 0.3. 
SELECT  SpecialOfferID, Type, DiscountPct,
IIF(Type='New Product', 0.3, DiscountPct) AS 'DiscountPct_new'
FROM Sales.SpecialOffer

/*ДЛЯ 2011 года вывести в формате "месяц-день", кол-во заказов, цену за единицу товара, сумму заказов
и колонку, в которой будет помечено Lucky day для дней, в которых сумма больше 20тысяч и Standart day 
для всех остальных*/
SELECT CONCAT_WS('-', MONTH(DueDate), DAY(DueDate)) AS DATE, 
OrderQty, UnitPrice, LineTotal, 
IIF(LineTotal>20000, 'Lucky day', 'Standart day') AS 'WHATS_DAY'
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(DueDate)=2011