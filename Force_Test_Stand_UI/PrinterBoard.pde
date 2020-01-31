
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Stack;

public class PrinterBoard
{
  PrintWriter output;

  Stack<Boolean> commandAwk = new Stack<Boolean>();

  int totalReadings = 0;

  int feedrate = 100;
  int distance = 10;


  PApplet parent;
  Serial com;

  PrinterBoard(Serial s) {
    com = s;
  }

  PrinterBoard(PApplet p) {
    this.parent = p;

    println("list size: " + commandAwk.size());
    commandAwk.push(false);
    println("list size: " + commandAwk.size());
    commandAwk.pop();
    println("list size: " + commandAwk.size());
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

  public void feed(int fr, int d)
  {
    feedrate = fr;
    distance = d;

    send("G1 Y" + distance + " F" + feedrate);
  }

  public void send(String command)
  {
    if ( com == null) { 
      return;
    }
    txtbox_com_display.appendText(command);
    com.write(command + "\r");
    commandAwk.push(true);
    com.write("M400" + "\r");
    commandAwk.push(true);
  }


  public void update()
  {

    if ( com != null && com.available() > 0) 
    {  // If data is available,
      //println("data available");
      String val = trim(com.readString());         // read it and store it in val
      //println(val);
      if (val != null) {
        txtbox_com_display.appendText(val);
        if (val.contains("ok"))
        {
          if (!commandAwk.isEmpty())
          {
            commandAwk.pop();
          }else{
            println("Command queue empty, but still trying to remove..");
          }
          //println("OK received");
        }
      }
    }
  }

  public boolean isBusy()
  {
    return commandAwk.isEmpty();
  }

  public void close()
  {
    output.flush(); // Writes the remaining data to the file
    output.close();
    com.stop();
  }
}
