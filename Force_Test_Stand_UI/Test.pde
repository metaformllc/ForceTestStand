
public class Test
{

  PApplet parent;

  private String name; 
  private int feedrate;
  private int time;
  private int distance;


  private boolean isRunning = false;
  TestState state;

  private PrinterBoard board;
  private Arduino arduino;

  private Stopwatch stopwatch;
  private Timer preTimer;

  DataProcessor data;

  SteadyTest steadyTest;

  Test(int f, int t, PrinterBoard b, Arduino a, String directory) {
    this.feedrate = f;
    this.time = t;
    this.distance = UtilityMethods.durationToDistance(t, f);

    this.board = b;
    this.arduino = a;

    this.name = "F"+f+"_T"+t;

    data = new DataProcessor(directory);

    steadyTest = new SteadyTest(arduino);
    stopwatch = new Stopwatch();
    preTimer = new Timer(config.PRE_TIMEOUT, config.PRE_TIMEOUT_UNIT);

    state = TestState.IDLE;
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

    isRunning = true;
    state = TestState.PRESTEADY;
    steadyTest.start();
    println("STATE: PRESTEADY");
  }

  public TestState update()
  {
    if (!isRunning) {
      return state;
    }

    board.update();

    switch(state)
    {
    case PRESTEADY:
      if ( steadyTest.update() == TestState.COMPLETE ) {
        println("PRESTEADY: COMPLETE.");
        state = TestState.PRETEST;

        stopwatch.start();
        preTimer.start();
        println("STATE: PRETETST");
      } else if ( steadyTest.update() == TestState.TIMEOUT ) {
        println("PRESTEADY: FAIL.");
        println("STATE: PRETETST");
      }
      break;
    case PRETEST:
      pullData();
      if ( preTimer.update() ) {
        state = TestState.RUNNING;
        preTimer.stop();

        stopwatch.start();
        board.send("G91");
        board.send("G1 Y" + distance + " F" + feedrate);
        data.enableSteadyCheck();
        println("STATE: RUNNING");
      }
      break;
    case RUNNING:
      pullData();
      if ( (data.isSteadyState() && !board.isBusy() ) || !board.isBusy()) {
        state = TestState.POSTTEST;

        stopwatch.stop();
        board.retract();
        steadyTest.start();
        
        println("STATE: POSTTEST");
      }
      break;
    case POSTTEST:
      pullData();
      if ( steadyTest.update() == TestState.COMPLETE || steadyTest.update() == TestState.TIMEOUT ) {
        println("POSTTEST: COMPLETE.");

        state = TestState.COMPLETE;

        isRunning = false;
        data.close();
        println("STATE: COMPLETE");
      }
      break;
    default:
      break;
    }
    return state;
  }

  private void pullData()
  {
    if (arduino.isDataAvailable())
    {
      Queue<Long> tempData = arduino.getData();
      for (Long val : tempData) {
        data.addSample( val );
      }
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
