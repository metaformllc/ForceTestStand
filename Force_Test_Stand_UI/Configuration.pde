
public class Configuration
{
  // ********** CONSTANTS ********** //
  
  // ***** PORTS ***** //
  public final String SMOOTHIE_PORT = "COM4";
  public final String ARDUINO_PORT =  "COM5";
  
  
  // ***** SCALE ***** //
  public int ZERO_DURATION_MS = 1000;         //ms. How long to average the scale when Taring. 
  
  public double NO_WEIGHT_READING = 99774.319;
  public double WEIGHT_READING = 155234.240;
  public double SCALE_FACTOR = 1.0;       // The result of calibrating. The raw data will be scaled to real units with this value. 
  public final double CALIBRATION_WEIGHT = 500.0; //grams. Weight of the calibration weight.
  
  
    
  public double ZERO_OFFSET = 0;
  
  
  Configuration() {
  }
  
  public double getZeroDataPoint(double point)
  {
    return point - config.ZERO_OFFSET;
  }

  public double getZeroScaledDataPoint(double point)
  {
    return (getZeroDataPoint(point) / config.SCALE_FACTOR);
  }
  
 
}
