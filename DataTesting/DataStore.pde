import java.io.*; 
import java.util.*;

public class DataStore
{
  //Peg[] pegs = new Peg[PegGrid.GRID_W*PegGrid.GRID_H];
  
  long raw;
  double average;
  double variance;
  double stdDev;
  
  DataStore() {}
  
  DataStore(long r, double a, double v, double s)
  {
    this.raw = r;
    this.average = a;
    this.variance = v;
    this.stdDev = s;
  }

  void set(long r, double a, double v, double s)
  {
    this.raw = r;
    this.average = a;
    this.variance = v;
    this.stdDev = s;
  }
  
  public long getRaw(){ return this.raw; }
  
  public double getAverage(){ return this.average; }
  
  public double getVariance(){ return this.variance; }
  
  public double getStdDev(){ return this.stdDev; }
  
  public String print(){
    
   return "raw: " + getRaw() + "\t avg: " + (int) getAverage() + "\t stdDev: " + (int) getStdDev(); 
  }
  

  
}
