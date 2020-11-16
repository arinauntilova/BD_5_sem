USE Gallery;
GO

-- 1 �������� ���������
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.Year > 1900

-- 2 �������� BETWEEN.
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.Year BETWEEN 1900 and 1930

-- 3 �������� LIKE.
-- ������ �������� ������, � ������� ���� ����� "�������"
SELECT P.PictureName, P.Year
FROM tblPicture AS P
WHERE P.PictureName LIKE '%�������%'

-- 4 �������� IN � ��������� �����������.
SELECT P.PictureName, P.StyleID, P.Year
FROM tblPicture AS P
WHERE P.StyleID IN 
	(
		SELECT S.StyleID
		FROM tblStyle AS S
		WHERE S.StyleName = '���������'
	)

-- 5 �������� EXISTS � ��������� �����������.
SELECT L.TenantID, L.PictureID
FROM tblLogBook AS L
WHERE EXISTS 
	(
		SELECT *
        FROM tblPicture AS P
        WHERE L.PictureID = P.PictureID AND P.StyleID < 5
	)

-- 6 �������� ��������� � ���������
-- ����� ������� ������
SELECT L.*
FROM tblLogBook AS L
WHERE L.Issuing > ALL
(
	SELECT L2.Issuing
	FROM tblLogBook AS L2
	WHERE L2.TenantID = 10
)

-- 7 ���������� ������� � ���������� ��������
-- ������� �����������, ����� min/max
SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate' , COUNT(L.Issuing) AS 'LogIssuingCount'
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

-- 8 ��������� ���������� � ���������� ��������.
-- ��������� ��������� � ������, ������������ ������������ ��������� �������� (������, ����� � �.�.).
-- ���-�� ������
SELECT L.TenantID,
	   L.PictureID,
	   (
			SELECT COUNT(G.GenreID) 
			FROM tblGenres AS G
			WHERE G.PictureID = L.PictureID
	   ) AS GenresCount
FROM tblLogBook AS L
ORDER BY L.TenantID 

-- 9 ������� ��������� CASE.
-- ����� ������� ���������
-- ���������� ������ ��������� � ���������� � ������ ����������� WHEN. 
-- ���� ��� ��������� ������������, �� ������������ ��������� � ����������� THEN.
-- ����������� ������ �������� ���������
-- ���������� ���������, ��������������� ������ �������� ������ TRUE.

-- GETDATE ���������� ������� ���� � �����.
-- DATEDIFF ���������� �������� �������, ���������� ����� ����� ���������� ���������
-- DATEDIFF ( datepart , startdate , enddate ) , 
-- datepart - �������, � ������� ������� DATEDIFF �������� � ������� ����� startdate � enddate.
-- CAST ����������� ��������� ������ ���� � �������.
SELECT I.PictureID, I.TenantID, 
	CASE YEAR(I.Issuing)
		WHEN YEAR(Getdate()) THEN 'This Year'
		WHEN YEAR(GetDate()) - 1 THEN 'Last year'
		ELSE CAST(DATEDIFF(year, I.Issuing, Getdate()) AS nvarchar(2)) + ' years ago'
	END AS 'When issuing'
FROM tblLogBook AS I

-- 10 ��������� ��������� CASE.
-- ���������� ���������
SELECT P.PictureName, 
	CASE
		WHEN P.Year >= 1900 THEN '20 ���'
		WHEN P.Year >= 1800  THEN '19 ���'
		WHEN P.Year >= 1700  THEN '18 ���'
		WHEN P.Year >= 1600  THEN '17 ���'
		ELSE '�������������'
	END AS PictureDate
FROM tblPicture AS P


-- 11 �������� ����� ��������� ��������� ������� ��                            
-- ��������������� ������ ������ ���������� SELECT. 

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate' , COUNT(L.Issuing) AS 'BookIssuingCount'
INTO #PictureIssuingRange
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

--SELECT * 
--FROM #PictureIssuingRange


-- 12 ��������� ���������������                                     
-- ���������� � �������� ����������� ������ � ����������� FROM.

SELECT L.TenantID, L.PictureID, TMP.GenreCount
FROM tblLogBook AS L JOIN
(
	SELECT Gs.PictureID, COUNT(Gs.GenreID) AS GenreCount
	FROM tblGenres AS Gs
	GROUP BY PictureID
) AS TMP ON L.PictureID = TMP.PictureID



-- 13 � ��������� ���������� � ������� ����������� 3.

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
				WHERE G.GenreID = Gs.GenreID AND G.GenreName = '������������ ��������'
			)
		)
	)



-- 14 ��������������� ������ � ������� �����������
-- GROUP BY, �� ��� ����������� HAVING.

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate'
FROM tblLogBook AS L
GROUP BY L.TenantID
ORDER BY L.TenantID

-- 15 ��������������� ������ � ������� �����������
-- GROUP BY � ����������� HAVING.

SELECT L.TenantID, MIN(L.Issuing) AS 'MinDate', MAX(L.Issuing) AS 'MaxDate'
FROM tblLogBook AS L
GROUP BY L.TenantID
HAVING COUNT(L.Issuing) > 2
ORDER BY L.TenantID

-- 16  INSERT, ����������� ������� � ������� �����
-- ������ ��������.

INSERT tblGenre(GenreID, GenreName)
VALUES (37, '����������� ������')

-- SELECT *
-- FROM tblGenre

-- 17 ������� � ������� ��������������� ������ ������ ���������� ����������. 

INSERT tblGenre(GenreID, GenreName)
SELECT (
	SELECT MAX(G.GenreID) + 1
	FROM tblGenre AS G
	), '���������� ������'
	

/*
SELECT *
FROM tblLogBook
*/
/*
DELETE FROM tblLogBook
WHERE PictureID = 500 
*/

-- 18 ������� ���������� UPDATE.

UPDATE tblPicture
SET Year = Year + 1
WHERE PictureName = '�����������'

/*
SELECT *
FROM tblPicture
*/

-- 19  UPDATE �� ��������� ����������� � ����������� SET.

UPDATE tblPicture
SET Year = 
(
	SELECT MAX(P.Year)
	FROM tblPicture AS P
	WHERE P.PictureName LIKE '%�����%'
)
WHERE PictureName LIKE '%�����%'

-- 20 ������� ���������� DELETE.

DELETE tblPicture
WHERE PictureName is NULL


-- 21  DELETE � ��������� ��������������� ����������� �
-- ����������� WHERE.

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

-- 22 ������� ���������� ��������� ���������
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


--SELECT MAX(PictureCount) AS '������������ �� ���', MIN(PictureCount) AS '����������� �� ���'
--FROM CTE

-- 23 ����������� ���������� ��������� ���������.

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


-- ����������� ���
WITH recursive (id, name, parent_category, depth) as (
	-- ����������� ������������� ��������
    SELECT id, name, parent_category, 0 AS depth
    FROM category
    WHERE name = 'Software' 
    UNION ALL
	-- -- ����������� ������������ ��������
    SELECT child.id, child.name, child.parent_category, depth + 1
    FROM category child
             join recursive parent on parent.id = child.parent_category 
    WHERE depth < 3 --(�������� �������)
)
-- ����������, ������������ ���
SELECT *
FROM recursive;

SELECT *
FROM category

drop table category;


-- 24 ������� �������. ������������� ����������� MIN/MAX/AVG OVER()

SELECT DISTINCT G.GenreID, G.GenreName, AVG(P.Year) OVER (PARTITION BY G.GenreId) AS AvgYear
FROM tblPicture P join tblGenres Gs on Gs.PictureID = P.PictureID
join tblGenre G on G.GenreID = Gs.GenreID

-- 25  ������� ������ ��� ���������� ������

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


/* �������������� �������
��������� ���������� ���������� ���� ����� �� ���� id.
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