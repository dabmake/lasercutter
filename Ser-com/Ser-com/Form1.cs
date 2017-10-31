using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        SerialPort Serial = new SerialPort();
        string RxString;
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
            Serial.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(Serial_DataReceived);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Serial.Close();
            textBox1.Text += textBox3.Text.Trim() +  " geschlossen\r\n";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Serial.WriteLine(textBox2.Text.Trim());
        }


        private void Serial_DataReceived (object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            RxString = Serial.ReadExisting();
            Invoke(new EventHandler(DisplayText));
            
        }

        private void DisplayText(object sender, EventArgs e)
        {
            textBox1.AppendText(RxString);
        }

        
    }
}
