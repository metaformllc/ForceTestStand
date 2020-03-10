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

State currentState = State.NORMAL;

DataProcessorSolo soloSampler = new DataProcessorSolo();

SteadyTest steadyTest;

public void setup() {
  size(1200, 720, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here



  if (config.SMOOTHIE_PORT ==  "") {
    drop_printer_serial.setItems(Serial.list(), 0);
    PRINTER_COM_PORT = drop_printer_serial.getSelectedIndex();
  } else {
    drop_printer_serial.setItems(new String[]{config.SMOOTHIE_PORT}, 0);
    PRINTER_COM_PORT = Arrays.asList(Serial.list()).indexOf(config.SMOOTHIE_PORT);
  }

  if (config.ARDUINO_PORT ==  "") {
    drop_arduino_serial.setItems(Serial.list(), 0);
    ARDUINO_COM_PORT = drop_arduino_serial.getSelectedIndex();
  } else {
    drop_arduino_serial.setItems(new String[]{config.ARDUINO_PORT}, 0);
    ARDUINO_COM_PORT = Arrays.asList(Serial.list()).indexOf(config.ARDUINO_PORT);
  }

  config.SCALE_FACTOR = (config.WEIGHT_READING - config.NO_WEIGHT_READING) / config.CALIBRATION_WEIGHT;

  steadyTest = new SteadyTest();
}

public void draw()
{

  arduino.update();
  smoothie.update();

  runner.update();

  if (currentState == State.TARE) {
    if ( steadyTest.update() == TestState.COMPLETE ) {
      currentState = State.NORMAL;
      config.ZERO_OFFSET = steadyTest.getSteadyState();
      println("TARED at: " +  steadyTest.getSteadyState());
    } else if ( steadyTest.update() == TestState.TIMEOUT ) {
      println("TARED: FAIL.");
    }
  } else if (currentState == State.CALIBRATE) {
    if ( steadyTest.update() == TestState.COMPLETE ) {
      currentState = State.NORMAL;
      
      config.WEIGHT_READING = steadyTest.getSteadyState();

      config.SCALE_FACTOR = (config.WEIGHT_READING - config.NO_WEIGHT_READING) / config.CALIBRATION_WEIGHT;

      println("CALIBRATION at: " +  steadyTest.getSteadyState());
    } else if ( steadyTest.update() == TestState.TIMEOUT ) {
      println("CALIBRATION: FAIL.");
    }
  }

  updateGUI();


  arduino.clearData();
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
  txt_rawArduino.setText(String.valueOf(arduino.getLastReading()));

  txt_force.setText(String.valueOf(config.getZeroScaledDataPoint(arduino.getLastReading())));
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
