USE MASTER
CREATE DATABASE RK_3_1
GO

--USE Gallery

--DROP DATABASE RK_3_1

USE RK_3_1
GO

select @@servername 


CREATE TABLE DATEANDTIME1
(
	id_d int NOT NULL,
	dates DATETIME2,
	dayw nvarchar(50),
	times TIME,
	tip int
)

CREATE TABLE SOTRUDNIKI1
(
	id_s int NOT NULL,
	fio nvarchar(50),
	datebirth DATETIME2,
	otdel nvarchar(50)
)

--DROP TABLE DATEANDTIME1
--DROP TABLE SOTRUDNIKI1

-- ALTER TABLE DATEANDTIME1  DROP CONSTRAINT id_FK1
-- ALTER TABLE DATEANDTIME1 DROP CONSTRAINT id_d_PK


USE RK_3_1
GO

USE RK_3_1
GO
ALTER TABLE SOTRUDNIKI1
ADD CONSTRAINT id_s_PK1  PRIMARY KEY (id_s)
GO

ALTER TABLE DATEANDTIME1
ADD CONSTRAINT id_FK1  FOREIGN KEY (id_d) REFERENCES SOTRUDNIKI1(id_s)
GO



USE RK_3_1
GO
insert into SOTRUDNIKI1(id_s, fio, datebirth, otdel)
values (1, 'Иванов Иван Иванович', '25-09-1990', 'ИТ');

insert into SOTRUDNIKI1(id_s, fio, datebirth, otdel)
values (2, 'Иванов Петр Михайлович', '25-09-1970', 'ИТ');

insert into SOTRUDNIKI1(id_s, fio, datebirth, otdel)
values (3, 'Петров Петр Петрович', '12-11-1987', 'Бухгалтерия');

insert into SOTRUDNIKI1(id_s, fio, datebirth, otdel)
values (4, 'Чернов Игорь Петрович', '12-11-1987', 'Бухгалтерия');


USE RK_3_1
GO
insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(1, '21-12-2019', 'Суббота', '9:01', 1);


insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '21-12-2019', 'Суббота', '8:20', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '21-12-2019', 'Суббота', '9:20', 2);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '21-12-2019', 'Суббота', '9:30', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '21-12-2019', 'Суббота', '9:50', 2);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '14-12-2018', 'Суббота', '9:20', 2);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(2, '14-02-2019', 'Суббота', '9:20', 2);


insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '21-12-2019', 'Суббота', '10:00', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '21-12-2019', 'Суббота', '10:05', 2);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '21-12-2019', 'Суббота', '10:15', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '22-12-2019', 'Суббота', '10:15', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '14-12-2018', 'Суббота', '9:05', 1);

insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(3, '14-12-2017', 'Суббота', '10:05', 1);


insert into DATEANDTIME1(id_d, dates , dayw, times , tip)
values(4, '21-12-2019', 'Суббота', '8:05', 1);

SELECT *
FROM DATEANDTIME1


-- === 1) Скалярная функция ===
IF OBJECT_ID (N'dbo.CalculateNum', N'FN') IS NOT NULL
    DROP FUNCTION dbo.CalculateNum;
GO

CREATE FUNCTION dbo.CalculateNum (@date_tmp DATETIME2)
RETURNS int
	WITH RETURNS NULL ON NULL INPUT
	AS
	BEGIN
		RETURN
		(
			select count(*)
			from(
				select distinct id_s
				from SOTRUDNIKI1
				where DATEDIFF(YEAR, GETDATE(), datebirth) BETWEEN 18 and 40 and 
				id_s in(
					select id_d
					from(
						select id_d, dates, tip, count(*) as cant
						from DATEANDTIME1
						where dates = @date_tmp
						group by id_d, dates, tip
						having tip = 2 and count(*) > 3
						) as table_1
					)
				) as table_2
		);
	END;

GO

SELECT dbo.CalculateNum ('21-12-2019') as Result;



SELECT otdel, count(id_s)
FROM SOTRUDNIKI1
GROUP BY otdel
HAVING count(id_s) > 10


SELECT id_s, fio
FROM SOTRUDNIKI1
WHERE id_s not in(
    SELECT id_d
    from(
        select id_d, dates, tip, count(*) as cnt
        from DATEANDTIME1
        GROUP BY id_d, dates, tip
        HAVING tip = 2 and count(*) > 1) as table_1)


SELECT distinct otdel
FROM SOTRUDNIKI1
WHERE id_s in(
    SELECT id_d
    from(
        select id_d,  MIN(times) as min_time
        from DATEANDTIME1
        WHERE tip = 1 and dates = '21-12-2019'
        GROUP BY id_d
        HAVING MIN(times) > '9:00') as table_1)