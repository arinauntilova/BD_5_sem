-- Создаем Gallery
CREATE DATABASE [Gallery]
GO

-- Gallery
USE [Gallery]
GO

-- VARCHAR - длина слова = фактическим символам + длина

CREATE TABLE tblEducation
(
	EducationID INT NOT NULL,
	EducationName VARCHAR (30) NOT NULL
);

CREATE TABLE tblStyle
(
	StyleID INT NOT NULL,
	StyleName VARCHAR (40) NOT NULL
);

CREATE TABLE tblGenre
(
	GenreID INT NOT NULL,
	GenreName VARCHAR (40) NOT NULL
);

CREATE TABLE tblPainter
(
	PainterID INT NOT NULL,
	PainterFirstName VARCHAR (30) NOT NULL,
	PainterSecondName VARCHAR (30) NOT NULL,
	PainterMiddleName VARCHAR (30)
);

CREATE TABLE tblPainters
(
	PictureID INT NOT NULL,
	PainterID INT NOT NULL
);

CREATE TABLE tblGenres
(
	PictureID INT NOT NULL,
	GenreID INT NOT NULL
);

CREATE TABLE tblPicture
(
	PictureID INT NOT NULL,
	PictureName VARCHAR (100) NOT NULL,
	PaintersID INT NOT NULL,  
	GenresID INT NOT NULL,   
	StyleID INT NOT NULL,
	-- Возвращает целое число, представляющее год указанной даты.
	Year INT NOT NULL
);

CREATE TABLE tblTenant
(
	TenantID INT NOT NULL,
	TenantSex CHAR (1) NOT NULL,
	TenantFirstName VARCHAR (30) NOT NULL,
	TenantSecondName VARCHAR (30) NOT NULL,
	TenantMiddleName VARCHAR (30),
	Address VARCHAR (150) NOT NULL,                 
	Telephone CHAR (20) NOT NULL,
	Birthdary DATETIME NOT NULL,
	Email CHAR (50) NOT NULL
);

CREATE TABLE tblCollector
(
	CollectorID INT NOT NULL,
	CollectorSex CHAR (1) NOT NULL,
	CollectorFirstName VARCHAR (30) NOT NULL,
	CollectorSecondName VARCHAR (30) NOT NULL,
	CollectorMiddleName VARCHAR (30),
	SNILS CHAR (14) NOT NULL,
	INN CHAR (12) NOT NULL,
	Address VARCHAR (150) NOT NULL,
	Telephone CHAR (20) NOT NULL,
	Birthdary DATETIME NOT NULL,
	Email CHAR (50) NOT NULL,
	EducationID INT NOT NULL,
	Salary MONEY NOT NULL,
	Passport CHAR (10) NOT NULL
);


CREATE TABLE tblLogBook
(
	PictureID INT NOT NULL,
	TenantID INT NOT NULL,
	CollectorID INT NOT NULL,
	Issuing DATETIME NOT NULL
);

GO