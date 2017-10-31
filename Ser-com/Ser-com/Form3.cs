using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.IO;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        SerialPort Serial = new SerialPort();
       
        public Form1()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Serial.PortName = textBox3.Text.Trim();
            Serial.BaudRate = 9600;
            Serial.Open();
            textBox1.Text += textBox3.Text.Trim() + " geöffnet\r\n";
            
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Serial.Close();
            textBox1.Text += textBox3.Text.Trim() +  " geschlossen\r\n";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Serial.WriteLine(textBox2.Text.Trim());
            int antwort = Serial.ReadByte();
            textBox1.Text += antwort + "\r\n";
        
        }

        

        private void button4_Click(object sender, EventArgs e)
        {
            StreamReader file = new StreamReader(textBox4.Text.Trim());
            string line;
            List<string> lines = new List<string>();
            while ((line = file.ReadLine()) != null)
            {
                lines.Add(line);
            }

            foreach (string s in lines)
            {
                textBox1.Text += s + "\r\n";
                textBox1.SelectionStart = textBox1.Text.Length;
                textBox1.ScrollToCaret();

            }

            textBox1.Text += lines.Count + "\r\n";
            textBox1.SelectionStart = textBox1.Text.Length;
            textBox1.ScrollToCaret();

            for (int i = 0; i < lines.Count; i++)
            {
                textBox1.Text += lines[i].Length + "\r\n";
                textBox1.SelectionStart = textBox1.Text.Length;
                textBox1.ScrollToCaret();
                if (lines[i].Length > 1)
                {
                    Serial.WriteLine(lines[i]);

                    int antwort = Serial.ReadByte();
                    while (antwort != 86)
                    { }
                    textBox1.Text += antwort + "\r\n";
                    textBox1.SelectionStart = textBox1.Text.Length;
                    textBox1.ScrollToCaret();
                }

            }

        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                textBox1.Text += openFileDialog1.FileName;
                textBox4.Text = openFileDialog1.FileName;
            }
        }


        


        
    }
}
