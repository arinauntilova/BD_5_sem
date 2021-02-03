using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

//1.Чтение из XML/JSON документа.
//2. Обновление XML/JSON документа.
//3. Запись (Добавление) в XML/JSON документ.

namespace LinqToXML
{
    class Program
    {
        static void Main(string[] args)
        {
            ReadFromXML("file.xml");
            UpdateXML("file.xml");
            WriteToXML("file.xml");
            Console.ReadLine();
        }

        static void ReadFromXML(string filename)
        {
            XDocument xdoc = XDocument.Load(filename);
            //Возвращает коллекцию подчиненных узлов
            var books = from Book in xdoc.Descendants("tblPainter")
                        select Book.Value;

            Console.WriteLine("Всего: {0} художников(-a)!", books.Count());
            for (int i = 1; i <= books.Count(); ++i)
                //Возвращает элемент по указанному индексу в последовательности.
                Console.WriteLine("{0}) Художник: {1}", i, books.ElementAt(i - 1));

            Console.WriteLine("");
        }

        static void UpdateXML(string filename)
        {
            XDocument xdoc = XDocument.Load(filename);

            var elements = xdoc.Element("ROOT").Elements("tblPainter");

            foreach (var el in elements)
                if (el.Element("PainterID").Value.Equals("501"))
                    el.Element("PainterFirstName").SetValue("Карпов");

            var painters = from book in xdoc.Descendants("PainterFirstName")
                        select book.Value;

            for (int i = 1; i <= painters.Count(); ++i)
                Console.WriteLine("{0}) FirstName: {1}", i, painters.ElementAt(i - 1));

            Console.WriteLine("");
        }


        static void WriteToXML(string filename)
        {
            XDocument xdoc = XDocument.Load(filename);

            XElement xe1 = new XElement("FullName", "Анна-Мария");  // <FullName>Полина-Мария</FullName>  

            var elements = xdoc.Element("ROOT").Elements("tblPainter");

            foreach (var el in elements)
            {
                if (el.Element("PainterSecondName").Value.Equals("Анна"))
                    el.Add(xe1);
            }

            var books = from book in xdoc.Descendants("FullName")
                        select book.Value;

            for (int i = 1; i <= books.Count(); ++i)
                Console.WriteLine("{0}) {1}", i, books.ElementAt(i - 1));

            Console.WriteLine("");
        }
    }
}
