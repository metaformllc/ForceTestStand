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

#define LOADCELL_DOUT_PIN A2
#define LOADCELL_SCK_PIN A3

HX711 load;    // parameter "gain" is ommited; the default value 128 is used by the library

State::state activeState = State::STARTUP;


void setup() {
  Serial.begin(1000000);
  Serial.flush();
  Serial.println("********** METAFORM TEST STAND: INIT **********");
  pinMode(10, INPUT);
  pinMode(11, OUTPUT);

  load.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  load.read(); //take a scale reading

  Serial.println("********** METAFORM TEST STAND: INIT COMPLETE **********");
}

void loop()
{ 
  if (Serial.available()) {
    //delay(10);   
    while (Serial.available()) {
      char input = Serial.read();      
    }
  }
  Serial.println(load.get_value_fast());
 
}
