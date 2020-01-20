
public class Arduino
{
  PrintWriter output;
  
  int totalReadings = 0;
  
  PApplet parent;
  Serial com;

  final int windowSize = 50;
  final MeanVarianceSlidingWindow statWin = new MeanVarianceSlidingWindow(windowSize);

  double mean, var, stdDev;

  Arduino(Serial s) {
    com = s;
  }
  
  Arduino(PApplet p){
    this.parent = p;
  }
  
  public boolean open(String port)
  {
    try{
      com = new Serial(this.parent, port, 115200);
      output = createWriter("scale_recording.csv");
      output.println("window_size: " + windowSize);
      output.println("rawReading,average,variance,std_dev");
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
        
        if(totalReadings++ < windowSize)
        {
          println(totalReadings);
          return;
        }
        try{
          Long newReading = Long.parseLong(val);
          statWin.update(newReading);
          
          output.println(newReading +"," + getMean() + "," + getVariance() + "," + getStdDev() );
          
          println(newReading);
        }catch(Exception e){
          
        }
        
      }
    }
  }

  public double getMean()
  {
    return statWin.getMean();
  }
  
  public double getVariance()
  {
    return statWin.getVariance();
  }
  
  public double getStdDev()
  {
    return statWin.getStdDev();
  }
  
  public void close()
  {
    output.flush(); // Writes the remaining data to the file
    output.close();
    com.stop();
    
  }
}
