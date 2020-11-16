-- BULK INSERT загружает данные из файла данных в таблицу.
BULK INSERT Gallery.dbo.tblEducation
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\education.txt'
-- CODEPAGE - Задает кодовую страницу данных в файле данных
-- ACP - Столбцы типа char, varchar или text преобразуются из кодовой страницы ANSI в кодовую страницу SQL Server.
-- DATAFILETYPE Указывает, что инструкция BULK INSERT выполняет операцию импорта с использованием указанного типа файла данных.
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblStyle
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\picture_style.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO


BULK INSERT Gallery.dbo.tblGenre
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\picture_genre.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPainter
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\painter.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPainters
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\painters.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblGenres
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\genres.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPicture
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\picture.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblTenant
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\tenants.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblCollector
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\collector.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblLogBook
FROM 'D:\перенос  25.08.20\labs\5_sem_BD\my_lab_1\data\logbook.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

--SELECT * FROM Gallery.dbo.tblTenant;

INSERT Gallery.dbo.tblTenant VALUES ('30000', 'М', 'Унтилова', 'Арина', 'Олеговна', 'г. Белореченск, Алексеевская Большая улица, д.2, кв.89', '+7 (997) 635-98-86', '2004-06-03', 'justfood@outlook.com')

INSERT Gallery.dbo.tblTenant VALUES ('30000', 'T', 'Унтилова', 'Арина', 'Олеговна', 'г. Белореченск, Алексеевская Большая улица, д.2, кв.89', '+7 (997) 635-98-86', '2004-06-03', 'justfood@outlook.com')
