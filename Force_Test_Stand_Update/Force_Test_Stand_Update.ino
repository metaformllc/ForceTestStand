#include <SoftwareSerial.h>

#include "HX711.h"
#include "Enums.h"
#include "PrinterBoard.h"

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

PrinterBoard smoothie(10,11); //RX, TX

State::state activeState = State::STARTUP;


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
  pinMode(10, INPUT);
  pinMode(11, OUTPUT);
  smoothie.init();

  load.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  load.read(); //take a scale reading
  load.tare();
  load.read();

  Serial.println("********** METAFORM TEST STAND: INIT COMPLETE **********");

}

void loop()
{
  smoothie.update();
  
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

  //smoothie.send("G0X10Y10Z10F1000;");
  //Serial.println(load.get_value_fast());
  // Check for smoothie serial incoming and dump the buffer
  // (we dont care what the smoothie has to say to us)
  
  
  

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


  if (commandBuffer.startsWith("SB_")) {       //FIELD 1
    //Serial.print("Sending to SB");
    smoothie.command(commandBuffer.substring(3));
  }

}

void command(String command)
{
  if (command.equals("TARE")) {
    Serial.println("Taring load cell");
    load.tare();
  }
}
