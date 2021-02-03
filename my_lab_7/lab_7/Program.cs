using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Создать не менее пять запросов с использованием всех
//ключевых слов выражения запроса

// ======================================================      1     =================================================================
namespace LinqToObj
{
    public class Picture
    {
        public int id { get; set; }
        public string pictureName { get; set; }
        public string genreId { get; set; }
        public int year { get; set; }
        public List<int> painterId { get; set; }

        public Picture(int ID, string pictureName, string genreId, int year, List<int> painterIds)
        {
            this.id = ID;
            this.pictureName = pictureName;
            this.genreId = genreId;
            this.year = year;
            this.painterId = painterIds;
        }
    };

    public class Tenant
    {
        public int id { get; set; }
        public string name { get; set; }
        public int age;
        public string sex { get; set; }
        public List<int> PicturesIDs { get; private set; }

        public Tenant(int id, string name, int age, string sex, List<int> PicturesIDs)
        {
            this.id = id;
            this.name = name;
            this.age = age;
            this.sex = sex;
            this.PicturesIDs = PicturesIDs;
        }
    };



    public static class PicturesINFO
    {
        private static List<Picture> Pictures;
        private static List<Tenant> Tenants;

        public static IList<Picture> getPictures()
        {
            if (Pictures == null)
            {
                Pictures = new List<Picture>(20);
                Pictures.Add(new Picture(1, "Живые и мёртвые", "1", 1992, new List<int> { 3, 1, 5 }));
                Pictures.Add(new Picture(2, "Маленький принц", "24", 2001, new List<int> { 6, 3 }));
                Pictures.Add(new Picture(3, "Слова", "20", 1982, new List<int> { 3 }));
                Pictures.Add(new Picture(4, "Институт сновидений", "15", 1943, new List<int> { 5, 6, 8 }));
                Pictures.Add(new Picture(5, "Арт-Трэвэл", "8", 2016, new List<int> { 6, 2 }));
                Pictures.Add(new Picture(6, "Молодая гвардия", "5", 1996, new List<int> { 2, 4, 2 }));
                Pictures.Add(new Picture(7, "Сквозь тайгу", "3", 1982, new List<int> { 1, 2 }));
                Pictures.Add(new Picture(8, "Гонимые", "2", 1982, new List<int> { 6, 8 }));
                Pictures.Add(new Picture(9, "По праву памяти", "3", 2013, new List<int> { 7 }));
                Pictures.Add(new Picture(10, "Алтайская повесть", "6", 1990, new List<int> { 5, 7 }));
                Pictures.Add(new Picture(11, "Отверженные", "4", 1967, new List<int> { 2 }));
                Pictures.Add(new Picture(12, "Ликуя и скорбя", "14", 1979, new List<int> { 5, 7, 8 }));
                Pictures.Add(new Picture(13, "Повесть о лесах", "11", 2003, new List<int> { 1, 7 }));
                Pictures.Add(new Picture(14, "Спартак", "9", 1944, new List<int> { 8 }));
                Pictures.Add(new Picture(15, "Крестный отец", "3", 1947, new List<int> { 1, 7, 8 }));
            }
            return Pictures;
        }

        public static IList<Tenant> getTenants()
        {
            if (Tenants == null)
            {
                Tenants = new List<Tenant>()
                {
                    new Tenant(1, "Глушковa Антонина Исидоровна", 32,  "Ж", new List<int> {3, 5}),
                    new Tenant(2, "Дмитриев Агафон Германович",  18,  "М", new List<int> {1, 4, 7}),
                    new Tenant(3, "Фомин Амирам Маратович",  21,  "М", new List<int> {1, 5}),
                    new Tenant(4, "Ветров Петр Ефимович",  41,  "М", new List<int> {1, 5}),
                    new Tenant(5, "Измайлов Вадим Юстусович", 31,  "М", new List<int> {2, 5, 7}),
                    new Tenant(6, "Макаров Рустам Остапович",  32,  "М", new List<int> {2, 6, 5, 7, 9}),
                    new Tenant(7, "Скворцов Давид Аристархович",   19,  "М", new List<int> {2, 5}),
                    new Tenant(8, "Быковa Анна Ролановна",  47,  "Ж", new List<int> {3, 6, 7, 9})
                };
            }
            return Tenants;
        }

    }

    class Program
    {
        static void Main(string[] args)
        {
            getTenantsOfPicture(1);
            getTenantsPicturesBySex("Ж");
            getTenantsBySex();
            getPicturesJoinTenants();
            getAvgAgeByCities();

            Console.ReadLine();
        }

        // == 1 == Имена арендаторов, которые брали в аренду картину с id = PictureId
        static void getTenantsOfPicture(int PictureId = 1)
        {
            //var сообщает компилятору о необходимости определения типа переменной из выражения,
            //находящегося с правой стороны оператора инициализации.
            var TenantsList = from c in PicturesINFO.getTenants()  // инф-я об арендаторах
                              where (c.PicturesIDs.Contains(PictureId))
                              select c.name;

            foreach (var Tenant in TenantsList)
                Console.WriteLine(Tenant);

            Console.WriteLine();
            Console.WriteLine();
        }

        // == 2 == Для каждой картины, у которой арендатор определенного пола,
        // отдельно вывести информацию об арендаторе
        static void getTenantsPicturesBySex(string sex = "Ж")
        {
            // Выборка из нескольких источников
            var FirmTenants = from c in PicturesINFO.getTenants()
                              from id in c.PicturesIDs
                              where c.sex == sex
                              orderby c.name
                              let new_n = "Mrs. " + c.name
                              select new_n + ", пол: " + c.sex + ", картина: " + id + ";";

            foreach (var Tenant in FirmTenants)
                Console.WriteLine(Tenant);

            Console.WriteLine();
            Console.WriteLine();
        }

        //// == 3 == Группируем арендаторов по полу, сортируем в убывающ. порядке по кол-ву
        //            на экран выводим информацию о полученных группах 
        //            (кол-во арендаторов каждого пола и их имена)
        static void getTenantsBySex()
        {
            var Tenants = from t in PicturesINFO.getTenants()
                          group t by t.sex into gr
                          orderby gr.Count() descending  
                          select new   // оператор select создает объект анонимного типа
                          {
                              sex = gr.Key,
                              count = gr.Count(),
                              Tenants_name = from d in gr
                                        select d.name
                          };

            foreach (var i in Tenants)
            {
                Console.WriteLine("\nПол: " + i.sex + " - " + i.count + " арендатора(-ов)");
                foreach (var name in i.Tenants_name)
                    Console.WriteLine("> " + name + " ");
            }

            Console.WriteLine();
            Console.WriteLine();
        }

        // === 4 === Для каждого арендатора в отдельной строке выводим все картины,
        // которые он взял в аренду
        static void getPicturesJoinTenants()
        {
            var tenants_all = from t in PicturesINFO.getTenants()
                              from nun in t.PicturesIDs
                              select new
                              {
                                  fName = t.name,
                                  PicNo = nun
                              };

            var TenPictures = from t in tenants_all
                              join p in PicturesINFO.getPictures() on t.PicNo equals p.id
                              orderby t.fName ascending
                              select new
                              {
                                  Fname = t.fName,
                                  Pname = p.pictureName
                              };

            Console.WriteLine("Арендатор / картина");
            foreach (var rb in TenPictures)
                Console.WriteLine("{0} / {1}", rb.Fname, rb.Pname);

            Console.WriteLine();
            Console.WriteLine();

        }


        // === 5 ===  Группируем арендаторов по полу,
        // для каждого ищем средний возраст,
        // результат упорядочиваем по возрастанию ср. возраста
        static void getAvgAgeByCities()
        {
            var categpry = (from f in
                              from c in PicturesINFO.getTenants()
                              group c by c.sex into ci
                              select new
                              {
                                  skey = ci.Key,
                                  AvgAge = (from c1 in ci
                                            select c1.age).Average()

                              }
                          orderby f.AvgAge ascending
                          select f);

            Console.WriteLine("Пол - cредний возраст арендаторов");
            foreach (var genreId in categpry)
                Console.WriteLine("{0} - {1}", genreId.skey, genreId.AvgAge);
            Console.WriteLine();
        }
    }
}
