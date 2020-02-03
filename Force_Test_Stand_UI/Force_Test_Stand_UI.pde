// Need G4P library
import g4p_controls.*;

import processing.serial.*;


int ARDUINO_COM_PORT = -1;
String ARDUINO_COM_PORT_NAME = "";

int PRINTER_COM_PORT = -1;
String PRINTER_COM_PORT_NAME = "";

boolean isEnabled = false;

Arduino arduino = new Arduino(this);
PrinterBoard smoothie = new PrinterBoard(this);

Test sampleTest = new Test(this);

boolean unitTestEnable = false;
//PrintWriter output;

public void setup() {
  size(1200, 720, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here

  drop_arduino_serial.setItems(Serial.list(), 0);
  ARDUINO_COM_PORT = drop_arduino_serial.getSelectedIndex();

  drop_printer_serial.setItems(Serial.list(), 0);
  PRINTER_COM_PORT = drop_printer_serial.getSelectedIndex();

  arduino.init();
}

public void unitTest()
{

}

public void draw()
{

  arduino.update();
  smoothie.update();
  
  if (sampleTest.isRunning()) {
    sampleTest.update();
  }

  if (isEnabled) {
    updateGUI();
  }


  /*
  if ( arduino != null && arduino.available() > 0) {  // If data is available,
   val = arduino.read();         // read it and store it in val
   }
   */

  //println(val);



  background(230);
}

public void updateGUI()
{
  //txt_average.setText(String.valueOf(arduino.getMean()));
  //txt_std_dev.setText(String.valueOf(arduino.getStdStd()));
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
