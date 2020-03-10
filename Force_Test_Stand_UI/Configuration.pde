
public class Configuration
{
  // ********** CONSTANTS ********** //

  // ***** PORTS ***** //
  public final String SMOOTHIE_PORT = "COM4";
  public final String ARDUINO_PORT =  "COM5";

  public final String ROOT_DIR = "../../../recordings/";

  // ***** SCALE ***** // 
  public final double NO_WEIGHT_READING = 99774.319;
  public double WEIGHT_READING = 155234.240;
  public final double CALIBRATION_WEIGHT = 500.0; //grams. Weight of the calibration weight.

  public double SCALE_FACTOR = 1.0;       // The result of calibrating. The raw data will be scaled to real units with this value.
  public double ZERO_OFFSET = 0;

  // ***** RETRACTION ***** //
  public final int RETRACT_DISTANCE = 10;              // mm
  public final int UNRETRACT_DISTANCE = 9;             // mm
  public final int RETRACT_FEEDRATE = 1000;            // mm/min

  // ***** TIMEOUTS ***** // 
  public final int PRE_TIMEOUT = 5;                    // The amount of time thatthe recorder will record before starting to rextrude
  public final int PRE_TIMEOUT_UNIT = UnitTime.SECOND;

  public final int STEADY_TIMEOUT = 30;                // The amount of time to wait for steady state before timing out. 
  public final int STEADY_TIMEOUT_UNIT = UnitTime.SECOND;

  Configuration() {
    SCALE_FACTOR = (WEIGHT_READING - NO_WEIGHT_READING) / CALIBRATION_WEIGHT;
  }

  public double getZeroDataPoint(double point)
  {
    return point - config.ZERO_OFFSET;
  }

  public double getScaledDataPoint(double point)
  {
    return (point / config.SCALE_FACTOR);
  }

  public double getZeroScaledDataPoint(double point)
  {
    return (getZeroDataPoint(point) / config.SCALE_FACTOR);
  }
}
