import java.util.Queue;
import java.util.LinkedList;

public class Arduino
{
  //private DataProcessor data;

  private Queue<Long> receivedData = new LinkedList<Long>();
  private long lastReading = 0;

  int totalReadings = 0;
  
  

  boolean isEnabled = false;

  PApplet parent;
  Serial com;
  String port;

  Arduino(PApplet p) {
    this.parent = p;
    //data = new DataProcessor();
  }

  Arduino(PApplet p, String port) {
    this.parent = p;
    this.port = port;
    open(port);
    //data = new DataProcessor();
  }

  Arduino(Serial s) {
    com = s;
    //data = new DataProcessor();
  }

  public void init()
  {
    //data.init();
  }

  public boolean open(String port)
  {
    try {
      println("Opening Arduinno port: " + port);
      com = new Serial(this.parent, port, 115200);
      return true;
    }
    catch(Exception e) {
      return false;
    }
  }

  public void update()
  {
    if ( com != null && com.available() > 0) 
    {  // If data is available,
      String val = trim(com.readStringUntil('\n'));         // read it and store it in val
      if (val != null) {
        try {
          Long newReading = Long.parseLong(val);
          this.lastReading = newReading;
          if(isEnabled){
            receivedData.add(newReading);  
          }
          //TODO update UI.
          //data.addSample(newReading);
        }
        catch(Exception e) {
        }
      }
    }
  }

  public boolean isDataAvailable()
  {
    return !receivedData.isEmpty();
  }

  public Long getData()
  {
    return receivedData.remove();
  }
  
  public long getLastReading()
  {
    return this.lastReading;    
  }

  public void clearData()
  {
    if (!receivedData.isEmpty()) {

      receivedData.clear();
    }
  }

  public void enable()
  {
    this.isEnabled = true;
  }

  public void disable()
  {
    this.isEnabled = false;
    clearData();
  }

  public boolean isEnabled()
  {
    return this.isEnabled;
  }

  /*
  public double getStdStd()
   {
   return data.getStdStd(); 
   }
   */

  public void close()
  {
    //data.close();
    com.stop();
  }
}
