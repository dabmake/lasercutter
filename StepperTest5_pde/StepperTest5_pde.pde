// Adafruit Motor shield library
// copyright Adafruit Industries LLC, 2009
// this code is public domain, enjoy!

#include <AFMotor.h>

// Connect a stepper motor with 48 steps per revolution (7.5 degree)
// to motor port #2 (M3 and M4)
AF_Stepper motor1(48, 1); //Y-Achse
AF_Stepper motor2(48, 2); //X-Achse 
int LASER = 2;
int cutspeed =10;

#define COMMAND_SIZE 128


char aWord[COMMAND_SIZE];
String command;
String command_part[6];
int part;
int last_space;
long serial_count;
long no_data = 0;
float x,y;
char c;
long code;
char buf[10]; // Buffer für Umwandlung String to Float 
int x_neu, y_neu;
int x_aktu, y_aktu;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  //Serial.println("Plotter ready");
  x_aktu= 0;
  y_aktu= 0;
  pinMode(LASER, OUTPUT); 
}

void loop() 
{
  
  

  if (Serial.available() > 0) {
    // read next character
    //====================
    c = Serial.read();
    no_data = 0;

    // newline is end of command
    //==========================
    if (c != '\n') {
      aWord[serial_count] = c;
      serial_count++;
    }
  }    

 
    if (serial_count && (c == '\n'))  {
   
    no_data = 0;
    c = ' ';
    command=aWord;
    int length;
    //Serial.println(command);
    part=0;
    last_space= 0;
   
    for (int i=0; i < serial_count; i++)
    {
      if (command.charAt(i) == ' ') {
        command_part[part] = command.substring(last_space,i);
        last_space=i+1;
        if (command_part[part].length() != 0) {
           part++;
        }
      }
    }
     command_part[part] = command.substring(last_space,serial_count); //letztes Kommando extrahieren, d gibts kein Space   
     part++;    
    
    
    for (int i=0; i < part; i++){
           
      //Serial.println(command_part[i]);
     
    }
         
         
      
      
       
      if ((command_part[0] == "G01") || (command_part[0] == "g01") || (command_part[0] == "G1")) {
        extract_parameter();  
        moveTo(x_neu, y_neu,cutspeed);
        Serial.println("OK");
       }
     
     if ((command_part[0] == "G02") || (command_part[0] == "g02") || (command_part[0] == "G2")) {
        extract_parameter();
        moveTo(x_neu, y_neu,cutspeed);
        Serial.println("OK");
       }
     
     if ((command_part[0] == "G03") || (command_part[0] == "g03") || (command_part[0] == "G3")) {
        extract_parameter();
        moveTo(x_neu, y_neu,cutspeed);
        Serial.println("OK");
       }
     
     if ((command_part[0] == "G21") || (command_part[0] == "g21")) {
        
        //Nix tun
        Serial.println("OK");
       }
     
     if ((command_part[0] == "G90") || (command_part[0] == "g90")) {
        
        //Nix tun
        Serial.println("OK");
       }
     
     
     
     
     if ((command_part[0] == "G0") || (command_part[0] == "g0")) {
        extract_parameter();
        moveTo(x_neu, y_neu,5);
        Serial.println("OK");
       }
     
     if ((command_part[0] == "M03") || (command_part[0] == "M3")) {
        //Laser an
        digitalWrite(LASER, HIGH);
        Serial.println("OK");
       } 
      
     if ((command_part[0] == "M05") || (command_part[0] == "M5")) {
        //Laser aus
        digitalWrite(LASER, LOW);
        Serial.println("OK");
       } 


     if ((command_part[0] == "M02") || (command_part[0] == "M2")) {
        //Laser aus
        digitalWrite(LASER, LOW);
        Serial.println("OK");
       } 


      
    clear_process_string();    
    }
    
  
}


void line(int x0, int y0, int x1, int y1, int velo)
{
  int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;  // 1 Forward -1 Backward
  int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;  //
  int err = dx+dy, e2; /* error value e_xy */

/*  Serial.print("dx:");
  Serial.println(dx, DEC);

  Serial.print("dy:");
  Serial.println(dy, DEC);

  Serial.print("sx:");
  Serial.println(sx, DEC);

  Serial.print("sy:");
  Serial.println(sy, DEC);

  Serial.print("dy:");
  Serial.println(dy, DEC);

  Serial.print("err:");
  Serial.println(err, DEC); */

 
  for(;;){  /* loop */
    
    if (x0==x1 && y0==y1) break;
    e2 = 2*err;
    if (e2 > dy) { 
      err += dy; x0 += sx; 
      if (sx == 1) motor1.onestep(FORWARD, INTERLEAVE); 
      else motor1.onestep(BACKWARD, INTERLEAVE); 
      //Serial.print("x0:");
      //Serial.println(x0, DEC);  
     } //Schritt x Achse
    
    if (e2 < dx) {
       err += dx; y0 += sy; 
       if (sy == 1) motor2.onestep(FORWARD, INTERLEAVE); 
       else motor2.onestep(BACKWARD, INTERLEAVE); 
       //Serial.print("y0:");
       //Serial.println(y0, DEC);    
       } //Schritt y Achse
    delay (velo);
    
    
   /* Serial.print("e2:");
    Serial.println(e2, DEC);
    Serial.print("err:");
    Serial.println(err, DEC);
   */

  }
}


/*void test_line()
{
  
  line (1,1, 20,1);
   delay (100); 
   line (20,1, 20,20);
   delay (100); 
   line (20,20, 1,20);
   delay (100);    
   line (1,20, 1,1);
      delay (100); 
      
}*/

void clear_process_string()
{
  // init our command
  //=================
  for (byte i=0; i<COMMAND_SIZE; i++)
    aWord[i] = 0;
    serial_count = 0;
}

void moveTo(int x1, int y1, int velo)
{  
  line (x_aktu, y_aktu, x1, y1, velo);
  x_aktu=x1;
  y_aktu=y1;
}


void extract_parameter()
{
   if (command_part[1].startsWith("X")) {
        command_part[1] = command_part[1].substring(1, command_part[1].length()+1);
        //Serial.println(command_part[1]);
        command_part[1].toCharArray(buf,command_part[1].length()+1);
        
        x = atof (buf); 
        //Serial.println(x, 4);
        x = x *10;
        //x= x * 20;
        x_neu = int (x);
      }
      if (command_part[2].startsWith("Y")) {
        command_part[2] = command_part[2].substring(1, command_part[2].length()+1);
        //Serial.println(command_part[2]);
        
        command_part[2].toCharArray(buf,command_part[2].length()+1);
        y= atof (buf); 
        y = y *10;
        //y= y* 20;
        y_neu = int (y);
        //Serial.println(y, 4);
      }
      
      if (command_part[1].startsWith("F")) {
        command_part[1] = command_part[1].substring(1, command_part[1].length()+1);
        //Serial.println(command_part[1]);
        command_part[1].toCharArray(buf,command_part[1].length()+1);
        
        cutspeed = atof (buf); 
        cutspeed = int (900/cutspeed);
        
      }
      
}


