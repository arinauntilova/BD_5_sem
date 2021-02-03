USE Gallery
go

select *
from tblPicture

select *
from tblPicture 
where PictureID = 513

INSERT INTO tblPicture (PictureID, PictureName, PaintersID, GenresID, StyleID, Year) VALUES (501, 'fff', 100, 1, 1, 1999)


 DELETE FROM tblPicture WHERE PictureID >= 501 and PictureID <= 7790 