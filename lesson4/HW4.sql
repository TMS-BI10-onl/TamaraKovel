/*4.	Решите на базе данных AdventureWorks2017 следующие задачи. 
a)	Изучите данные в таблице Production.UnitMeasure. Проверьте, есть ли здесь UnitMeasureCode, 
начинающиеся на букву ‘Т’. Сколько всего различных кодов здесь есть? 
Вставьте следующий набор данных в таблицу:
•	TT1, Test 1, 9 сентября 2020
•	TT2, Test 2, getdate()

Проверьте теперь, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. */

SELECT *
FROM Production.UnitMeasure

SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%' -- ищу UnitMeasureCode, начинающиеся на букву ‘Т’.

SELECT COUNT(DISTINCT UnitMeasureCode) AS COUNT_UnitMeasureCode -- проверяю сколько различных кодов (38)
FROM Production.UnitMeasure

INSERT INTO Production.UnitMeasure (UnitMeasureCode, name, ModifiedDate)  -- добавляю 2 строки 
VALUES ('TT1', 'Test 1', '2020-09-09 00:00:00.000')
INSERT INTO Production.UnitMeasure (UnitMeasureCode, name, ModifiedDate)
VALUES ('TT2', 'Test 2', getdate())

SELECT *
FROM Production.UnitMeasure
WHERE UnitMeasureCode LIKE 'T%' -- в таблице есть 2 UnitMeasureCode начинающихся на букву ‘Т’.



/*b)	Теперь загрузите вставленный набор в новую, не существующую таблицу Production.UnitMeasureTest. 
Догрузите сюда информацию из Production.UnitMeasure по UnitMeasureCode = ‘CAN’.  
Посмотрите результат в отсортированном виде по коду. */

SELECT *
INTO Production.UnitMeasureTest
FROM Production.UnitMeasure
WHERE UnitMeasureCode IN ('CAN','TT1','TT2')
ORDER BY UnitMeasureCode

SELECT *                                 -- посмотрели по отсортированном по коду
FROM Production.UnitMeasureTest
ORDER BY UnitMeasureCode

-- c)	Измените UnitMeasureCode для всего набора из Production.UnitMeasureTest на ‘TTT’.
SELECT *                                 
FROM Production.UnitMeasureTest

UPDATE Production.UnitMeasureTest
SET UnitMeasureCode = 'TTT'

-- d)	Удалите все строки из Production.UnitMeasureTest.

DELETE
FROM Production.UnitMeasureTest

/*e)	Найдите информацию из Sales.SalesOrderDetail по заказам 43659,43664.  
С помощью оконных функций MAX, MIN, AVG найдем агрегаты по LineTotal для каждого SalesOrderID.*/

SELECT SalesOrderID, ProductID,
	MAX(LineTotal) OVER (PARTITION BY SalesOrderID) AS MAX_LineTotal,
	MIN(LineTotal) OVER (PARTITION BY SalesOrderID) AS MIN_LineTotal,
	AVG(LineTotal) OVER (PARTITION BY SalesOrderID) AS AVG_LineTotal
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (43659,43664)

/*f)	Изучите данные в объекте Sales.vSalesPerson. 
Создайте рейтинг cреди продавцов на основе годовых продаж SalesYTD, используя ранжирующую оконную функцию. 
Добавьте поле Login, состоящий из 3 первых букв фамилии в 
верхнем регистре + ‘login’ + TerritoryGroup (Null заменить на пустое значение). 
Кто возглавляет рейтинг? А кто возглавлял рейтинг в прошлом году (SalesLastYear). */

SELECT *
FROM Sales.vSalesPerson

-- проанализировала что получим в целом если ранжируем
SELECT FirstName, LastName, SalesYTD,                     
		CONCAT (UPPER(LEFT(LastName,3)),'login', COALESCE (TerritoryGroup, '')) AS 'Login', 
	DENSE_RANK() OVER (ORDER BY SalesYTD DESC) AS 'Sellers_Ranking_ThisYear',
	SalesLastYear,
	DENSE_RANK() OVER (ORDER BY SalesLastYear DESC) AS 'Sellers_Ranking_LastYear'
FROM Sales.vSalesPerson

/*кто лучший в этом году и в прошлом. 
их можно, конечно, разделить, если необходимо 
отдельно в этом году и в прошлом,но я соединила, надеюсь норм*/
 SELECT a.FirstName, a.LastName, a.Login, a.Sellers_Ranking_ThisYear, a.Sellers_Ranking_LastYear 
FROM 
(SELECT FirstName, LastName, SalesYTD, 
		CONCAT (UPPER(LEFT(LastName,3)),'login', COALESCE (TerritoryGroup, '')) AS 'Login', 
	DENSE_RANK() OVER (ORDER BY SalesYTD DESC) AS 'Sellers_Ranking_ThisYear',
	SalesLastYear,
	DENSE_RANK() OVER (ORDER BY SalesLastYear DESC) AS 'Sellers_Ranking_LastYear'
FROM Sales.vSalesPerson) a
WHERE Sellers_Ranking_ThisYear = 1 OR Sellers_Ranking_LastYear = 1

--g) Найдите первый будний день месяца (FROM не используем). Нужен стандартный код на все времена.

SELECT CASE 
        WHEN DATENAME(WEEKDAY, DATEADD(DAY,1,EOMONTH(GETDATE()))) 
			IN ('Monday','Tuesday','Wednesday','Thursday','Friday')
        THEN DATEADD(DAY,1,EOMONTH(GETDATE()))
        WHEN DATENAME(WEEKDAY, DATEADD(DAY,1,EOMONTH(GETDATE()))) = 'Saturday'
        THEN DATEADD(DAY,3,EOMONTH(GETDATE()))
        WHEN DATENAME(WEEKDAY, DATEADD(DAY,1,EOMONTH(GETDATE()))) = 'Sunday'
        THEN DATEADD(DAY,2,EOMONTH(GETDATE()))
END AS FirstWorkingDay