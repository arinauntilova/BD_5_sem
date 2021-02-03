-- Вариант 3

USE MASTER
CREATE DATABASE Univ
GO

DROP DATABASE Univ

USE Univ
Use Gallery

CREATE TABLE Teachers
(
		TID INT NOT NULL,
		TName varchar(50) NOT NULL,
		Tst int NOT NULL,
		Job varchar(50) NOT NULL,
		KID int NOT NULL
);

DROP TABLE Teachers

CREATE TABLE Kafedra
(
		KID INT NOT NULL,
		KName varchar(50) NOT NULL,
		Descr varchar(50) NOT NULL
);

CREATE TABLE Predmet
(
		PID INT NOT NULL,
		PName varchar(50) NOT NULL,
		Kol INT NOT NULL,
		Sem INT NOT NULL,
		Reiting INT NOT NULL,
);

CREATE TABLE TP
(
		TID INT NOT NULL,
		PID INT NOT NULL
);

ALTER TABLE Teachers
ADD CONSTRAINT TID_PK  PRIMARY KEY (TID)
GO

ALTER TABLE Kafedra
ADD CONSTRAINT KID_PK  PRIMARY KEY (KID)
GO

ALTER TABLE Predmet
ADD CONSTRAINT PID_PK  PRIMARY KEY (PID)
GO

ALTER TABLE TP
ADD CONSTRAINT TPID_PK  PRIMARY KEY (TID, PID)
GO

--ALTER TABLE Teachers
--DROP CONSTRAINT KID_FK
--GO


ALTER TABLE Teachers
ADD CONSTRAINT KID_FK  FOREIGN KEY (KID) REFERENCES Kafedra(KID)
GO

ALTER TABLE TP
ADD CONSTRAINT PID_FK  FOREIGN KEY (PID) REFERENCES Predmet(PID),
CONSTRAINT TID_FK  FOREIGN KEY (TID) REFERENCES Teachers(TID)

GO


INSERT INTO Teachers(TID, TName, Tst, Job, KID) VALUES
(1, 'ВетровПИ', 1, 'Лаборант', 1),
(2, 'ПетровПИ', 3, 'Преподавать', 2),
(3, 'ИвановПИ', 1, 'ЗавКаф', 3),
(4, 'ЧерновПИ', 3, 'Декан', 4),
(5, 'ДягилевПИ', 1, 'Лаборант', 5),
(6, 'ТучинПИ', 2, 'Лаборант', 6),
(7, 'ФакираПИ', 1, 'Преподавать', 7),
(8, 'МайкаПИ', 3, 'Лаборант', 8),
(9, 'СидоровПИ', 1, 'ПреподаваПть', 9),
(10, 'ПостригайПИ', 2, 'Помощник', 10)
GO

INSERT INTO Kafedra(kID, KName, Descr) VALUES
(1, 'математика', 'изучает точные науки'),
(2, 'астрономия', 'изучает звезды'),
(3, 'русский', 'изучает язык'),
(4, 'иностранный', 'изучает язык'),
(5, 'физика', 'изучает точные науки'),
(6, 'социология', 'изучает социологию'),
(7, 'биология', 'изучает историю'),
(8, 'психология', 'изучает психологию'),
(9, 'литература', 'изучает литру'),
(10, 'история', 'изучает историю')
GO

INSERT INTO Predmet(PID, PName, Kol, Sem, Reiting) VALUES
(1, 'алгебра', 10, 3, 2),
(2, 'астрономия', 15, 4, 3),
(3, 'русский', 10, 2, 4),
(4, 'английский', 10, 1, 2),
(5, 'физика', 10, 2, 2),
(6, 'обществознание', 10, 2, 1),
(7, 'природа',20, 2, 2),
(8, 'природа', 10, 6, 3),
(9, 'литература', 12, 5, 2),
(10, 'геометрия', 10, 2, 5)
GO

INSERT INTO TP(TID, PID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10)


--================== 2 =============================

--1
-- Самая высокая ученая степень среди всех 'Преподавателей'
SELECT 
FROM Teachers AS T
WHERE T.Tst > ALL
(
	SELECT T.TST
	FROM Teachers AS T1
	WHERE T1.Job = 'Преподаватель'
)

--2 

-- Группируем по номеру семестра, в каждом семестре выводим MAX и MIN рейтинг предмета
SELECT Predmet.Sem, MAX(Predmet.Reiting) AS 'MaxReiting', MIN(Predmet.Reiting) AS 'MinReiting'
from Predmet
GROUP BY Predmet.Sem
ORDER BY Predmet.PID

-- 3

-- Группируем по номеру семестра, в каждом семестре выводим MAX и MIN рейтинг предмета 
-- и записываем результат во временную таблицу TmpPredmet
SELECT Predmet.Sem, MAX(Predmet.Reiting) AS 'MaxReiting', MIN(Predmet.Reiting) AS 'MinReiting'
INTO #TmpPredmet
from Predmet
GROUP BY Predmet.Sem
ORDER BY Predmet.PID

SELECT *
FROM #TmpPredmet

-- =====================================   3   ==================================

IF OBJECT_ID (N'dbo.Info', 'P') IS NOT NULL
	DROP PROCEDURE dbo.Info;
GO

CREATE PROCEDURE dbo.Info @name varchar(25) 
AS
BEGIN
	DECLARE @database_id int
	DECLARE @table_id int
	SET @database_id = DB_ID('Univ')
	SET @table_id = OBJECT_ID('Univ.' + @name, N'U')
	IF @table_id IS NULL
	BEGIN
		PRINT ('Table is not found!!!!')
		RETURN
	END

	SELECT *
	FROM sys.dm_db_index_physical_stats(@database_id, @table_id, NULL, NULL, NULL)
END
GO

-- Тест процедуры
EXEC dbo.Info @name = 'Predmet'
GO
