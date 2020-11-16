USE Gallery;
GO

-- 1 предикат сравнения
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.Year > 1900

-- 2 предикат BETWEEN.
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.Year BETWEEN 1900 and 1930

-- 3 предикат LIKE.
-- список названик картин, в которых есть слово "женщина"
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.PictureName LIKE '%женщина%'

-- 4 предикат IN с вложенным подзапросом.
SELECT P.PictureName, P.StyleID, P.Year
FROM tblPicture AS P
WHERE P.StyleID IN 
	(
		SELECT S.StyleID
		FROM tblStyle AS S
		WHERE S.StyleName = 'Символизм'
	)

-- 5 предикат EXISTS с вложенным подзапросом.
SELECT L.TenantID, L.PictureID
FROM tblLogBook AS L
WHERE EXISTS 
	(
		SELECT *
        FROM tblPicture AS P
        WHERE L.PictureID = P.PictureID AND P.StyleID < 5
	)

-- 6 предикат сравнения с квантором
-- самая поздняя запись
SELECT L.*
FROM tblLogBook AS L
WHERE L.Issuing > ALL
(
	SELECT L2.Issuing
	FROM tblLogBook AS L2
	WHERE L2.TenantID = 10
)

-- 7 агрегатные функции в выражениях столбцов
-- сначала группировка, потом min/max
SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate' , COUNT(L.Issuing) AS 'LogIssuingCount'
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

-- 8 скалярные подзапросы в выражениях столбцов.
-- Скалярный подзапрос — запрос, возвращающий единственное скалярное значение (строку, число и т.д.).
-- кол-во жанров
SELECT L.TenantID,
	   L.PictureID,
	   (
			SELECT COUNT(G.GenreID) 
			FROM tblGenres AS G
			WHERE G.PictureID = L.PictureID
	   ) AS GenresCount
FROM tblLogBook AS L
ORDER BY L.TenantID 

-- 9 простое выражение CASE.
-- набор простых выражений
-- сравнивает первое выражение с выражением в каждом предложении WHEN. 
-- Если эти выражения эквивалентны, то возвращается выражение в предложении THEN.
-- Допускается только проверка равенства
-- Возвращает незультат, соответствующий первой операции равной TRUE.

-- GETDATE возвращает текущую дату и время.
-- DATEDIFF возвращает интервал времени, прошедшего между двумя временными отметками
-- DATEDIFF ( datepart , startdate , enddate ) , 
-- datepart - Единицы, в которых функция DATEDIFF сообщает о разнице между startdate и enddate.
-- CAST преобразует выражение одного типа к другому.
SELECT I.PictureID, I.TenantID, 
	CASE YEAR(I.Issuing)
		WHEN YEAR(Getdate()) THEN 'This Year'
		WHEN YEAR(GetDate()) - 1 THEN 'Last year'
		ELSE CAST(DATEDIFF(year, I.Issuing, Getdate()) AS nvarchar(2)) + ' years ago'
	END AS 'When issuing'
FROM tblLogBook AS I

-- 10 поисковое выражение CASE.
-- логические выражения
SELECT P.PictureName, 
	CASE
		WHEN P.Year >= 1900 THEN '20 век'
		WHEN P.Year >= 1800  THEN '19 век'
		WHEN P.Year >= 1700  THEN '18 век'
		WHEN P.Year >= 1600  THEN '17 век'
		ELSE 'Средневековье'
	END AS PictureDate
FROM tblPicture AS P


-- 11 Создание новой временной локальной таблицы из                            
-- результирующего набора данных инструкции SELECT. 

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate' , COUNT(L.Issuing) AS 'BookIssuingCount'
INTO #PictureIssuingRange
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

--SELECT * 
--FROM #PictureIssuingRange


-- 12 вложенные коррелированные                                     
-- подзапросы в качестве производных таблиц в предложении FROM.

SELECT L.TenantID, L.PictureID, TMP.GenreCount
FROM tblLogBook AS L JOIN
(
	SELECT Gs.PictureID, COUNT(Gs.GenreID) AS GenreCount
	FROM tblGenres AS Gs
	GROUP BY PictureID
) AS TMP ON L.PictureID = TMP.PictureID



-- 13 я вложенные подзапросы с уровнем вложенности 3.

SELECT L.TenantID, L.PictureID
FROM tblLogBook AS L
WHERE L.PictureID IN
	(
		SELECT P.PictureID
        FROM tblPicture AS P
        WHERE EXISTS
		(
			SELECT Gs.GenreID
			FROM tblGenres AS Gs
			WHERE Gs.PictureID = P.PictureID AND EXISTS
			(
				SELECT G.GenreID
				FROM tblGenre AS G
				WHERE G.GenreID = Gs.GenreID AND G.GenreName = 'Историческая живопись'
			)
		)
	)



-- 14 консолидирующая данные с помощью предложения
-- GROUP BY, но без предложения HAVING.

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate'
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

-- 15 консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING.

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate'
FROM tblLogBook AS L
GROUP BY L.TenantID
HAVING COUNT(L.Issuing) > 2
ORDER BY L.TenantID

-- 16  INSERT, выполняющая вставку в таблицу одной
-- строки значений.

INSERT tblGenre(GenreID, GenreName)
VALUES (37, 'Космический пейзаж')

-- SELECT *
-- FROM tblGenre

-- 17 вставка в таблицу результирующего набора данных вложенного подзапроса. 

INSERT tblGenre(GenreID, GenreName)
SELECT (
	SELECT MAX(G.GenreID) + 1
	FROM tblGenre AS G
	), 'Лирический пейзаж'
	

/*
SELECT *
FROM tblLogBook
*/
/*
DELETE FROM tblLogBook
WHERE PictureID = 500 
*/

-- 18 Простая инструкция UPDATE.

UPDATE tblPicture
SET Year = Year + 1
WHERE PictureName = 'Одиночество'

/*
SELECT *
FROM tblPicture
*/

-- 19  UPDATE со скалярным подзапросом в предложении SET.

UPDATE tblPicture
SET Year = 
(
	SELECT MAX(P.Year)
	FROM tblPicture AS P
	WHERE P.PictureName LIKE '%ленин%'
)
WHERE PictureName LIKE '%ленин%'

-- 20 Простая инструкция DELETE.

DELETE tblPicture
WHERE PictureName is NULL


-- 21  DELETE с вложенным коррелированным подзапросом в
-- предложении WHERE.

DELETE FROM tblLogBook
WHERE PictureID IN
(
    SELECT P.PictureID
    FROM tblPicture AS P
    WHERE P.Year < 1650 OR P.Year > 1968
);

/*
SELECT *
FROM tblLogBook
*/

-- 22 простое обобщенное табличное выражение
-- Common Table Expression (CTE) 

WITH CTE (PictureYear, PictureCount)
AS 
(
    SELECT P.Year, COUNT(*) AS Count
    FROM tblPicture AS P
    GROUP BY P.Year
)
SELECT *
FROM CTE;

SELECT *
FROM CTE;


--SELECT MAX(PictureCount) AS 'Максимальное за год', MIN(PictureCount) AS 'Минимальное за год'
--FROM CTE

-- 23 рекурсивное обобщенное табличное выражение.

CREATE TABLE category
(
    id              integer      not null primary key,
    name            varchar(100) not null,
    parent_category integer references category
);

INSERT INTO category
values (1, 'Root Node', null);
INSERT INTO category
values (2, 'Software', 1);
INSERT INTO category
values (3, 'Hardware', 1);
INSERT INTO category
values (4, 'Notebooks', 3);
INSERT INTO category
values (5, 'Phones', 3);
INSERT INTO category
values (6, 'Applications', 2);
INSERT INTO category
values (7, 'Database Software', 2);
INSERT INTO category
values (8, 'Relational DBMS', 7);
INSERT INTO category
values (9, 'Tools', 7);
INSERT INTO category
values (10, 'Command Line Tools', 9);
INSERT INTO category
values (11, 'GUI Tools', 9);
INSERT INTO category
values (12, 'Android Phones', 5);
INSERT INTO category
values (13, 'IPhone', 5);
INSERT INTO category
values (14, 'Windows Phones', 5);


-- Определение ОТВ
WITH recursive (id, name, parent_category, depth) as (
	-- Определение закрепленного элемента
    SELECT id, name, parent_category, 0 AS depth
    FROM category
    WHERE name = 'Software' 
    UNION ALL
	-- -- Определение рекурсивного элемента
    SELECT child.id, child.name, child.parent_category, depth + 1
    FROM category child
             join recursive parent on parent.id = child.parent_category 
    WHERE depth < 3 --(контроль глубины)
)
-- Инструкция, использующая ОТВ
SELECT *
FROM recursive;

SELECT *
FROM category

drop table category;


-- 24 Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

SELECT DISTINCT G.GenreID, G.GenreName, AVG(P.Year) OVER (PARTITION BY G.GenreId) AS AvgYear
FROM tblPicture P join tblGenres Gs on Gs.PictureID = P.PictureID
join tblGenre G on G.GenreID = Gs.GenreID

-- 25  Оконные фнкции для устранения дублей

SELECT L.* INTO tblNewGenre
FROM 
(SELECT * 
FROM tblGenre 
UNION ALL
SELECT *
FROM tblGenre
UNION ALL
SELECT *
FROM tblGenre) AS L

WITH cte AS
(
    SELECT 
		RN = ROW_NUMBER() OVER(PARTITION BY G.GenreID, G.GenreName ORDER BY G.GenreID)
	FROM tblNewGenre G
)
DELETE 
FROM cte 
WHERE RN > 1; 
SELECT * FROM tblNewGenre

-- DROP TABLE tblNewGenre

/*
SELECT *
FROM tblNewGenre
*/


/* Дополнительное задание
Выполнить версионное соединение двух талиц по полю id.
*/
 
CREATE TABLE Table1
(
    id              INTEGER,
    var1            CHAR(20),
    valid_from_dttm DATE,
    valid_to_dttm   DATE
);

CREATE TABLE Table2
(
    id              INTEGER,
    var2            CHAR(20),
    valid_from_dttm DATE,
    valid_to_dttm   DATE
);

insert into Table1 values
(1,'A','2017-09-01','2017-09-15'),
(1,'B','2017-09-16','2017-09-25'),
(1,'C','2017-09-26','5999-12-31'),
(2,'A','2018-03-02','2018-03-11'),
(2,'B','2018-03-12','2018-04-02'),
(2,'C','2018-04-03','5999-12-31'),
--(3,'A','2018-01-01','2019-01-01'),
--(3,'B','2019-02-01','2019-02-11'),
--(3,'C','2019-02-12','5999-12-31')
(4,'B','2018-01-01','2019-02-11'),
(4,'C','2019-02-12','5999-12-31')

insert into Table2 values
(1,'A','2017-09-01','2017-09-14'),
(1,'B','2017-09-15','2017-09-23'),
(1,'C','2017-09-24','5999-12-31'),
--(2,'A','2018-03-02','2018-03-05'),
--(2,'B','2018-03-06','2018-03-23'),
--(2,'C','2018-03-24','5999-12-31'),
(3,'A','2018-01-01','2020-01-01'),
(3,'B','2020-01-02','5999-12-31'),
(4,'A','2018-01-01','2018-04-01'),
(4,'B','2018-04-02','5999-12-31')

select * from 
(	 select 
	 case
		 when Table1.id is not NULL then Table1.id 
		 else Table2.id 
	 end as ID,
	 case
		when Table1.var1 is not NULL then Table1.var1
		else '---'
	 end as var1,
	 case
		when Table2.var2 is not NULL then Table2.var2
		else '---'
	 end as var2,
	 case 
		when Table1.id is NULL then Table2.VALID_FROM_DTTM
		when Table2.id is NULL then Table1.VALID_FROM_DTTM
		else
		 case
			   when Table1.VALID_FROM_DTTM < Table2.VALID_FROM_DTTM then Table2.VALID_FROM_DTTM
			   else Table1.VALID_FROM_DTTM 
		 end			   
	 end as date_from,
     case 
		when Table1.id is NULL then Table2.VALID_TO_DTTM 
		when Table2.id is NULL then Table1.VALID_TO_DTTM 
		else
			case
			   when Table1.VALID_TO_DTTM > Table2.VALID_TO_DTTM then Table2.VALID_TO_DTTM
			   else Table1.VALID_TO_DTTM 
		    end
	 end as date_to
from Table1 full outer join Table2 on Table1.id = Table2.id) AS result 
	 WHERE date_from <= date_to
order by ID;

/*
drop table Table1
drop table Table2
*/