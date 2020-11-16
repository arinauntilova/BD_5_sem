/*����������� � ����������� 10 �������
A. ������ �������
	1) ��������� ������� (������ 1)
	2) ������������� ��������� ������� (������ 3)
	3) ���������������� ��������� ������� (������ 4)
	4) ����������� ������� ��� ������� � ����������� ��� (������� 2, 5)
B. ������ �������� ���������
	1) �������� ��������� ��� ���������� ��� � ����������� (������� 6, 7, 8, 9)
	2) ����������� �������� ��������� ��� �������� �������� � ����������� ��� (������ 10)
	3) �������� ��������� � �������� (������ 11)
	4) �������� ��������� ������� � ���������� (������ 12)
C. ��� DML ��������
	1) ������� AFTER (������ 13)
	2) ������� INSTEAD OF (������ 14) */

USE Gallery;
GO

-- ==============================================================================================================================================================================
-- ================================================================       �       ===============================================================================================
-- === 1) ��������� ������� ===
IF OBJECT_ID (N'dbo.CalculatePicturesWithYearLess', N'FN') IS NOT NULL
    DROP FUNCTION dbo.CalculatePicturesWithYearLess;
GO

-- ��������� ���
-- ���������� ���-�� ������, ���������� ������ ���������� ����.

CREATE FUNCTION dbo.CalculatePicturesWithYearLess (@Year_in int)
RETURNS int
	--SQL Server ����� ������� NULL, �� ������� ��� ���� ���� ������� � ��� ������, 
	--���� � �������� ������-���� �� ���������� ������� �������� NULL
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
-- �����
SELECT dbo.CalculatePicturesWithYearLess(1800) as Less_1800;
SELECT dbo.CalculatePicturesWithYearLess(1950) as Less_1900;
SELECT dbo.CalculatePicturesWithYearLess(2000) as Less_2000;
SELECT dbo.CalculatePicturesWithYearLess(NULL) as Less_NULL;
GO


USE Gallery;
GO

-- === 2)  ������������� ��������� ������� ===
IF OBJECT_ID (N'dbo.GetPictures', N'FN') IS NOT NULL
    DROP FUNCTION dbo.GetPictures;
GO

-- �������, ���������� ������ ���������� ����
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

-- �����
SELECT *
FROM dbo.GetPictures (1850);
GO


USE Gallery;
GO
 
-- === 3) ���������������� ��������� ������� ===           

-- ���� ����������� RETURNS ������ ��� TABLE � ������������ �������� � �� ����� ������, 
-- ������� �������� ���������������� ��������������� ��������.

IF OBJECT_ID (N' dbo.GetPicturesPY', N'FN') IS NOT NULL
    DROP FUNCTION  dbo.GetPicturesPY;
GO

-- ����� ID �������, �� ��������, ����� � ����
-- ���� ��� �������� ������ ���������� ���� � �������� � �������� ������������ �����.

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
-- �����
/*
SELECT *
FROM dbo.GetPicturesPY ('�������', 1990);
GO
SELECT *
FROM dbo.GetPicturesPY ('�������', 1850);
GO
*/

-- ������� ID ����������, MAX ���� ������, MIN ���� ������, � ��������
-- ���������� ������� ���������� �����, �������� ������ ���������� ����
-- � ���������� ���������� ������ > 2.
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

-- �����
SELECT *
FROM dbo.GetPicturesPY ('������������ ��������', 1990);
GO


USE Gallery;
GO

-- === 4) ����������� ������� ��� ������� � ����������� ��� ==
/*
IF OBJECT_ID (N'dbo.Calculate', N'FN') IS NOT NULL
    DROP FUNCTION dbo.Calculate;
GO

-- ���������
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

-- ����� ����������
SELECT dbo.Calculate(4);
GO
*/

IF OBJECT_ID (N'dbo.FindStyles', N'FN') IS NOT NULL
    DROP FUNCTION dbo.FindStyles;
GO
-- �������� ����������� ���
-- ���������� ������� � ID �����, ��� ���������, ID parent, � �������(��������) 
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
	-- ����������� ������������� ��������
    SELECT StyleID, StyleName, GroupID, 0 AS depth
    FROM tblStyle
    WHERE StyleName = '�������������� ����������' 
    UNION ALL
	-- ����������� ������������ ��������
    SELECT child.StyleID, child.StyleName, child.GroupID, depth + 1
    FROM tblStyle child
             JOIN recursive parent on parent.StyleID = child.GroupID
	 --(�������� �������)
    WHERE depth < @n
	)
	INSERT @style
	-- ����������, ������������ ���
	SELECT *
	FROM recursive;
	RETURN 
END;
GO

-- �����
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

-- ================================================================       �       ===============================================================================================
-- ==============================================================================================================================================================================

-- ==============================================================================================================================================================================
-- ================================================================       �       ===============================================================================================


USE Gallery;
GO

-- === 1) �������� ��������� ��� ���������� ��� � ����������� ===
IF OBJECT_ID (N'dbo.PictureYearProc', N'P') IS NOT NULL
    DROP PROCEDURE dbo.PictureYearProc;
GO
-- �������, ���������� ������ ���������� ����
CREATE PROCEDURE dbo.PictureYearProc(@Year int = 1850)
AS
BEGIN
	SELECT P.PictureName
	FROM tblPicture AS P
	WHERE P.Year <= @Year

END
GO

-- �����
EXECUTE dbo.PictureYearProc 1810
-- ��� ������������� ���������
EXECUTE dbo.PictureYearProc


USE Gallery;
GO

-- === 2) ����������� �������� ��������� ��� �������� �������� � ����������� ��� ===
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

-- �����
EXECUTE dbo.ProcRec;
GO

IF OBJECT_ID (N'dbo.ProcRec', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ProcRec_2;
GO

select *
into #PicCopy
from tblPicture;
go

-- ���������� ��������� ��� ��������� �������� �� @ny 
-- � ������������ ����������
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

-- �����
EXEC dbo.ProcRec_2 200, 300, 2;
GO

USE Gallery;
GO


-- === 3) �������� ��������� � ��������  ===
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

	WHILE (@Cnt <= @Count) AND (@@FETCH_STATUS = 0) -- ���������� FETCH ��������� �������.
	BEGIN
		SELECT @Cnt = @Cnt + 1
		-- ��� �������� NEXT ������������ ������, ����������� � ������ �������������� ������ ����� �� ����� �������. 
		-- ������ ��� ���������� �������. (�� ���������)
		-- INTO ��������� ��������� ������ �� �������� ������� � ��������� ����������.
		FETCH NEXT FROM CursorCur INTO @Year, @Name;
		PRINT 'Year: ' + CAST(@Year AS varchar) + ' Name: ' + CAST(@Name AS varchar);
	END

	CLOSE CursorCur;
	DEALLOCATE CursorCur;
END;
GO

-- �����:
EXECUTE dbo.PictureYearProc2 6

USE Gallery;
GO

-- === 4) �������� ��������� ������� � ����������  ===
-- ���������� (������ � ������) - ��������� ���������� ��� ���� �������� �������. 

IF OBJECT_ID (N'dbo.checkTables', N'P') IS NOT NULL
    DROP procedure dbo.checkTables
GO

-- ����� ���������� � �������� ���� ������
CREATE procedure checkTables as begin
	SELECT 
		name AS TableName, 
		create_date AS CreatedDate, 
		modify_date as ModifyDate 
	FROM sys.tables 
	ORDER BY ModifyDate;
end
GO

-- �����:
EXECUTE checkTables
GO

-- ================================================================       �       ===============================================================================================
-- ==============================================================================================================================================================================

-- ==============================================================================================================================================================================
-- ================================================================       �       ===============================================================================================


-- === 1) AFTER �������  ===

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

UPDATE tblPicture set PictureName = '������������ �� �������'
WHERE PictureID = 502
GO

/*
UPDATE tblPicture set PictureName = '������������'
WHERE PictureName = '������������ �� �������'
GO
*/

/*
INSERT dbo.tblPicture 
VALUES (502,'������������', 2, 1, 1, 1988)*/

/*
delete 
from tblPicture
where PictureID = 502
*/

-- === 2) INSTEAD OF �������  ===

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
		-- @@ROWCOUNT � ���������� ���-�� ���������� ����� ��� ���������� ��������� ����������.
		IF @@ROWCOUNT = 0
			-- 10 - ������� �����������
			-- 1 - state ���������� ������ ���������, ����� ����������, � ����� ����� ���� ������. 
			RAISERROR('Cant insert', 10, 1);
	END
END;
GO

INSERT dbo.tblPicture 
VALUES (503,'��������� �������� ������', 2, 1, 1, 1958)

/* 
SELECT *
FROM tblPicture 
*/

-- ================================================================       �       ===============================================================================================
-- ==============================================================================================================================================================================
