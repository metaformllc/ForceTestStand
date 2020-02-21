
public class Configuration
{
  // ********** CONSTANTS ********** //
  
  // ***** PORTS ***** //
  public final String SMOOTHIE_PORT = "COM1";
  public final String ARDUINO_PORT =  "COM2";
  
  
  // ***** SCALE ***** //
  public int ZERO_DURATION_MS = 1000;         //ms. How long to average the scale when Taring. 
  
  public double SCALE_FACTOR = 1.0;       // The result of calibrating. The raw data will be scaled to real units with this value. 
  public final double CALIBRATION_WEIGHT = 500.0; //grams. Weight of the calibration weight.
  
  
    
  public double ZERO_OFFSET = 0;
  
  Configuration() {
  }
}
