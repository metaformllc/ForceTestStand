
public class Test
{
  private String name; 
  private int feedrate;
  private int distance;
  
  boolean isRunning = false;

  private PrinterBoard board;
  private Arduino arduino;

  DataProcessor data;

  //private String OUTPUT_FOLDER = "";

  Test() {
    data = new DataProcessor();
    isRunning = false;
  }

  public void setComs(PrinterBoard b, Arduino a)
  {
    this.board = b;
    this.arduino = a;
  }

  public void init(int f, int d)
  {
    this.feedrate = f;
    this.distance = d;
    
    arduino.clearData();
  }

  public void startTest()
  {
    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    data.init("F"+feedrate+"D"+distance+"_"+timestamp);
    
    board.send("G91");
    board.send("G1 Y" + distance + " F" + feedrate);
    isRunning = true;
  }
  
  public void update()
  {
    while(isRunning && arduino.isDataAvailable())
    {
      data.addSample(arduino.getData() );
    }
    
    if( isRunning && !board.isBusy() )  //If the test is running but the printer isn't busy... the test must be done.
    {
     println("The test should be finished"); 
     isRunning = false;
     data.close();
    }
  }
  
  public boolean isRunning()
  {
    return isRunning; 
  }
  
  
}
