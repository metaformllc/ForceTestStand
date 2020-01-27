
public class PrinterBoard
{
  PrintWriter output;

  int totalReadings = 0;

  PApplet parent;
  Serial com;

  PrinterBoard(Serial s) {
    com = s;
  }

  PrinterBoard(PApplet p) {
    this.parent = p;
  }

  public boolean open(String port)
  {
    try {
      println("Opening port: " + port);
      com = new Serial(this.parent, port, 115200);
      output = createWriter("printer_recording.csv");
      return true;
    }
    catch(Exception e) {
      return false;
    }
  }

  public void send(String command)
  {
    println("Sending: " + command);
    if ( com == null) { 
      return;
    }
    txtbox_com_display.appendText(command);
    com.write(command);
    println("Sent.");
  }

  public void update()
  {

    if ( com != null && com.available() > 0) 
    {  // If data is available,
      String val = com.readString();         // read it and store it in val
      println(val);
      if (val != null) {
        txtbox_com_display.appendText(val);
      }
    }
  }

  public void close()
  {
    output.flush(); // Writes the remaining data to the file
    output.close();
    com.stop();
  }
}
