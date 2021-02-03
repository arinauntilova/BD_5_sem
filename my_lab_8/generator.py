
import random
import datetime
import time

title = ["Metel", "Emma", "Bessi", "Dvoinik", "Prevrashenie", "Voskresenie",
         "Asia", "Lolita", "Iskuplenie", "Koldovstvo"]

id = 0;
pid = 501
while(1):
    id += 1
    now = datetime.datetime.now()
    print(str(now.year))
    f = open(str(id) + '_tblpicture_' + str(now.year) + '-' + str(now.month) + '-' + str(now.day) + ".csv", 'w')
    f.write("PictureID" + '\t' + "PictureName" + '\t' + "PaintersID" + '\t' + "GenresID" + '\t' + "StyleID" + '\t' + "Year")

    for i in range (2):
        f.write("\n" + str(pid) + '\t')   # index
        a = random.choice(title)                # name
        f.write(a + '\t')
        b = random.randint(1, 500)  # painters id
        f.write(str(b) + '\t')
        c = random.randint(1, 10)  # genres id
        f.write(str(c) + '\t')
        e = random.randint(1, 36)   # style
        f.write(str(e) + '\t')
        d = random.randint(1700, 1970)   # year
        f.write(str(d))
        pid += 1
    
    f.close()
    time.sleep(5)
