using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Xml.Linq;
//using System.Data;
using System.Data.SqlClient;
using System.Data.Linq;
//using System.Data.Linq.Mapping;
//using System.Text;
//using System.Threading.Tasks;
//using System.IO;
//using System.Reflection;

namespace ConsoleApp2
{
    class Program
    {
        public static DataContext db;

        //Integrated Security означает использование windows аутентификации при которой подключение к серверу 
        //делается от имени учетной записи под которой запущен процесс.
        private static string connectionstring = @"Data Source = DESKTOP-9NAV2ON\MSSQLSERVER1; Database = Gallery; Integrated Security = true";
        static void Main(string[] args)
        {

            db = new DataContext(@"Data Source = DESKTOP-9NAV2ON\MSSQLSERVER1; Database = Gallery; Integrated Security = true");

            while(true)
            {
                Console.Write("\n=== Меню === \n" +
                    "1) Выполнить скалярный запрос;\n" +
                    "2) Выполнить запрос с несколькими соединениями (JOIN);\n" +
                    "3) Выполнить запрос с ОТВ и оконными функциями;\n" +
                    "4) Выполнить запрос к метаданным; \n" +
                    "5) Вызвать скалярную функцию; \n" +
                    "6) Вызвать многооператорную или табличную функцию;\n" +
                    "7) Вызвать хранимую процедуру;\n" +
                    "8) Вызвать системную функцию или процедуру;\n" +
                    "9) Создать таблицу в базе данных, соответствующую тематике БД;\n" +
                    "10) Выполнить вставку данных в созданную таблицу с использованием INSERT или COPY;\n" +
                    "11) Выход.\n");
                Console.Write("\nВаш выбор:  \n");
                string ch_str = Console.ReadLine();
                
                switch (ch_str)
                {
                    case "1":
                        // скалярный запрос
                        // Кол-во картин, написанных раннее 1910 года

                        const string queryString = @"SELECT COUNT(P.PictureID)
                                                    FROM dbo.tblPicture AS P
                                                    WHERE P.Year < 1910";

                        SqlConnection connection = new SqlConnection(connectionstring);
                        connection.Open();

                        SqlCommand command = new SqlCommand(queryString, connection);

                        //Отправляет CommandText в Connection и строит SqlDataReader.
                        SqlDataReader dataReader = command.ExecuteReader();
                        //DataReader является хорошим выбором при извлечении больших объемов данных, поскольку данные не кэшируются в памяти.
                        //метод DataReader. Read для получения строки из результатов запроса.
                        Console.WriteLine("\nКол-во картин, написанных раннее 1910 года: ");
                        while (dataReader.Read())
                            Console.WriteLine(dataReader[0].ToString());

                        dataReader.Close();
                        connection.Close();
                        break;

                    case "2":
                        // запрос с несколькими соединениями (JOIN)
                        // Картины, у которых жанр = "Исторический"

                        const string queryString1 = @"SELECT P.PictureID, P.PictureName
                                                    FROM tblPicture P join tblGenres Gs on Gs.PictureID = P.PictureID
                                                                      join tblGenre G on G.GenreID = Gs.GenreID
                                                    WHERE G.GenreName = 'Исторический' ";

                        SqlConnection connection1 = new SqlConnection(connectionstring);
                        connection1.Open();

                        SqlCommand command1 = new SqlCommand(queryString1, connection1);

                        SqlDataReader dataReader1 = command1.ExecuteReader();
                        Console.WriteLine("\nКартины, у которых жанр = 'Исторический': ");
                        while (dataReader1.Read())
                            Console.WriteLine(dataReader1[0].ToString() + "  " + dataReader1[1].ToString());

                        dataReader1.Close();
                        connection1.Close();
                        break;

                    case "3":
                        //запрос с ОТВ(CTE) и оконными функциями
                        //Вывести для каждого жанра ID, название и средний год написания картин этого жанра

                        const string queryString2 = @"WITH CTE (GenreID, GenreName, AvgYear)
                                                     AS 
                                                     (
                                                         SELECT DISTINCT G.GenreID, G.GenreName, AVG(P.Year) OVER (PARTITION BY G.GenreId) AS AvgYear
                                                      FROM tblPicture P join tblGenres Gs on Gs.PictureID = P.PictureID
                                                      join tblGenre G on G.GenreID = Gs.GenreID
                                                     )
                                                     SELECT *
                                                     FROM CTE; ";

                        // Вариант №2: Посчитать сколько картиин было написано в каждом году, затем пронумеровать 
                        // присваивает одинаковые номера строкам с одинаковыми значениями, а «лишние» номера пропускает.

                        //const string queryString2 = @"WITH CTE (PictureYear, PictureCount)
                        //                                AS 
                        //                                (
                        //                                    SELECT P.Year, COUNT(*) AS PCount
                        //                                    FROM tblPicture AS P
                        //                                    GROUP BY P.Year
                        //                                )
                        //                                SELECT DISTINCT PictureYear, PictureCount, RANK() OVER (ORDER BY PictureCount) AS Row_N
                        //                                FROM CTE; ";

                        SqlConnection connection2 = new SqlConnection(connectionstring);
                        connection2.Open();

                        SqlCommand command2 = new SqlCommand(queryString2, connection2);

                        SqlDataReader dataReader2 = command2.ExecuteReader();
                        Console.WriteLine("\nВывести для каждого жанра ID, название и средний год написания картин этого жанра: ");
                        while (dataReader2.Read())
                            Console.WriteLine(dataReader2[0].ToString() + "  " + dataReader2[1].ToString() + "  " + dataReader2[2].ToString());

                        dataReader2.Close();
                        connection2.Close();
                        break;

                    case "4":
                        // запрос к метаданным
                        // Вывод информации о таблицах базы данных

                        const string queryString3 = @"SELECT 
		                                                    name AS TableName, 
		                                                    create_date AS CreatedDate, 
		                                                    modify_date as ModifyDate 
	                                                FROM sys.tables 
	                                                ORDER BY ModifyDate; ";

                        SqlConnection connection3 = new SqlConnection(connectionstring);
                        connection3.Open();

                        SqlCommand command3 = new SqlCommand(queryString3, connection3);

                        SqlDataReader dataReader3 = command3.ExecuteReader();
                        Console.WriteLine("\nВывод информации о таблицах базы данных: ");
                        while (dataReader3.Read())
                            Console.WriteLine(dataReader3[0].ToString() + "  " + dataReader3[1].ToString() + "  " + dataReader3[2].ToString());
                        dataReader3.Close();
                        connection3.Close();
                        break;

                    case "5":
                        // Вызвать скалярную функцию 
                        // кол-во картин, написанных раньше 1800г.

                        const string queryString4 = @"SELECT dbo.CalculatePicturesWithYearLes(1800) as Less_1800";
                        
                        SqlConnection connection4 = new SqlConnection(connectionstring);
                        connection4.Open();

                        SqlCommand command4 = new SqlCommand(queryString4, connection4);

                        SqlDataReader dataReader4 = command4.ExecuteReader();
                        Console.WriteLine("\nКол-во картин, написанных раньше 1800г.: ");
                        while (dataReader4.Read())
                            Console.WriteLine(dataReader4[0].ToString());

                        dataReader4.Close();
                        connection4.Close();
                        break;

                    case "6":
                        // Вызвать многооператорную или табличную функцию; (табличная)
                        // Картины, написанные раньше указанного года

                        const string queryString5 = @"SELECT *
                                                      FROM dbo.GetPictures (1720); ";

                        SqlConnection connection5 = new SqlConnection(connectionstring);
                        connection5.Open();

                        SqlCommand command5 = new SqlCommand(queryString5, connection5);

                        SqlDataReader dataReader5 = command5.ExecuteReader();
                        Console.WriteLine("\nКартины, написанные раньше 1720г: ");
                        while (dataReader5.Read())
                            Console.WriteLine(dataReader5[0].ToString() + " " + dataReader5[1].ToString());

                        dataReader5.Close();
                        connection5.Close();
                        break;

                    case "7":
                        // Вызвать хранимую процедуру (рекурсивную)
                        // Иерархия художественных стилей

                        const string queryString6 = @"EXECUTE dbo.ProcRec";

                        SqlConnection connection6 = new SqlConnection(connectionstring);
                        connection6.Open();

                        SqlCommand command6 = new SqlCommand(queryString6, connection6);

                        SqlDataReader dataReader6 = command6.ExecuteReader();
                        Console.WriteLine("\nИерархия художественных стилей: ");
                        while (dataReader6.Read())
                            Console.WriteLine(dataReader6[0].ToString() + "  " + dataReader6[1].ToString() + "  " + dataReader6[2].ToString()
                                                 + "  " + dataReader6[3].ToString());

                        dataReader6.Close();
                        connection6.Close();
                        break;

                    case "8":
                        // Вызвать системную функцию или процедуру
                        // попытка изменить пол Коллекционера на недопустимое значение => перехват исключения и вывод сообщения 
                        // @@ERROR - Возвращает номер ошибки для последней выполненной инструкции 
                        //SELECT N'A check constraint violation occurred.';
                        const string queryString7 = @"  BEGIN TRY    
                                                            UPDATE tblCollector  
                                                            SET CollectorSex = 'E'  
                                                            WHERE CollectorID = 1; 
                                                        END TRY  
                                                        BEGIN CATCH                                                               
                                                            IF @@ERROR = 513
                                                            BEGIN
                                                                SELECT N'A check constraint violation occurred.';
                                                            END 
                                                        END CATCH;    ";

                        SqlConnection connection7 = new SqlConnection(connectionstring);
                        connection7.Open();

                        SqlCommand command7 = new SqlCommand(queryString7, connection7);

                        SqlDataReader dataReader7 = command7.ExecuteReader();
                        Console.WriteLine("\nВызов системной функции @@ERROR при попытке изменить пол Коллекционера на недопустимое значение: ");
                        while (dataReader7.Read())
                            Console.WriteLine(dataReader7[0].ToString());

                        dataReader7.Close();
                        connection7.Close();
                        break;


                    case "9":
                        // Создать таблицу в базе данных, соответствующую тематике БД
                        // Создается таблица Направлений в искусстве (ID, Название течения)

                        const string queryString81 = @" IF OBJECT_ID(N'tblArtTrend','U') IS NOT NULL
                                                            DROP TABLE tblArtTrend
                                                        CREATE TABLE tblArtTrend (
                                                        TrendID INT NOT NULL, 
                                                        TrendName VARCHAR(50) NOT NULL ); ";

                        SqlConnection connection8 = new SqlConnection(connectionstring);
                        connection8.Open();

                        SqlCommand command81 = new SqlCommand(queryString81, connection8);
                        command81.ExecuteNonQuery();
                        Console.WriteLine("\nСоздается таблица Направлений в искусстве (ID, Название течения): ");
                        connection8.Close();
                        break;

                    case "10":
                        // Создать таблицу в базе данных, соответствующую тематике БД
                        // В созданную таблицу добавляются значения

                        const string queryString92 = @"  INSERT INTO tblArtTrend VALUES
                                                        (1, 'Поп-арт'),
                                                        (2, 'Соц-арт'),
                                                        (3, 'Минимал-арт')";

                        const string queryString93 = @"  SELECT *
                                                         FROM tblArtTrend";

                        SqlConnection connection9 = new SqlConnection(connectionstring);
                        connection9.Open();

                        SqlCommand command92 = new SqlCommand(queryString92, connection9);
                        command92.ExecuteNonQuery();

                        SqlCommand command93 = new SqlCommand(queryString93, connection9);

                        SqlDataReader dataReader9 = command93.ExecuteReader();
                        Console.WriteLine("\nВ созданную таблицу добавляются значения и выводятся на экран: ");
                        while (dataReader9.Read())
                            Console.WriteLine(dataReader9[0].ToString() + "  " + dataReader9[1].ToString());

                        dataReader9.Close();
                        connection9.Close();
                        break;

                    case "11":
                        return;

                    default:
                        Console.WriteLine("Вы выбрали неверный пункт меню!");
                        break;
                }
            }

        }
    }
}