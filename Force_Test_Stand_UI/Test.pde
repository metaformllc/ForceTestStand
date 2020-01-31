
public class Test
{
  private String name; 
  private int feedrate;
  private int distance;

  private PrinterBoard board;
  private Arduino arduino;

  DataProcessor data;

  //private String OUTPUT_FOLDER = "";

  Test() {
    data = new DataProcessor();
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
    board.send("G91");
    board.send("G1 Y" + distance + " F" + feedrate);
  }
  
  
}
