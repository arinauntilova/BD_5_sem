 /*
�������, ���������� � �������������� 6 �������� SQL CLR:
1) ������������ ������������� ��������� ������� CLR,
2) ���������������� ���������� ������� CLR,
3) ������������ ������������� ��������� ������� CLR,
4) �������� ��������� CLR,
5) ������� CLR,
6) ������������ ������������� ��� ������ CLR. 
*/

USE Gallery;
GO

-- ��������� ������������� CLR � SQL Server.
EXEC sp_configure 'clr enabled', 0;  
RECONFIGURE;  
GO  


EXEC sp_configure 'show advanced options', 1
RECONFIGURE;
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
EXEC sp_configure 'clr enabled' , '1'
Go
RECONFIGURE;


-- === 1) ������������ ������������� ��������� ������� CLR   ===

CREATE ASSEMBLY HandWrittenUDF
FROM
'D:\sql_dlls\ClassLibrary1\bin\Debug\ClassLibrary1.dll'
GO

drop FUNCTION dbo.GetCountYear;
drop ASSEMBLY HandWrittenUDF;
GO

-- ���-�� ������, ���������� ����� ���������� ����
CREATE FUNCTION dbo.GetCountYear(@amount int) 
RETURNS INT   
AS
EXTERNAL NAME 
HandWrittenUDF.[HandWrittenUDF.UserDefinedFunctions].CountYear;
GO

SELECT dbo.GetCountYear(1885) AS 'CNT'


-- === 2) ���������������� ���������� ������� CLR  ===

CREATE ASSEMBLY HandWrittenUDF
FROM
'D:\sql_dlls\ClassLibrary1\bin\Debug\ClassLibrary1.dll'
GO

drop FUNCTION dbo.GetCountYear;
drop AGGREGATE dbo.AvgYear;
drop ASSEMBLY HandWrittenUDF;
GO

-- AVG -- 
-- ����� ������� ��� ��������� ������
CREATE AGGREGATE dbo.AvgYear(@value int) 
RETURNS INT   
EXTERNAL NAME HandWrittenUDF.[HandWrittenUDF.AgrFunc];  
GO

SELECT dbo.AvgYear(Year) AS 'AvgYear'
FROM tblPicture
GO


-- === 3) ������������ ������������� ��������� ������� CLR  ===

CREATE ASSEMBLY HandWrittenUDF
FROM
'D:\sql_dlls\ClassLibrary1\bin\Debug\ClassLibrary1.dll'
GO

drop FUNCTION dbo.squared_range;
drop FUNCTION FindPics;
drop PROCEDURE copy_pics;
drop FUNCTION dbo.GetCountYear;
drop AGGREGATE dbo.AvgYear;
drop ASSEMBLY HandWrittenUDF;
GO

create function dbo.squared_range(@begin int, @end int)
returns table(squared_range int)
as external name HandWrittenUDF.[HandWrittenUDF.TableFuncs].SqrRange;
go

select * 
from dbo.squared_range(1, 5);
go

-- ====================

-- ����� id, �������� ������, ���������� ����� ���������� ����     ������������� !!!!  ??????????????????????????????????????????????
CREATE FUNCTION FindPics(@ModifiedSince int)   
RETURNS TABLE (  
   PictureId int,  
   PictureName nvarchar(4000)  
)  
AS EXTERNAL NAME HandWrittenUDF.[HandWrittenUDF.NTableFunc].FindPictures;  
go  
  
SELECT * FROM FindPics(1912);  
go  

-- === 4) �������� ��������� CLR  ===

-- �������� ����� ������� � �������� ������ ������ �� 2014 ���
CREATE PROCEDURE dbo.copy_pics @table_name nvarchar(20)
AS EXTERNAL NAME HandWrittenUDF.[HandWrittenUDF.StoredProcedure].CopyLogs;
go

exec dbo.copy_pics 'tblNewPic';
go

SELECT * FROM tblNewPic;


-- === 5) ������� CLR  ===

CREATE ASSEMBLY HandWrittenUDF
FROM
'D:\sql_dlls\ClassLibrary1\bin\Debug\ClassLibrary1.dll'
GO

drop FUNCTION dbo.squared_range;
drop FUNCTION FindPics;
drop PROCEDURE copy_pics;
drop FUNCTION dbo.GetCountYear;
drop AGGREGATE dbo.AvgYear;
drop TRIGGER UpdateTrigger
drop ASSEMBLY HandWrittenUDF;
GO

CREATE TRIGGER UpdateTrigger
ON tblPicture
FOR UPDATE 
AS  
EXTERNAL NAME HandWrittenUDF.[HandWrittenUDF.Triggers].UpdateTrigger
GO

UPDATE tblPicture 
set PictureName = '������������ �� ������'
WHERE PictureID = 502
GO

/*
SELECT * 
FROM tblPicture 
GO 
*/

-- === 6) ������������ ������������� ��� ������ CLR  ===

-- �������� ���� ������ "�������� ����� �������"
-- � �������� ����� ������� � ����� ��������� ������ ����

create type dbo.pict_serial_num
external name HandWrittenUDF.[HandWrittenUDF.pict_serial_num];
go

CREATE TABLE test(
SN pict_serial_num)

insert into test (SN) values('4321 567890')
SELECT CAST(SN AS varchar(8000))FROM test
SELECT CAST(SN.seria AS varchar(8000)) from test;
SELECT CAST(SN.spec_num AS varchar(8000)) from test;

drop TABLE  test;