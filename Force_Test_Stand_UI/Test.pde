
public class Test
{

  PApplet parent;

  private String name; 
  private int feedrate;
  private int time;
  private int distance;

  boolean isRunning = false;
  boolean isPreTest = true;

  private PrinterBoard board;
  private Arduino arduino;

  private Stopwatch stopwatch;
  private Timer preTimer;

  DataProcessor data;
  DataProcessorSolo steadySampler;

  //private String OUTPUT_FOLDER = "";

  Test(int f, int t, PrinterBoard b, Arduino a, String directory) {
    this.feedrate = f;
    this.time = t;
    this.distance = UtilityMethods.durationToDistance(t, f);

    this.board = b;
    this.arduino = a;

    this.name = "F"+f+"_T"+t;

    stopwatch = new Stopwatch();

    data = new DataProcessor(directory);
    steadySampler = new DataProcessorSolo();
    
    isRunning = false;

    preTimer = new Timer(config.PRE_TIMEOUT, config.PRE_TIMEOUT_UNIT);
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

    preTimer.start();
    isRunning = true;
    isPreTest = true;
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
      stopwatch.stop();
    }

    if ( preTimer.update() && isPreTest && isRunning ) {
      isPreTest = false;
      stopwatch.start();
      board.send("G91");
      board.send("G1 Y" + distance + " F" + feedrate);
      data.enableSteadyCheck();
    }

    if ( isRunning && !board.isBusy() && !isPreTest )  //If the test is running but the printer isn't busy... the test must be done.
    {
      println("Test complete."); 
      isRunning = false;
      data.close();
      stopwatch.stop();
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
    return stopwatch.getDuration();
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
