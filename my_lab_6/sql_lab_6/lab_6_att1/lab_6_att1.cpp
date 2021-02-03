using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient; //For SQL Connection

namespace Пример_SQL_Server_приложения
{
    public partial class Form1 : Form  //www.nookery.ru
    {
        public Form1()
        {
            InitializeComponent();
        }
        SqlConnection con;
        SqlDataAdapter da;
        SqlCommand cmd;
        DataSet ds;

        void GetList()
        {
            con = new SqlConnection(@"Data Source=.\SQLEXPRESS; Initial Catalog=dbSchool; Integrated Security=True");
            da = new SqlDataAdapter("Select *From Student", con);
            ds = new DataSet();
            con.Open();
            da.Fill(ds, "Student");
            dataGridView1.DataSource = ds.Tables["Student"];
            con.Close();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            GetList();
        }

        private void button1_Click(object sender, EventArgs e) // Insert Button
        {
            cmd = new SqlCommand();
            con.Open();
            cmd.Connection = con;
            cmd.CommandText = "insert into Student(ID,FirstName,LastName) values (" + textBox1.Text + ",'" + textBox2.Text + "','" + textBox3.Text + "')";
            cmd.ExecuteNonQuery();
            con.Close();
            GetList();
        }

        private void button2_Click(object sender, EventArgs e)//Update Button
        {
            cmd = new SqlCommand();
            con.Open();
            cmd.Connection = con;
            cmd.CommandText = "update Student set FirstName='" + textBox2.Text + "',LastName='" + textBox3.Text + "' where ID=" + textBox1.Text + "";
            cmd.ExecuteNonQuery();
            con.Close();
            GetList();

        }

        private void button3_Click(object sender, EventArgs e)//Delete Button
        {
            cmd = new SqlCommand();
            con.Open();
            cmd.Connection = con;
            cmd.CommandText = "delete from Student where ID=" + textBox1.Text + "";
            cmd.ExecuteNonQuery();
            con.Close();
            GetList();
        }
    }
}