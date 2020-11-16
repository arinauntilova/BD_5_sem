USE Gallery;
GO

-- ALTER TABLE - для добавления, изменения или удаления столбцов в таблице
-- + для переименования таблицы

ALTER TABLE tblEducation
ADD
-- ADD CONSTRAINT - для создания ограничения после того, как таблица уже создана
-- Ограничение, выполняющее принудительную проверку целостности сущностей для 
-- указанного столбца или столбцов при использовании уникального индекса. 
-- Для каждой таблицы может быть создано только одно ограничение PRIMARY KEY.
CONSTRAINT PK_Education PRIMARY KEY (EducationID);
GO

ALTER TABLE tblStyle
ADD
CONSTRAINT PK_Style PRIMARY KEY (StyleID);
GO

ALTER TABLE tblPainter
ADD
CONSTRAINT PK_Painter PRIMARY KEY (PainterID);
GO

ALTER TABLE tblGenre
ADD
CONSTRAINT PK_Genre PRIMARY KEY (GenreID);
GO

ALTER TABLE tblPicture
ADD
CONSTRAINT PK_Picture PRIMARY KEY (PictureID),
-- StyleId - внешний ключ, имя связ. таблицы, столбца
CONSTRAINT FK_Picture_StyleID FOREIGN KEY (StyleID) REFERENCES tblStyle (StyleID);
GO

ALTER TABLE tblPainters
ADD
CONSTRAINT PK_Painters PRIMARY KEY (PictureID, PainterID),
CONSTRAINT FK_Painters_PictureID FOREIGN KEY (PictureID) REFERENCES tblPicture (PictureID),
CONSTRAINT FK_Painters_PainterID FOREIGN KEY (PainterID) REFERENCES tblPainter (PainterID);
GO

ALTER TABLE tblGenres
ADD
CONSTRAINT PK_Genres PRIMARY KEY (PictureID, GenreID),
CONSTRAINT FK_Genres_PictureID FOREIGN KEY (PictureID) REFERENCES tblPicture (PictureID),
CONSTRAINT FK_Genres_GenreID FOREIGN KEY (GenreID) REFERENCES tblGenre (GenreID);
GO

ALTER TABLE tblTenant
ADD
CONSTRAINT PK_Tenant PRIMARY KEY (TenantID);
GO

ALTER TABLE tblCollector
ADD
CONSTRAINT PK_Collector PRIMARY KEY (CollectorID),
CONSTRAINT FK_Collector_EducationID FOREIGN KEY (EducationID) REFERENCES tblEducation (EducationID);
GO

ALTER TABLE tblLogBook
ADD
CONSTRAINT PK_tblLogBook PRIMARY KEY (PictureID, TenantID, CollectorID), 
CONSTRAINT FK_tblLogBook_PictureID FOREIGN KEY (PictureID) REFERENCES tblPicture (PictureID),
CONSTRAINT FK_tblLogBook_TenantID FOREIGN KEY (TenantID) REFERENCES tblTenant (TenantID),
CONSTRAINT FK_tblLogBook_CollectorID FOREIGN KEY (CollectorID) REFERENCES tblCollector (CollectorID);

GO

/*
ALTER TABLE tblLogBook
DROP CONSTRAINT FK_tblLogBook_TenantID ;
go
*/

-- правило для пола
-- правило, ограничивающее значения, вставляемые в столбец или столбцы 
-- (к которым привязано данное правило) только теми значениями, которые указаны в правиле.
-- [] - явное объявление имени объекта..                            
-- @ - локальная переменная                                                   
CREATE RULE [Sex_rule]  AS  @sex IN ('М', 'Ж');
GO
-- EXEC команда для запуска хранимых процедур и SQL инструкций в виде текстовых строк.
-- sp_bindrule - привязывает правило к столбцу или к псевдониму типа данных.
EXEC sp_bindrule 'Sex_rule', 'tblTenant.TenantSex';
EXEC sp_bindrule 'Sex_rule', 'tblCollector.CollectorSex';
GO


-- дата
CREATE RULE [CorrectYear]  AS  @year > '1900-01-01';
GO
EXEC sp_bindrule 'CorrectYear', 'tblTenant.Birthdary';
EXEC sp_bindrule 'CorrectYear', 'tblCollector.Birthdary';
GO