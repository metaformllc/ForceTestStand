/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void drop_arduino_serial_click(GDropList source, GEvent event) { //_CODE_:drop_arduino_serial:314369:
  //println("drop_serial - GDropList >> GEvent." + event + " @ " + millis());
  
  ARDUINO_COM_PORT = source.getSelectedIndex();
  ARDUINO_COM_PORT_NAME = Serial.list()[ARDUINO_COM_PORT];

} //_CODE_:drop_arduino_serial:314369:

public void bttn_serial_arduino_open_click(GButton source, GEvent event) { //_CODE_:bttn_serial_arduino_open:612085:
  //println("bttn_serial_open - GButton >> GEvent." + event + " @ " + millis());
  ARDUINO_COM_PORT_NAME = Serial.list()[ARDUINO_COM_PORT];
  arduino.open(ARDUINO_COM_PORT_NAME);
  
  runner.setArduino(arduino);

} //_CODE_:bttn_serial_arduino_open:612085:

public void txt_average_changed(GTextField source, GEvent event) { //_CODE_:txt_average:323696:
  //println("txt_average - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_average:323696:

public void txt_std_dev_changed(GTextField source, GEvent event) { //_CODE_:txt_std_dev:970016:
  //println("txt_std_dev - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_std_dev:970016:

public void bttn_flush_clicked(GButton source, GEvent event) { //_CODE_:bttn_flush:640586:
  //println("bttn_flush - GButton >> GEvent." + event + " @ " + millis());
  arduino.close();
  smoothie.close();
  exit();
} //_CODE_:bttn_flush:640586:

public void drop_printer_serial_click(GDropList source, GEvent event) { //_CODE_:drop_printer_serial:680799:
  //println("drop_printer_serial - GDropList >> GEvent." + event + " @ " + millis());
    PRINTER_COM_PORT = source.getSelectedIndex();
    PRINTER_COM_PORT_NAME = Serial.list()[PRINTER_COM_PORT];

} //_CODE_:drop_printer_serial:680799:

public void bttn_serial_printer_open_click(GButton source, GEvent event) { //_CODE_:bttn_serial_printer_open:504974:
  println("bttn_serial_printer_open - GButton >> GEvent." + event + " @ " + millis());
  PRINTER_COM_PORT_NAME = Serial.list()[PRINTER_COM_PORT];
  smoothie.open(PRINTER_COM_PORT_NAME);
  
  runner.setPrinter(smoothie);
} //_CODE_:bttn_serial_printer_open:504974:

public void txtbox_com_display_change(GTextArea source, GEvent event) { //_CODE_:txtbox_com_display:790786:
  //println("txtbox_com_display - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:txtbox_com_display:790786:

public void txt_command_box_change(GTextField source, GEvent event) { //_CODE_:txt_command_box:823636:
  //println("txt_command_box - GTextField >> GEvent." + event + " @ " + millis());
  if(event == GEvent.ENTERED){
     smoothie.send(source.getText());
     source.setText("");
  }
  
} //_CODE_:txt_command_box:823636:

public void cbx_enabled_clicked(GCheckbox source, GEvent event) { //_CODE_:cbx_enabled:791270:
  println("cbx_enabled - GCheckbox >> GEvent." + event + " @ " + millis());

  isEnabled = source.isSelected();
  println("isenabled: " + isEnabled);
  
} //_CODE_:cbx_enabled:791270:

public void txt_rawArduino_change(GTextField source, GEvent event) { //_CODE_:txt_rawArduino:617569:
  //println("txt_feedrate - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_rawArduino:617569:

public void txt_scaledArduino_change(GTextField source, GEvent event) { //_CODE_:txt_scaledArduino:887853:
  //println("txt_distance - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_scaledArduino:887853:

public void bttn_go_click(GButton source, GEvent event) { //_CODE_:bttn_go:727941:
  println("bttn_go - GButton >> GEvent." + event + " @ " + millis());
  
  //int rate = Integer.parseInt(trim(txt_feedrate.getText()));
  //int distance = Integer.parseInt(trim(txt_distance.getText()));
  
  //smoothie.feed(rate, distance); 
} //_CODE_:bttn_go:727941:

public void txt_feedStart_change(GTextField source, GEvent event) { //_CODE_:txt_feedStart:514826:
  //println("txt_feedStart - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_feedStart:514826:

public void txt_feedInc_change(GTextField source, GEvent event) { //_CODE_:txt_feedInc:506686:
  //println("txt_feedInc - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_feedInc:506686:

public void txt_numSteps_change(GTextField source, GEvent event) { //_CODE_:txt_numSteps:568825:
  //println("txt_numSteps - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_numSteps:568825:

public void txt_time_change(GTextField source, GEvent event) { //_CODE_:txt_time:978025:
  //println("txt_time - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_time:978025:

public void bttn_startSeries_click(GButton source, GEvent event) { //_CODE_:bttn_startSeries:659156:
  println("bttn_startSeries - GButton >> GEvent." + event + " @ " + millis());
  
  int feedStart = Integer.parseInt(trim(txt_feedStart.getText()));
  int feedDistance = Integer.parseInt(trim(txt_time.getText()));
  
  int feedInc = Integer.parseInt(trim(txt_feedInc.getText()));
  int numSteps = Integer.parseInt(trim(txt_numSteps.getText()));
  
  String name = trim(txt_seriesName.getText());
  
  runner.generateTests(feedStart, feedInc, numSteps, feedDistance, name);
  
  runner.startTests();
  
  //sampleTest.setComs(PRINTER_COM_PORT_NAME, ARDUINO_COM_PORT_NAME);
  //sampleTest.setComs(smoothie, arduino);
  
  //sampleTest.init(feedStart, feedDistance);
  //sampleTest.startTest();
} //_CODE_:bttn_startSeries:659156:

public void txt_seriesName_change1(GTextField source, GEvent event) { //_CODE_:txt_seriesName:701578:
  println("txt_seriesName - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_seriesName:701578:

public void txtbox_series_results_change(GTextArea source, GEvent event) { //_CODE_:txtbox_series_results:644449:
  //println("txtbox_series_results - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:txtbox_series_results:644449:

public void btn_calibrate_click(GButton source, GEvent event) { //_CODE_:btn_calibrate:477771:
  println("btn_calibrate - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:btn_calibrate:477771:

public void txt_force_change(GTextField source, GEvent event) { //_CODE_:txt_force:551430:
  println("txt_force - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_force:551430:

public void btn_tare_click(GButton source, GEvent event) { //_CODE_:btn_tare:469367:
  println("btn_tare - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:btn_tare:469367:

public void txt_numTrials_change(GTextField source, GEvent event) { //_CODE_:txt_numTrials:692402:
  println("txt_numTrials - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:txt_numTrials:692402:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  drop_arduino_serial = new GDropList(this, 100, 70, 110, 100, 4, 10);
  drop_arduino_serial.setItems(loadStrings("list_314369"), 0);
  drop_arduino_serial.addEventHandler(this, "drop_arduino_serial_click");
  bttn_serial_arduino_open = new GButton(this, 220, 70, 80, 20);
  bttn_serial_arduino_open.setText("Connect");
  bttn_serial_arduino_open.addEventHandler(this, "bttn_serial_arduino_open_click");
  lbl_heading = new GLabel(this, 10, 10, 204, 40);
  lbl_heading.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_heading.setText("Force Test Stand");
  lbl_heading.setOpaque(false);
  txt_average = new GTextField(this, 90, 210, 120, 20, G4P.SCROLLBARS_NONE);
  txt_average.setOpaque(true);
  txt_average.addEventHandler(this, "txt_average_changed");
  lbl_Data = new GLabel(this, 10, 190, 80, 20);
  lbl_Data.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_Data.setText("Statistics");
  lbl_Data.setOpaque(false);
  lbl_avg = new GLabel(this, 10, 210, 80, 20);
  lbl_avg.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_avg.setText("Average");
  lbl_avg.setOpaque(false);
  lbl_std = new GLabel(this, 10, 230, 80, 20);
  lbl_std.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_std.setText("Std Dev");
  lbl_std.setOpaque(false);
  txt_std_dev = new GTextField(this, 91, 230, 120, 20, G4P.SCROLLBARS_NONE);
  txt_std_dev.setOpaque(true);
  txt_std_dev.addEventHandler(this, "txt_std_dev_changed");
  bttn_flush = new GButton(this, 1010, 10, 80, 30);
  bttn_flush.setText("FLUSH/EXIT");
  bttn_flush.addEventHandler(this, "bttn_flush_clicked");
  drop_printer_serial = new GDropList(this, 100, 100, 110, 80, 3, 10);
  drop_printer_serial.setItems(loadStrings("list_680799"), 0);
  drop_printer_serial.addEventHandler(this, "drop_printer_serial_click");
  bttn_serial_printer_open = new GButton(this, 220, 100, 80, 20);
  bttn_serial_printer_open.setText("Connect");
  bttn_serial_printer_open.addEventHandler(this, "bttn_serial_printer_open_click");
  lbl_arduino = new GLabel(this, 10, 70, 80, 20);
  lbl_arduino.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_arduino.setText("Arduino");
  lbl_arduino.setOpaque(false);
  lbl_Printer = new GLabel(this, 10, 100, 80, 20);
  lbl_Printer.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_Printer.setText("Printer");
  lbl_Printer.setOpaque(false);
  txtbox_com_display = new GTextArea(this, 320, 70, 310, 150, G4P.SCROLLBARS_NONE);
  txtbox_com_display.setOpaque(true);
  txtbox_com_display.addEventHandler(this, "txtbox_com_display_change");
  txt_command_box = new GTextField(this, 320, 230, 310, 20, G4P.SCROLLBARS_NONE);
  txt_command_box.setOpaque(true);
  txt_command_box.addEventHandler(this, "txt_command_box_change");
  cbx_enabled = new GCheckbox(this, 780, 250, 120, 20);
  cbx_enabled.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cbx_enabled.setText("Enabled");
  cbx_enabled.setOpaque(false);
  cbx_enabled.addEventHandler(this, "cbx_enabled_clicked");
  txt_rawArduino = new GTextField(this, 740, 70, 100, 20, G4P.SCROLLBARS_NONE);
  txt_rawArduino.setText("200");
  txt_rawArduino.setPromptText("Feedrate");
  txt_rawArduino.setOpaque(true);
  txt_rawArduino.addEventHandler(this, "txt_rawArduino_change");
  lbl_rawArduino = new GLabel(this, 660, 70, 80, 20);
  lbl_rawArduino.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_rawArduino.setText("Raw");
  lbl_rawArduino.setOpaque(false);
  lbl_scaledArduino = new GLabel(this, 660, 110, 80, 20);
  lbl_scaledArduino.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_scaledArduino.setText("Scaled");
  lbl_scaledArduino.setOpaque(false);
  txt_scaledArduino = new GTextField(this, 740, 110, 99, 20, G4P.SCROLLBARS_NONE);
  txt_scaledArduino.setText("20");
  txt_scaledArduino.setPromptText("Distance");
  txt_scaledArduino.setOpaque(true);
  txt_scaledArduino.addEventHandler(this, "txt_scaledArduino_change");
  bttn_go = new GButton(this, 640, 230, 100, 20);
  bttn_go.setText("GO");
  bttn_go.addEventHandler(this, "bttn_go_click");
  lbl_testSeries = new GLabel(this, 10, 280, 80, 20);
  lbl_testSeries.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_testSeries.setText("Test  Series");
  lbl_testSeries.setOpaque(false);
  lbl_numSteps = new GLabel(this, 10, 400, 100, 20);
  lbl_numSteps.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_numSteps.setText("Number of Steps");
  lbl_numSteps.setOpaque(false);
  lbl_time = new GLabel(this, 10, 330, 100, 20);
  lbl_time.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_time.setText("Trial Time (sec)");
  lbl_time.setOpaque(false);
  lbl_feedStart = new GLabel(this, 10, 310, 100, 20);
  lbl_feedStart.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_feedStart.setText("Starting (mm/s)");
  lbl_feedStart.setOpaque(false);
  lbl_feedInc = new GLabel(this, 10, 380, 100, 20);
  lbl_feedInc.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  lbl_feedInc.setText("Increment (mm/s)");
  lbl_feedInc.setOpaque(false);
  txt_feedStart = new GTextField(this, 110, 310, 120, 20, G4P.SCROLLBARS_NONE);
  txt_feedStart.setText("1000");
  txt_feedStart.setOpaque(true);
  txt_feedStart.addEventHandler(this, "txt_feedStart_change");
  txt_feedInc = new GTextField(this, 110, 380, 120, 20, G4P.SCROLLBARS_NONE);
  txt_feedInc.setText("100");
  txt_feedInc.setOpaque(true);
  txt_feedInc.addEventHandler(this, "txt_feedInc_change");
  txt_numSteps = new GTextField(this, 110, 400, 120, 20, G4P.SCROLLBARS_NONE);
  txt_numSteps.setText("1");
  txt_numSteps.setOpaque(true);
  txt_numSteps.addEventHandler(this, "txt_numSteps_change");
  txt_time = new GTextField(this, 110, 330, 120, 20, G4P.SCROLLBARS_NONE);
  txt_time.setText("5");
  txt_time.setOpaque(true);
  txt_time.addEventHandler(this, "txt_time_change");
  bttn_startSeries = new GButton(this, 10, 470, 220, 40);
  bttn_startSeries.setText("Start Series");
  bttn_startSeries.addEventHandler(this, "bttn_startSeries_click");
  txt_seriesName = new GTextField(this, 10, 440, 220, 20, G4P.SCROLLBARS_NONE);
  txt_seriesName.setText("TestSet01");
  txt_seriesName.setPromptText("Series Name");
  txt_seriesName.setOpaque(true);
  txt_seriesName.addEventHandler(this, "txt_seriesName_change1");
  txtbox_series_results = new GTextArea(this, 270, 310, 360, 240, G4P.SCROLLBARS_NONE);
  txtbox_series_results.setOpaque(true);
  txtbox_series_results.addEventHandler(this, "txtbox_series_results_change");
  lbl_scaleFactor = new GLabel(this, 660, 90, 80, 20);
  lbl_scaleFactor.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_scaleFactor.setText("Scale Factor");
  lbl_scaleFactor.setOpaque(false);
  lbl_scaleFactorValue = new GLabel(this, 740, 90, 100, 20);
  lbl_scaleFactorValue.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_scaleFactorValue.setText("-1");
  lbl_scaleFactorValue.setOpaque(false);
  btn_calibrate = new GButton(this, 850, 90, 70, 20);
  btn_calibrate.setText("Calibrate");
  btn_calibrate.addEventHandler(this, "btn_calibrate_click");
  lbl_force = new GLabel(this, 660, 130, 80, 20);
  lbl_force.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_force.setText("Current");
  lbl_force.setOpaque(false);
  txt_force = new GTextField(this, 740, 130, 100, 20, G4P.SCROLLBARS_NONE);
  txt_force.setOpaque(true);
  txt_force.addEventHandler(this, "txt_force_change");
  btn_tare = new GButton(this, 850, 130, 70, 20);
  btn_tare.setText("Tare");
  btn_tare.addEventHandler(this, "btn_tare_click");
  lbl_trials = new GLabel(this, 10, 350, 100, 20);
  lbl_trials.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_trials.setText("# Trials");
  lbl_trials.setOpaque(false);
  txt_numTrials = new GTextField(this, 110, 350, 120, 20, G4P.SCROLLBARS_NONE);
  txt_numTrials.setOpaque(true);
  txt_numTrials.addEventHandler(this, "txt_numTrials_change");
}

// Variable declarations 
// autogenerated do not edit
GDropList drop_arduino_serial; 
GButton bttn_serial_arduino_open; 
GLabel lbl_heading; 
GTextField txt_average; 
GLabel lbl_Data; 
GLabel lbl_avg; 
GLabel lbl_std; 
GTextField txt_std_dev; 
GButton bttn_flush; 
GDropList drop_printer_serial; 
GButton bttn_serial_printer_open; 
GLabel lbl_arduino; 
GLabel lbl_Printer; 
GTextArea txtbox_com_display; 
GTextField txt_command_box; 
GCheckbox cbx_enabled; 
GTextField txt_rawArduino; 
GLabel lbl_rawArduino; 
GLabel lbl_scaledArduino; 
GTextField txt_scaledArduino; 
GButton bttn_go; 
GLabel lbl_testSeries; 
GLabel lbl_numSteps; 
GLabel lbl_time; 
GLabel lbl_feedStart; 
GLabel lbl_feedInc; 
GTextField txt_feedStart; 
GTextField txt_feedInc; 
GTextField txt_numSteps; 
GTextField txt_time; 
GButton bttn_startSeries; 
GTextField txt_seriesName; 
GTextArea txtbox_series_results; 
GLabel lbl_scaleFactor; 
GLabel lbl_scaleFactorValue; 
GButton btn_calibrate; 
GLabel lbl_force; 
GTextField txt_force; 
GButton btn_tare; 
GLabel lbl_trials; 
GTextField txt_numTrials; 
