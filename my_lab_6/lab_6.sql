USE Gallery;
GO


select @@servername -- имя сервера

SELECT USER_NAME();  -- имя пользователя
GO  

INSERT INTO tblArtTrends VALUES
(1, 'Поп-арт'),
(2, 'Соц-арт'),
(3, 'Минимал-арт')

SELECT *
FROM tblArtTrends

select *
from sys.sysprocesses
order by login_time

select *
from  tblPicture