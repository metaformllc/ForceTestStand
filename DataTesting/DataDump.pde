import java.io.*; 
import java.util.*;

public class DataDump
{

  public double raw;
  public double average;
  public double std;
  public double stdAvg;

  DataDump() {
  }

  DataDump(double r, double a, double s, double sa)
  {
    this.raw = r;
    this.average = a;
    this.std = s;
    this.stdAvg = sa;
  }

  void set(double r, double a, double s, double sa)
  {
    this.raw = r;
    this.average = a;
    this.std = s;
    this.stdAvg = sa;
  }
  
  public String printHeader() {
    return "raw,average,std,stdAvg";
  }

  public String print() {
    return raw + "," + average +  "," + std + "," + stdAvg;
  }
}
