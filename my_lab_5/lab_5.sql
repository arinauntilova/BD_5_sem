Use Gallery
GO

--   ========================================    1    ===========================================

-- Из таблиц базы данных извлечь данные в XML (MSSQL) .
-- Для выгрузки в XML проверить все режимы конструкции FOR XML.

SELECT top 1 *
from dbo.tblPainter
--FOR XML AUTO, ELEMENTS
--FOR XML RAW, XMLDATA
--FOR XML RAW('Customer'), ELEMENTS
FOR XML PATH('Customer'), ELEMENTS XSINIL
GO

--explicit
SELECT top 1 1 AS tag,
    null AS parent,
	PainterID AS 'author!1!id',
    PainterFirstName AS 'author!1!lname',
    PainterSecondName AS 'author!1!sname'
FROM dbo.tblPainter
FOR XML EXPLICIT
GO

--explicit 2
SELECT top 1 1 AS tag,
    null AS parent,
	PainterID AS 'author!1!id',
    PainterFirstName AS 'author!1!lname!element',
    PainterSecondName AS 'author!1!sname!element'
FROM dbo.tblPainter
FOR XML EXPLICIT
GO


