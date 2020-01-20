#include <SoftwareSerial.h>

#include "HX711.h"
#include "Enums.h"

// Sensor 1
// DT - pin #A0
// SCK - pin #A1

// Sensor 2
// DT - pin #A2
// SCK - pin #A3

// Sensor 3
// DT	- pin #A4
// SCK	- pin #A5

#define CALIBRATION_VALUE 113

#define LOADCELL_DOUT_PIN A2
#define LOADCELL_SCK_PIN A3

//SERIAL
const int BUFFLENGTH = 40;
String commandBuffer = "";

//HX711 load(A0, A1);    // parameter "gain" is ommited; the default value 128 is used by the library
HX711 load;    // parameter "gain" is ommited; the default value 128 is used by the library

State::state activeState = State::STARTUP;


//SoftwareSerial smoothieSerial(10, 11); // RX, TX

int temp = 205;
int speed = 84;
int distance = 100;

// extrude speeds are based on 10cm^3/min for 1.75 and 3mm filament
//int extrudeSpeed = 249.45; // extrude speed in mm/min for 1.75mm
int extrudeSpeed = 84.88; // extrude speed in mm/min for 3mm
int extrudeDistance = 100; // distance to extrude in mm
int count = -2; // initialize counter with negative to prevent output
int loopCount = 1000; // 1000 readings for each extrusion seems to be more than enough for the extrude to complete before reading count is finished

// calculate the actual speed of movement based on a 3 dimentional movement of x, y, and z
// pythagorean theorem
//int extrudeFSpeed = sqrt( pow(extrudeSpeed,2) + pow(extrudeSpeed,2) + pow(extrudeSpeed,2) );
int extrudeFSpeed = extrudeSpeed;


void startTest()
{
  //Heat up the hot ends

  //Tare the scale
  load.tare();



}

void setup() {
  commandBuffer.reserve(BUFFLENGTH);
  Serial.begin(115200);
  Serial.flush();
  Serial.println("********** METAFORM TEST STAND: INIT **********");

  load.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  load.read(); //take a scale reading

  load.tare();

  load.read();

/*
  // Initialize Scale 1
  Serial.println("Scale 1 Initializing:");
  Serial.print("read: \t\t");
  Serial.println(load.read());      // print a raw reading from the ADC
  Serial.print("read average: \t\t");
  Serial.println(load.read_average(20));   // print the average of 20 readings from the ADC
  Serial.print("get value: \t\t");
  Serial.println(load.get_value(5));   // print the average of 5 readings from the ADC minus the tare weight (not set yet)
  Serial.print("get units: \t\t");
  Serial.println(load.get_units(5), 1);  // print the average of 5 readings from the ADC minus tare weight (not set) divided
  //load.set_scale(113);                      // this value is obtained by calibrating the scale with known weights; see the README for details
  load.tare();               // reset the scale to 0
  Serial.println("Scale 1 Initializing Complete:");
  Serial.print("read: \t\t");
  Serial.println(load.read());                 // print a raw reading from the ADC
  Serial.print("read average: \t\t");
  Serial.println(load.read_average(20));       // print the average of 20 readings from the ADC
  Serial.print("get value: \t\t");
  Serial.println(load.get_value(5));   // print the average of 5 readings from the ADC minus the tare weight, set with tare()
  Serial.print("get units: \t\t");
  Serial.println(load.get_units(5), 1);        // print the average of 5 readings from the ADC minus tare weight, divided
  Serial.println();
*/
  // Initialize serial connection to smootheiboard
  //Serial.println("Initialize connection to Smoothieboard");
  //pinMode(10, INPUT);
  //pinMode(11, OUTPUT);
  //smoothieSerial.begin(115200);
  //delay(1000);
  //smoothieSerial.println("G91");

  Serial.println("********** METAFORM TEST STAND: INIT COMPLETE **********");

}

void loop()
{
  commandBuffer = "";

  if (Serial.available()) {
    delay(10);
    int buffCntr = 0;
    boolean isListen = true;
    while (Serial.available() && buffCntr < BUFFLENGTH && isListen) {
      char input = Serial.read();
      if (input == ';') {
        isListen = false;
      }
      else {
        commandBuffer.concat( input);
        buffCntr++;
      }
    }
  }

  Serial.println(load.get_value_fast());
  // Check for smoothie serial incoming and dump the buffer
  // (we dont care what the smoothie has to say to us)
  /*
    if (smoothieSerial.available()>0) {
    smoothieSerial.read();
    }
  */

  //Extrude
  /*
    smoothieSerial.println("G91");
    delay(500);
    smoothieSerial.print("G0 X");
    smoothieSerial.print(extrudeDistance);
    smoothieSerial.print(" F");
    smoothieSerial.print(extrudeFSpeed);
    smoothieSerial.println();
    // Padding
    Serial.println();
    // Set counter to 0 so we start outputting readings
    count = 0;
  */
  /*
    if (count > -1) {
    while (count < loopCount) {
      // Scale 1 reading
      float extruder1 = load.get_units(2);
      extruder1 = -extruder1;
      if ( extruder1 < 0 ) {
      extruder1 = 0.00;
      }

      Serial.print(extruder1);
      // Increment the output counter
      ++count;
    }
    Serial.println("Done");
    // Kill output till next extrude press
    count = -2;
    }
  */

  if (commandBuffer.startsWith("AR_")) {       //FIELD 1
    //Serial.print("Sending to AR");
    command(commandBuffer.substring(3));
  }

}

void command(String command)
{
  if (command.equals("TARE")) {
    Serial.println("Taring load cell");
    load.tare();
  }
}
