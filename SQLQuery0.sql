-- ��������� ��                                            
-- USE � �������, � ������� ������� ����� ����������� �������� ���� ������ � SQL �����������.

-- �� master �������� ��� ��������� ���������� � SQL Server
-- �������� �������� � ��������� master
USE [master] 
GO

-- ������� ��, ���� ��� ����
-- N - �������������� ������ � Unicode
-- sys.databases - ������ ��� ������ �� ���������� Microsoft SQL Server.

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Gallery')
DROP DATABASE [Gallery]
GO

-- � �������� ������� ���������� ������ � ���������� ��� ��������� ������ ������� GO.