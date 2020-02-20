// Need G4P library
import g4p_controls.*;

import processing.serial.*;

Configuration config = new Configuration();

int ARDUINO_COM_PORT = -1;
String ARDUINO_COM_PORT_NAME = "";

int PRINTER_COM_PORT = -1;
String PRINTER_COM_PORT_NAME = "";

boolean isEnabled = false;

Arduino arduino = new Arduino(this);
PrinterBoard smoothie = new PrinterBoard(this);


TestRunner runner = new TestRunner();


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
}

public void unitTest()
{
}

public void draw()
{

  arduino.update();
  smoothie.update();
  
  runner.update();
  
  /*
  TODO
  if(isZeroing){
    while (isRunning && arduino.isDataAvailable())
    {
      data.addSample(arduino.getData() );
    } 
  }
  */
  

  updateGUI();
  background(230);
}

public void updateGUI()
{
  txtbox_series_results.setText(runner.printTests());
  if (runner.isRunning()) {
    //txt_average.setText(String.valueOf(runner.getCurrentTest().getData().getMean()));
    txt_std_dev.setText(String.valueOf(runner.getCurrentTest().getData().getStdStd()));
  }
  lbl_scaleFactorValue.setText(String.valueOf(config.SCALE_FACTOR));
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
