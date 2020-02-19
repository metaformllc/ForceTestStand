
public class TestRunner
{
  private String name = "";

  private PrinterBoard board;
  private Arduino arduino;

  //private Queue<Test> testSet = new LinkedList<Test>();
  private ArrayList<Test> testSet = new ArrayList<Test>();
  private Test activeTest;

  private boolean isRunning = false;

  private int testNumber = -1;

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
      testSet.add(new Test(feedrate, durationSec, board, arduino, name) );
      println("Test " + i + " F:"  + feedrate + " T:" + durationSec);  

      feedrate += stepChange;
    }
    testNumber = -1;

    println("generating tests. complete.");
  }

  public Test getCurrentTest()
  {
    return testSet.get(testNumber);
  }

  public boolean isRunning()
  {
    return isRunning;
  }

  public void startTests()
  {
    nextTest();
    isRunning = true;
  }

  public boolean nextTest()
  {
    testNumber++;
    if (testNumber < testSet.size() ) {
      activeTest = testSet.get(testNumber);
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
    } else {
      println("TestRunner: ready next test");
      if (!nextTest()) {
        println("Test Runner complete."); 
        isRunning = false;
      }
      //activeTest = testSet.remove();
    }
  }

  public String printTests()
  {
    String text = "";
    for (int i = 0; i< testSet.size(); i++) {
      text += testSet.get(i).print() + "\n";
    }
    return text;
  }
}
