USE Gallery;
GO


select @@servername -- ��� �������

SELECT USER_NAME();  -- ��� ������������
GO  

INSERT INTO tblArtTrends VALUES
(1, '���-���'),
(2, '���-���'),
(3, '�������-���')

SELECT *
FROM tblArtTrends

select *
from sys.sysprocesses
order by login_time

select *
from  tblPicture