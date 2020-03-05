
public class Test
{

  PApplet parent;

  private String name; 
  private int feedrate;
  private int time;
  private int distance;

  boolean isRunning = false;

  private PrinterBoard board;
  private Arduino arduino;

  private Timer timer;

  DataProcessor data;

  //private String OUTPUT_FOLDER = "";

  Test(int f, int t, PrinterBoard b, Arduino a, String directory) {
    this.feedrate = f;
    this.time = t;
    this.distance = UtilityMethods.durationToDistance(t, f);

    this.board = b;
    this.arduino = a;

    this.name = "F"+f+"_T"+t;

    timer = new Timer();

    data = new DataProcessor(directory);
    isRunning = false;
  }

  public void setComs(PrinterBoard b, Arduino a)
  {
    this.board = b;
    this.arduino = a;
  }

  public void startTest()
  {
    println("Starting Test");

    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    data.init("F"+feedrate+"T"+time+"_"+timestamp);

    arduino.clearData();
    arduino.enable();

    timer.start();
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

    if (data.isSteadyState())
    {
      timer.stop();
    }

    if ( isRunning && !board.isBusy() )  //If the test is running but the printer isn't busy... the test must be done.
    {
      println("Test complete."); 
      isRunning = false;
      data.close();
      timer.stop();
      arduino.disable();
    }
  }

  public DataProcessor getData()
  {
    return data;
  }

  public boolean isRunning()
  {
    return isRunning;
  }

  public String getName()
  {
    return this.name;
  }
  
  public double getFeedrate()
  {
    return feedrate;
  }

  public double getTime()
  {
    return time;
  }
  
  public double getDistance()
  {
    return distance;
  }
  
  public boolean isSteadyState()
  {
    return data.isSteadyState();
  }
  
  public double getSteadyState()
  {
    return data.getSteadyAverage();
  }

  public int getDuration()
  {
    return timer.getDuration();
  }

  public String print()
  {
    String text = this.name + "\t";
    if (isRunning) {
      text += " RUNNING ";
    } else {
      text += " COMPLETE/QUEUED ";
    }

    if (data.isSteadyState()) {
      text += "STEADY: " +  data.getSteadyAverage();
    } else {
      text += "UNSTEADY";
    }
    return text;
  }
}
