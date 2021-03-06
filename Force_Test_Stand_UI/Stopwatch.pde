
public class Stopwatch
{
  boolean isRunning = false;
  
  int startTime = 0;
  int endTime = 0;
  
  int duration = 1000;

  Stopwatch() {
  }

  public void start()
  {
    startTime = millis();
    isRunning = true;
  }
  
  public void stop()
  {
    if(isRunning){
      endTime = millis();
      isRunning = false;
    }
  }
  
  public int getDuration()
  {
    return (endTime - startTime);
  }
}
