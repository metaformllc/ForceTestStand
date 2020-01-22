import java.io.*; 
import java.util.*;

public class DataDump
{

  public double raw;
  public String rawFiltered;
  public double average;
  public double std;
  public double stdAvg;
  public double stdStd;

  DataDump() {
  }

  DataDump(double r, double a, double s, double sa, double ss, String rf)
  {
    this.raw = r;
    this.rawFiltered = rf;
    this.average = a;
    this.std = s;
    this.stdAvg = sa;
    this.stdStd = ss;
  }

  void set(double r, double a, double s, double sa, double ss, String rf)
  {
    this.raw = r;
    this.rawFiltered = rf;
    this.average = a;
    this.std = s;
    this.stdAvg = sa;
    this.stdStd = ss;
  }
  
  public String printHeader() {
    return "raw,average,std,stdAvg,stdstd,rawFiltered";
  }

  public String print() {
    return raw + "," + average +  "," + std + "," + stdAvg + "," + stdStd + "," + rawFiltered;
  }
}
