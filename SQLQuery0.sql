-- Системная БД                                            
-- USE – команда, с помощью которой можно переключать контекст базы данных в SQL инструкциях.

-- БД master содержит всю системную информацию о SQL Server
-- Начинаем работать в контескте master
USE [master] 
GO

-- Удаляем БД, если она есть
-- N - преобразование строки в Unicode
-- sys.databases - список баз данных на экземпляре Microsoft SQL Server.

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Gallery')
DROP DATABASE [Gallery]
GO

-- В качестве сигнала завершения пакета и выполнения его выражений служит команда GO.