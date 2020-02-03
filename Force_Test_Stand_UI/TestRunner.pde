
public class TestRunner
{
  private String name = "";

  private PrinterBoard board;
  private Arduino arduino;

  private Queue<Test> testSet = new LinkedList<Test>();
  private Test activeTest;

  private boolean isRunning = false;


  TestRunner() {
  }

  public void setPrinter(PrinterBoard b)
  {
    this.board = b;
  }

  public void setArduino(Arduino a)
  {
    this.arduino = a;
  }

  public void setComs(PrinterBoard b, Arduino a)
  {
    this.board = b;
    this.arduino = a;
  }

  public void generateTests(int startFeed, int stepChange, int numSteps, int durationSec, String n)
  {
    
    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    this.name = n + "_" + timestamp;
    
    println("generating tests");
    testSet.clear();

    int feedrate = startFeed;

    for (int i = 0; i < numSteps; i++) {
      int distance = durationToDistance(durationSec, feedrate);
      testSet.add(new Test(feedrate, distance, board, arduino, name) );
      println("Test " + i + " F:"  + feedrate + " D:" + distance);  

      feedrate += stepChange;
    }
    
    println("generating tests. complete.");
  }

  private int durationToDistance(int duration, int feedrate)
  {
    //feedrate = mm/min
    //duration = seconds
    return (int)( (float)duration * ((float)feedrate / 60.0));
  }
  
  public void startTests()
  {
    nextTest();
    isRunning = true;
    
  }

  public boolean nextTest()
  {
    if (!testSet.isEmpty()) {
      activeTest = testSet.remove();
      println("Active Test: " + activeTest.getName());
      
      activeTest.startTest();
      return true;
    }
    return false;
  }

  public void update()
  {
    if (!isRunning) {
      return;
    } else if (activeTest.isRunning()) {
      activeTest.update();
    } else if ( !testSet.isEmpty() ) { 
      println("TestRunner: ready next test");
      nextTest();
      //activeTest = testSet.remove();
    } else{
       println("Test Runner complete."); 
       isRunning = false;
    }
  }

  public void init(String folder)
  {
  }
}
