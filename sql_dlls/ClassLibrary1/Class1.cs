using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;   // ссылка для доступа к атрибутам
using System.Data.SqlClient;        // ссылка для доступа к пространству имен ADO.NET
using System.Threading; 
using System.Data;

namespace HandWrittenUDF
{
    // скалярная
    public class UserDefinedFunctions
    {
        [SqlFunction(DataAccess = DataAccessKind.Read)]    // описание вида доступа к функции
        public static int CountYear(int num)
        {
           /* Для подключения к исходной базе данных нужен экземпляр класса SqlConnection. */
            using (SqlConnection conn = new SqlConnection("context connection = true"))    // использование созданного соединения
            {
                conn.Open();       // установка соединения с сервером
                SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) AS 'Number ' FROM tblPicture WHERE Year >  " + num, conn);    // создание запроса в базе
                return (int)cmd.ExecuteScalar();       // метод команды executescalar возвращает int на основе запроса cmd
            }
        }
    }


    // агрегатная
    [Serializable]
    [SqlUserDefinedAggregate(
        // Значение Format.Native можно использовать только с типами данных, которые 
        // SQL Server может читать и записывать непосредственно в байтовый поток.
        // (System.Byte, System.SByte, System.Int16....)
        Format.Native, // UserDefined
        // свойства оптимизатора
        IsInvariantToDuplicates = false,
        IsInvariantToNulls = true,
        IsInvariantToOrder = true,
        IsNullIfEmpty = true,
        Name = "AgrFunc")]
    public struct AgrFunc
    {
        private int result;
        private int count;

        public int GetSumm()
        {
            return result;
        }
        // выполняет действия инициализации
        public void Init()
        {
            result = 0;
            count = 0;
        }
        // содержит сам алгоритм вычисления агрегата 
        public void Accumulate(SqlInt32 Value)
        {
            if (!Value.IsNull && !Value.IsNull)
            {
                result += (int)Value;
                count++;
            }
        }
        // содержит код для тех случаев, 
        // когда агрегатная функция применяется с другой агрегатной функцией.
        public void Merge(AgrFunc Group)
        {
            result += Group.GetSumm();
        }
        // здесь вычисляется и возвращается окончательное значение
        public SqlInt32 Terminate()
        {
            if (result > 0)
            {
                return new SqlInt32(result / count);
            }
            else
            {
                return SqlInt32.Null;
            }
        }

    }

    // табличная
     public partial class NTableFunc
    {

        private class PictureResult
        {
            public SqlInt32 PictureID;
            public SqlString PictureName;

            public PictureResult(SqlInt32 pictId, SqlString pictname)
            {
                PictureID = pictId;
                PictureName = pictname;
            }
        }

        public static bool ValidateName(SqlString pict)
        {
            if (pict.IsNull)
                return false;
            return true;
        }

        [SqlFunction(
        DataAccess = DataAccessKind.Read,
        FillRowMethodName = "Fill_Row",
        TableDefinition = "PictureID int, PictureName nvarchar(4000)")]
        public static IEnumerable FindPictures(SqlInt32 numyear)
        {
            ArrayList resultCollection = new ArrayList();

            using (SqlConnection connection = new SqlConnection("context connection=true"))
            {
                connection.Open();

                using (SqlCommand selectpict = new SqlCommand(
                    "SELECT " + "[PictureID], [PictureName]" +
                    "FROM tblPicture " +
                    "WHERE Year >= " + numyear,
                    connection))
                {
                    SqlParameter modifiedSinceParam = selectpict.Parameters.Add(
                        "@modifiedSince",
                        SqlDbType.Int);
                    modifiedSinceParam.Value = numyear;

                    using (SqlDataReader pictReader = selectpict.ExecuteReader())
                    {
                        while (pictReader.Read())
                        {
                            // Возвращает значение заданного столбца, i - номер столбца
                            SqlString pictname = pictReader.GetSqlString(1);
                            if (ValidateName(pictname))
                            {
                                resultCollection.Add(new PictureResult(
                                    pictReader.GetSqlInt32(0),
                                    pictname));
                            }
                        }
                    }
                }
            }
            return resultCollection;
        }
        public static void Fill_Row(
            object pictResultObj, out SqlInt32 customerId, out SqlString pictname)
        {
            PictureResult pictResult = (PictureResult)pictResultObj;
            customerId = pictResult.PictureID;
            pictname = pictResult.PictureName;
        }
    }

    public class StoredProcedure
    {
        [SqlProcedure]
        public static void CopyLogs(string table)
        {
            using (SqlConnection connection = new SqlConnection("context connection=true"))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("select * into " + table + " from tblLogBook where year(Issuing) = year(getdate()) - 6;", connection);
                command.ExecuteNonQuery();
            }
        }
    }

    public partial class Triggers
    {
        [Microsoft.SqlServer.Server.SqlTrigger(Name = "Trigger", Target = "tblPicture", Event = "FOR UPDATE")]
        public static void UpdateTrigger()
        {
            SqlTriggerContext triggerContext = SqlContext.TriggerContext;
            if (triggerContext.TriggerAction == TriggerAction.Update)
                SqlContext.Pipe.Send("You have succesfully updated note in the table! Bingo!");
        }
    }

    [Serializable]
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
    public struct pict_serial_num : INullable
    {
        public Int32 seria;
        public Int32 spec_num;
        public override string ToString()
        {
            return seria + " " + spec_num;
        }
        public bool IsNull => _null;                            
        public static pict_serial_num Null => new pict_serial_num { _null = true };
        public static pict_serial_num Parse(SqlString s)
        {
            if (s.IsNull){
                return Null;
            }
            pict_serial_num num = new pict_serial_num();
            string[] arr = s.Value.Split(' ');
            num.seria = Convert.ToInt32(arr[0]);
            num.spec_num = Convert.ToInt32(arr[1]);
            return num;
        }
        public int Seria => seria;
        public int Number => spec_num;
        //  Private member
        private bool _null;
    }
}



