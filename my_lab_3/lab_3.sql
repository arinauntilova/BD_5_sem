/*Разработать и тестировать 10 модулей
A. Четыре функции
	1) Скалярную функцию (пример 1)
	2) Подставляемую табличную функцию (пример 3)
	3) Многооператорную табличную функцию (пример 4)
	4) Рекурсивную функцию или функцию с рекурсивным ОТВ (примеры 2, 5)
B. Четыре хранимых процедуры
	1) Хранимую процедуру без параметров или с параметрами (примеры 6, 7, 8, 9)
	2) Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ (пример 10)
	3) Хранимую процедуру с курсором (пример 11)
	4) Хранимую процедуру доступа к метаданным (пример 12)
C. Два DML триггера
	1) Триггер AFTER (пример 13)
	2) Триггер INSTEAD OF (пример 14) */

USE Gallery;
GO

-- ==============================================================================================================================================================================
-- ================================================================       А       ===============================================================================================
-- === 1) Скалярная функция ===
IF OBJECT_ID (N'dbo.CalculatePicturesWithYearLess', N'FN') IS NOT NULL
    DROP FUNCTION dbo.CalculatePicturesWithYearLess;
GO

-- Принимает год
-- Возвращает кол-во картин, написанных раннее указанного года.

CREATE FUNCTION dbo.CalculatePicturesWithYearLess (@Year_in int)
RETURNS int
	--SQL Server может вернуть NULL, не вызывая при этом тело функции в том случае, 
	--если в качестве какого-либо из аргументов указано значение NULL
	WITH RETURNS NULL ON NULL INPUT
	AS
	BEGIN
		RETURN
		(
			SELECT COUNT(P.PictureID) AS "Pictures count"
			FROM dbo.tblPicture AS P
			WHERE P.Year < @Year_in
		);
	END;

GO
-- Тесты
SELECT dbo.CalculatePicturesWithYearLess(1800) as Less_1800;
SELECT dbo.CalculatePicturesWithYearLess(1950) as Less_1900;
SELECT dbo.CalculatePicturesWithYearLess(2000) as Less_2000;
SELECT dbo.CalculatePicturesWithYearLess(NULL) as Less_NULL;
GO


USE Gallery;
GO

-- === 2)  Подставляемая табличная функция ===
IF OBJECT_ID (N'dbo.GetPictures', N'FN') IS NOT NULL
    DROP FUNCTION dbo.GetPictures;
GO

-- Картины, написанные раннее указанного года
CREATE FUNCTION dbo.GetPictures (@Year int)
RETURNS table
AS
RETURN
(
	SELECT *
	FROM dbo.tblPicture AS P
	WHERE P.Year <= @Year
)

GO

-- Тесты
SELECT *
FROM dbo.GetPictures (1850);
GO


USE Gallery;
GO
 
-- === 3) Многооператорная табличная функция ===           

-- Если предложение RETURNS задает тип TABLE с определением столбцов и их типов данных, 
-- функция является многооператорной табличнозначной функцией.

IF OBJECT_ID (N' dbo.GetPicturesPY', N'FN') IS NOT NULL
    DROP FUNCTION  dbo.GetPicturesPY;
GO

-- Вывод ID картины, ее названия, стиля и года
-- если она написана раннее указанного года и содержит в названии определенное слово.

/*
CREATE FUNCTION dbo.GetPicturesPY (@Name VARCHAR(100), @Year int)
RETURNS @pict table
(
	[Pid] [INT] primary key NOT NULL,
	[PName] [VARCHAR](100) NOT NULL,
	[Style] [VARCHAR](100)  NOT NULL,
	[Year] [INT] NOT NULL
)
AS
BEGIN
	INSERT @pict
		SELECT P.PictureID, P.PictureName, S.StyleName, P.Year
		FROM dbo.tblPicture AS P join tblStyle S on S.StyleID = P.StyleID
		WHERE P.PictureName LIKE '%' + @Name + '%' AND P.Year <= @Year
	RETURN
END
GO
*/
-- Тесты
/*
SELECT *
FROM dbo.GetPicturesPY ('женщина', 1990);
GO
SELECT *
FROM dbo.GetPicturesPY ('девушка', 1850);
GO
*/

-- Вывести ID арендатора, MAX дату аренды, MIN дату аренды, у которого
-- арендуемая картина указанного жанра, написана раньше указанного года
-- и количество арендуемых картин > 2.
CREATE FUNCTION dbo.GetPicturesPY (@Name VARCHAR(100), @Year int)
RETURNS @pict table
(
	[Lid] [INT] NOT NULL,
	[MinDate] [DATE] NOT NULL,
	[MaxDate] [DATE] NOT NULL
)
AS
BEGIN
	INSERT @pict
		SELECT L.TenantID, MIN(L.Issuing), MAX(L.Issuing)
		FROM tblLogBook L JOIN tblPicture PC on PC.PictureID = L.PictureID 
		WHERE L.PictureID IN
		(
			SELECT P.PictureID
			FROM tblPicture AS P
			WHERE P.Year < @Year and EXISTS
			(
				SELECT Gs.GenreID
				FROM tblGenres AS Gs
				WHERE Gs.PictureID = P.PictureID AND EXISTS
				(
					SELECT G.GenreID
					FROM tblGenre AS G
					WHERE G.GenreID = Gs.GenreID AND G.GenreName = @Name 
				)
			)
		) 
		GROUP BY L.TenantID
		HAVING COUNT(L.Issuing) > 2

	RETURN
END
GO

-- Тесты
SELECT *
FROM dbo.GetPicturesPY ('Историческая живопись', 1990);
GO


USE Gallery;
GO

-- === 4) Рекурсивная функция или функция с рекурсивным ОТВ ==
/*
IF OBJECT_ID (N'dbo.Calculate', N'FN') IS NOT NULL
    DROP FUNCTION dbo.Calculate;
GO

-- Факториал
CREATE FUNCTION dbo.Calculate (@n int = 1)
RETURNS float
WITH RETURNS NULL ON NULL INPUT
AS
BEGIN
	DECLARE @result int;
	SET @result = NULL;
	IF @n > 0
	BEGIN
		SET @result = 1;
		WITH Numbers (num)
		AS
		(
			SELECT 1
			UNION ALL
			SELECT num + 1
			FROM Numbers
			WHERE num < @n
		)
		SELECT @result = @result * num
		FROM Numbers;
	END;
	RETURN @result;
END;
GO

-- Тесты Фактрориал
SELECT dbo.Calculate(4);
GO
*/

IF OBJECT_ID (N'dbo.FindStyles', N'FN') IS NOT NULL
    DROP FUNCTION dbo.FindStyles;
GO
-- Содержит рекурсивное ОТВ
-- Возвращает таблицу с ID стиля, его названием, ID parent, и уровнем(глубиной) 
CREATE FUNCTION dbo.FindStyles (@n int = 1)
RETURNS @style table
(
	[Sid] [INT] primary key NOT NULL,
	[SName] [VARCHAR](100) NOT NULL,
	[Parentid] [INT] NOT NULL,
	[Depth] [INT] NOT NULL
)
AS
BEGIN
	WITH recursive(StyleID, StyleName, GroupID, depth) as (
	-- Определение закрепленного элемента
    SELECT StyleID, StyleName, GroupID, 0 AS depth
    FROM tblStyle
    WHERE StyleName = 'Геометрическая абстракция' 
    UNION ALL
	-- Определение рекурсивного элемента
    SELECT child.StyleID, child.StyleName, child.GroupID, depth + 1
    FROM tblStyle child
             JOIN recursive parent on parent.StyleID = child.GroupID
	 --(контроль глубины)
    WHERE depth < @n
	)
	INSERT @style
	-- Инструкция, использующая ОТВ
	SELECT *
	FROM recursive;
	RETURN 
END;
GO

-- Тесты
SELECT *
FROM dbo.FindStyles(3);
GO

/*
ALTER TABLE tblStyle
ADD GroupID INT NULL
Default 1;
*/

select *
from tblStyle

/*
ALTER TABLE tblCollector DROP COLUMN MenegerID ;
ALTER TABLE tblCollector DROP CONSTRAINT FK_Collector_MenegerID;    

ALTER TABLE tblStyle DROP COLUMN GroupId ;
*/

-- ================================================================       А       ===============================================================================================
-- ==============================================================================================================================================================================

-- ==============================================================================================================================================================================
-- ================================================================       В       ===============================================================================================


USE Gallery;
GO

-- === 1) Хранимая процедура без параметров или с параметрами ===
IF OBJECT_ID (N'dbo.PictureYearProc', N'P') IS NOT NULL
    DROP PROCEDURE dbo.PictureYearProc;
GO
-- картины, написанные раньше указанного года
CREATE PROCEDURE dbo.PictureYearProc(@Year int = 1850)
AS
BEGIN
	SELECT P.PictureName
	FROM tblPicture AS P
	WHERE P.Year <= @Year

END
GO

-- Тесты
EXECUTE dbo.PictureYearProc 1810
-- Без передаваемого аргумента
EXECUTE dbo.PictureYearProc


USE Gallery;
GO

-- === 2) Рекурсивная хранимая процедура или хранимую процедур с рекурсивным ОТВ ===
IF OBJECT_ID (N'dbo.ProcRec', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ProcRec;
GO

CREATE PROCEDURE dbo.ProcRec
AS
	WITH OrgStyle (StyleID, GroupID, depth, Node)
	AS
	(
		SELECT StyleID, GroupID, 0, CONVERT(VARCHAR(30),'/') AS Node
		FROM dbo.tblStyle
		WHERE GroupID IS NULL
		UNION ALL
		SELECT L.StyleID, L.GroupID, b.depth + 1,
		CONVERT(VARCHAR(30), b.Node + CONVERT(VARCHAR, L.GroupID) + '/')
		FROM dbo.tblStyle AS L INNER JOIN OrgStyle AS b ON L.GroupID = b.StyleID
	)
	SELECT StyleID, GroupID, depth, Node
	FROM OrgStyle
	ORDER BY Node;
GO

-- Тесты
EXECUTE dbo.ProcRec;
GO

IF OBJECT_ID (N'dbo.ProcRec', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ProcRec_2;
GO

select *
into #PicCopy
from tblPicture;
go

-- рекурсивно увеличить год написания картиины на @ny 
-- в определенном промежутке
CREATE PROCEDURE dbo.ProcRec_2 @start as int = 1, @stop as int = 10, @ny as int = 1
AS
	BEGIN
		if @start <= @stop
		begin
			update #PicCopy
			set Year = Year + @ny
			where PictureID = @start;

			set @start = @start + 1;
			exec dbo.ProcRec_2 @start, @stop, @ny;
		end	
	END;
GO

select *
from #PicCopy
where PictureID between 200 and 300

-- Тесты
EXEC dbo.ProcRec_2 200, 300, 2;
GO

USE Gallery;
GO


-- === 3) Хранимая процедура с курсором  ===
IF OBJECT_ID (N'dbo.PictureYearProc2', N'P') IS NOT NULL
    DROP PROCEDURE dbo.PictureYearProc2;
GO

CREATE PROCEDURE dbo.PictureYearProc2(@Count int = 5)
AS
BEGIN
	DECLARE @Cnt int = 1;
	DECLARE @Year int;
	DECLARE @Name varchar(50);
	DECLARE CursorCur CURSOR
	FOR 
		SELECT P.Year, P.PictureName
		FROM tblPicture AS P;
	OPEN CursorCur

	WHILE (@Cnt <= @Count) AND (@@FETCH_STATUS = 0) -- Инструкция FETCH выполнена успешно.
	BEGIN
		SELECT @Cnt = @Cnt + 1
		-- При указании NEXT возвращается строка, находящаяся в полном результирующем наборе сразу же после текущей. 
		-- Теперь она становится текущей. (По умолчанию)
		-- INTO Позволяет поместить данные из столбцов выборки в локальные переменные.
		FETCH NEXT FROM CursorCur INTO @Year, @Name;
		PRINT 'Year: ' + CAST(@Year AS varchar) + ' Name: ' + CAST(@Name AS varchar);
	END

	CLOSE CursorCur;
	DEALLOCATE CursorCur;
END;
GO

-- Тесты:
EXECUTE dbo.PictureYearProc2 6

USE Gallery;
GO

-- === 4) Хранимую процедуру доступа к метаданным  ===
-- метаданные (данные о данных) - детальная информация обо всех объектах системы. 

IF OBJECT_ID (N'dbo.checkTables', N'P') IS NOT NULL
    DROP procedure dbo.checkTables
GO

-- Вывод информации о таблицах базы данных
CREATE procedure checkTables as begin
	SELECT 
		name AS TableName, 
		create_date AS CreatedDate, 
		modify_date as ModifyDate 
	FROM sys.tables 
	ORDER BY ModifyDate;
end
GO

-- Тесты:
EXECUTE checkTables
GO

-- ================================================================       В       ===============================================================================================
-- ==============================================================================================================================================================================

-- ==============================================================================================================================================================================
-- ================================================================       С       ===============================================================================================


-- === 1) AFTER триггер  ===

USE Gallery;
GO

IF OBJECT_ID ('dbo.trAfter','TR') IS NOT NULL
DROP TRIGGER dbo.trAfter
GO
CREATE TRIGGER trAfter
ON dbo.tblPicture
AFTER UPDATE
AS
    BEGIN
        SELECT * FROM inserted
		SELECT * FROM deleted
        PRINT 'Name picture was updated!'
    END
GO

UPDATE tblPicture set PictureName = 'Воспоминание из детства'
WHERE PictureID = 502
GO

/*
UPDATE tblPicture set PictureName = 'Воспоминание'
WHERE PictureName = 'Воспоминание из детства'
GO
*/

/*
INSERT dbo.tblPicture 
VALUES (502,'Воспоминание', 2, 1, 1, 1988)*/

/*
delete 
from tblPicture
where PictureID = 502
*/

-- === 2) INSTEAD OF триггер  ===

USE Gallery;
GO

IF OBJECT_ID ('dbo.trInstead','TR') IS NOT NULL
DROP TRIGGER dbo.trInstead
GO

CREATE TRIGGER trInstead 
ON dbo.tblPicture
INSTEAD OF INSERT
AS
BEGIN
	IF (SELECT COUNT(*) FROM Inserted) > 0
	BEGIN
		PRINT 'INSERT'
		-- @@ROWCOUNT – возвращает кол-во затронутых строк при выполнении последней инструкции.
		IF @@ROWCOUNT = 0
			-- 10 - степень серьезности
			-- 1 - state уникальный номера состояния, чтобы определить, в каком месте кода ошибка. 
			RAISERROR('Cant insert', 10, 1);
	END
END;
GO

INSERT dbo.tblPicture 
VALUES (503,'Навстречу утренней Авроре', 2, 1, 1, 1958)

/* 
SELECT *
FROM tblPicture 
*/

-- ================================================================       С       ===============================================================================================
-- ==============================================================================================================================================================================
