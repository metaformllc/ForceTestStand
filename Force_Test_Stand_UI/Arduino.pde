import java.util.Queue;
import java.util.LinkedList;

public class Arduino
{
  //private DataProcessor data;
  
  private Queue<Long> receivedData = new LinkedList<Long>();
  
  int totalReadings = 0;
  
  PApplet parent;
  Serial com;

  Arduino(PApplet p){
    this.parent = p;
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
    try{
      com = new Serial(this.parent, port, 115200);

      return true;
    }catch(Exception e){
      return false; 
    }
  }

  public void update()
  {
    if ( com != null && com.available() > 0) 
    {  // If data is available,
      String val = trim(com.readStringUntil('\n'));         // read it and store it in val
      if (val != null) {
        try{
          Long newReading = Long.parseLong(val);
          receivedData.add(newReading);
          //data.addSample(newReading);
        }catch(Exception e){
          
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
  
  public void clearData()
  {
      receivedData.clear();
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
