
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

  private PrintWriter output;

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

  public void generateTests(int feedrate, int durationSec, int numTrials, String n)
  {

    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    this.name = n + "_" + timestamp;

    println("generating tests");
    testSet.clear();

    for (int i = 0; i < numTrials; i++) {
      testSet.add(new Test(feedrate, durationSec, board, arduino, name) );
      println("Test " + i + " F:"  + feedrate + " T:" + durationSec);
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
        summarizeTrials();
        println("Test Runner complete."); 
        isRunning = false;
      }
      //activeTest = testSet.remove();
    }
  }

  public void summarizeTrials()
  {
    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    
    output = createWriter(config.ROOT_DIR + name + "/trial_summary_"+ timestamp + ".csv");
    
    output.println( "ZERO_OFFSET: " + config.ZERO_OFFSET );
    output.println( "SCALE_FACTOR: " + config.SCALE_FACTOR );
    output.println( "" );
    output.println( UtilityMethods.createLine("Run #", "Temp(c)" ,"Feedrate (mm/s)", "Duration (sec)", "Steady State?", "Steady State", "Time to reach (sec)") );
    
    for (int i = 0; i< testSet.size(); i++) {      
      output.println( UtilityMethods.createLine(i, 0, testSet.get(i).getFeedrate(), testSet.get(i).getTime(), (testSet.get(i).isSteadyState()?1:0), testSet.get(i).getSteadyState(), testSet.get(i).getDuration()) );
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
  
  public void close()
  {
    if (output != null) {
      output.flush(); // Writes the remaining data to the file
      output.close();
    }
  }
}
