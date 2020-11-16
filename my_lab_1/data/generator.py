
import random
first_names = ["Tolstoy", "Pushkin", "Lermontov", "Dostoyevskii", "Esenin",
               "London", "Ostin", "Mittchell", "Bronte", "Remark"]
title = ["Metel", "Emma", "Bessi", "Dvoinik", "Prevrashenie", "Voskresenie",
         "Asia", "Lolita", "Iskuplenie", "Koldovstvo"]
edition = ["Rosmen", "Moskva", "Feniks", "Flamingo", "Uventa", "Pero", "Simbat",
           "Drofa"]
pages = [100, 200, 456, 345, 890, 560, 230, 15, 1034, 521, 456, 110, 223, 312, 210, 24,
         32, 87, 160, 117, 475, 720, 831, 860, 912, 976, 1001, 342, 300, 541, 803, 908, 1200, 1153]

flaag = [1 , 2, 3]

tec_genre = ["fizika", "himia", "algebra", "geometria"]
tec_native = ["+", "-"]
tec_transl = ["+", "-"]
tec_year = [1990, 1860, 1880, 1925, 1948, 1995, 1845]

fict_genre = ["novel", "play", "poems"]

chil_genre = ["fairy_tale", "poems"]

array = []
array1 = []

##with open('kartini.txt', 'r', encoding = "utf8") as f1:
##    line = f1.readlines() 
##    print(line)
##
##for word in line:
##    word1 = word
##    new = word1.lower().capitalize()
##    array.append(new)
##
##print(array)


temp = open('kartini.txt','r', encoding = "utf8").read().split('\n')
for word in temp:
    word1 = word
    new = word1.lower().capitalize()
    array1.append(new)
##print(temp)
print(array1)



f = open('try1.txt', 'w')
for i in range (len(array1)):
    f.write(str(i + 1) + '\t')   # index
    a = array1[i]                # name
    f.write(a + '\t')
    b = random.randint(1, 500)  # painters id
    f.write(str(b) + '\t')
    c = random.randint(1, 500)  # genres id
    f.write(str(c) + '\t')
    e = random.randint(1, 36)   # style
    f.write(str(e) + '\t')
    d = random.randint(1700, 1970)   # year
    f.write(str(d) + '\n')

f.close()
