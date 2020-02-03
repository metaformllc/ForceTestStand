
public class Test
{
  
  PApplet parent;
  
  private String name; 
  private int feedrate;
  private int distance;

  boolean isRunning = false;

  private PrinterBoard board;
  private Arduino arduino;

  DataProcessor data;

  //private String OUTPUT_FOLDER = "";

  Test(PApplet p) {
    this.parent = p;
    
    data = new DataProcessor("test_output");
    isRunning = false;
  }
  
  public void setComs(String b, String a)
  {
    this.board = new PrinterBoard(parent, b);
    this.arduino = new Arduino(parent, a);
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
    println("Starting Test");

    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    data.init("F"+feedrate+"D"+distance+"_"+timestamp);
    
    arduino.enable();
    
    board.send("G91");
    board.send("G1 Y" + distance + " F" + feedrate);
    isRunning = true;
  }

  public void update()
  {
    
    board.update();
    arduino.update();
    
    while (isRunning && arduino.isDataAvailable())
    {
      data.addSample(arduino.getData() );
    }

    if ( isRunning && !board.isBusy() )  //If the test is running but the printer isn't busy... the test must be done.
    {
      println("Test complete."); 
      isRunning = false;
      data.close();
      arduino.disable();
    }
  }

  public boolean isRunning()
  {
    return isRunning;
  }
}
