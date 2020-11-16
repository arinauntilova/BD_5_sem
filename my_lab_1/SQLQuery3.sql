-- BULK INSERT ��������� ������ �� ����� ������ � �������.
BULK INSERT Gallery.dbo.tblEducation
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\education.txt'
-- CODEPAGE - ������ ������� �������� ������ � ����� ������
-- ACP - ������� ���� char, varchar ��� text ������������� �� ������� �������� ANSI � ������� �������� SQL Server.
-- DATAFILETYPE ���������, ��� ���������� BULK INSERT ��������� �������� ������� � �������������� ���������� ���� ����� ������.
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblStyle
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\picture_style.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO


BULK INSERT Gallery.dbo.tblGenre
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\picture_genre.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPainter
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\painter.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPainters
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\painters.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblGenres
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\genres.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblPicture
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\picture.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblTenant
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\tenants.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblCollector
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\collector.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

BULK INSERT Gallery.dbo.tblLogBook
FROM 'D:\�������  25.08.20\labs\5_sem_BD\my_lab_1\data\logbook.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n')

GO

--SELECT * FROM Gallery.dbo.tblTenant;

INSERT Gallery.dbo.tblTenant VALUES ('30000', '�', '��������', '�����', '��������', '�. �����������, ������������ ������� �����, �.2, ��.89', '+7 (997) 635-98-86', '2004-06-03', 'justfood@outlook.com')

INSERT Gallery.dbo.tblTenant VALUES ('30000', 'T', '��������', '�����', '��������', '�. �����������, ������������ ������� �����, �.2, ��.89', '+7 (997) 635-98-86', '2004-06-03', 'justfood@outlook.com')
