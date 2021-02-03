using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq;
using System.Data;
using System.Data.Linq.Mapping;
using System.Xml.Linq;
using System.Reflection;


//Создать запросы четырех типов:
//1.Однотабличный запрос на выборку.
//2. Многотабличный запрос на выборку.
//3. Три запроса на добавление, изменение и удаление данных в базе данных.
//4. Получение доступа к данным, выполняя только хранимую процедуру.

namespace LinqToSQL
{
    // Класс DataContext обрабатывает подключение к базе данных. 
    public class PicturesEx : DataContext
    {
        public Table<Picture> Pictures;
        public Table<Style> Styles;

        public PicturesEx(string connection) : base(connection) { }

        //ExecuteMethodCall является защищенным(protected). 
        //Это значит, что вызывать этот метод в коде приложения нельзя, => нужно унаследовать свой класс от DataContext.
        // хранимая процедура
       [Function(Name = "dbo.PictureYearProc1")]
        public int PictureYear([Parameter(Name = "Year", DbType = "Int")] int Num,
                                [Parameter(Name = "CountP", DbType = "Int")] ref int count)
        {
            //Вызвать Executemethod, чтобы заполнить пустую функцию 
            //использует объект MethodInfo для доступа к атрибуту метода Function, чтобы получить имя хранимой процедуры,
            //и для получения имен и типов параметров.
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), Num, count);
            //Предоставляет доступ к n-ному выходному параметру.
            count = ((int)(result.GetParameterValue(1)));
            return ((int)(result.ReturnValue));
        }
    }

        
    [Table(Name = "tblPicture")]
    public class Picture
    {

        [Column(Name = "PictureID", DbType = "Int NOT NULL IDENTITY",
            IsPrimaryKey = true)]
        public int PictureID { get; set; }

        [Column(Name = "PictureName")]
        public string PictureName { get; set; }

        [Column(Name = "PaintersID")]
        public int PaintersID { get; set; }

        [Column(Name = "GenresID")]
        public int GenresID { get; set; }

        [Column(Name = "StyleID")]
        public int StyleID { get; set; }

        [Column(Name = "Year")]
        public int Year { get; set; }

        [Association(Name = "StyleID", ThisKey = "StyleID", OtherKey = "StyleID", IsForeignKey = true)] // , OtherKey = "StyleID"
        public EntitySet<Style> Styles { get; set; }

        public Picture()
        {
            this.PictureID = 503;
            //Обеспечивает отложенную загрузку и поддержку связей "один ко многим"
            this.Styles = new EntitySet<Style>();
        }
    }

    [Table(Name = "tblStyle")]
    public class Style
    {
        [Column(Name = "StyleID", DbType = "Int NOT NULL IDENTITY",
            IsPrimaryKey = true, IsDbGenerated = true)]
        public int StyleID { get; set; }

        [Column(Name = "StyleName")]
        public string StyleName { get; set; }

        /*
        [Association(Name = "Picture", ThisKey = "StyleID")]
        public EntityRef<Picture> Picture;
        */
        public Style()
        {
            //this.Picture = new EntityRef<Picture>();
        }
    }



    class Program
    {
        static void Main(string[] args)
        {
            PicturesEx db = new PicturesEx(@"Data Source = DESKTOP-9NAV2ON\MSSQLSERVER1; Database = Gallery; Integrated Security = true");
            db.Log = Console.Out;

            GetPicture1843(db);
            Console.ReadLine();

            MultiSelect(db);
            Console.ReadLine();

            Add(db);
            Console.ReadLine();

            Update(db);
            Console.ReadLine();

            //Delete(db);
            //Console.ReadLine();

            int count = 0;
            db.PictureYear(1910, ref count);
            Console.WriteLine("Кол-во картин раньше {0} года: {1}", 1910, count);
        }

        // вывести названия картин, написанных в 1843
        static void GetPicture1843(PicturesEx db)
        {
            IQueryable<Picture> list = from p in db.Pictures
                                    where p.Year == 1843
                                    select p;

            foreach (Picture p in list)
                Console.WriteLine("{0}", p.PictureName);
        }

        // вывести названия картин, у которых стиль = "абстракционизм"
        static void MultiSelect(PicturesEx db)
        {
            IQueryable<Picture> list = from p in db.Pictures 
                                       join s in db.Styles on p.StyleID equals s.StyleID
                                       where s.StyleName == "Абстракционизм"
                                       select p;

            foreach (Picture p in list)
                Console.WriteLine("Picture_Name: {0}, style_id: {1}", p.PictureName, p.StyleID);
        }

        static void Add(PicturesEx db)
        {
            Picture newPicture = new Picture();
            newPicture.PictureID = 505;
            newPicture.PictureName = "Свободная страна";
            newPicture.PaintersID = 1;
            newPicture.GenresID = 1;
            newPicture.StyleID = 1;
            newPicture.Year = 1980;

            // Чтобы добавить новый объект в базу данных
            db.Pictures.InsertOnSubmit(newPicture);

            db.SubmitChanges();

            var query = from p in db.Pictures
                        where p.PictureID == 505
                        select p;

            foreach (var item in query)
                Console.WriteLine(item.PictureID + "  " + item.PictureName + "  " + item.Year);

        }

        static void Update(PicturesEx db)
        {
            Console.WriteLine("Before update:\n");

            Picture pictt = db.GetTable<Picture>().OrderByDescending(u => u.PictureID).FirstOrDefault();
            Console.WriteLine(pictt.PictureID + "  " + pictt.PictureName + "  " + pictt.Year);
            var str = "Вечернее шоу";
            pictt.PictureName = str;
            db.SubmitChanges();

            Console.WriteLine("\nAfter update update: \n");
            Console.WriteLine(pictt.PictureID + "  " + pictt.PictureName + "  " + pictt.Year);
        }

        static void Delete(PicturesEx db)
        {

            foreach (var cl in db.GetTable<Style>().OrderByDescending(u => u.StyleID).Take(5))
            {
                Console.WriteLine("{0} \t{1}", cl.StyleID, cl.StyleName);
            }
            Style pictt = db.GetTable<Style>().OrderByDescending(u => u.StyleID).FirstOrDefault();
            db.Styles.DeleteOnSubmit(pictt);
            db.SubmitChanges();

            foreach (var cl in db.GetTable<Picture>().OrderByDescending(u => u.StyleID).Take(5))
            {
                Console.WriteLine("{0} \t{1} \t{2}", cl.PictureID, cl.PictureName, cl.Year);
            }

        }
    }
}