
public class DataProcessor
{
  private final int windowSize = 50;
  private final double std_dev_multiplier = 1.75;

  private final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(10);

  private long totalSamples = 0;
  private double prevSampleUsed = 0;

  private PrintWriter output;


  DataProcessor() {
  }

  public void init()
  {
    String timestamp = getFormattedYMD() + "_" + getFormattedTime(false);
    output = createWriter("recordings/fts_"+ timestamp + ".csv");
    output.println("raw,average,std,stdAvg,stdstd,rawFiltered");
  }


  public void addSample(long sample)
  {
    totalSamples++;

    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);
    //print( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());
    //win.update(sample);

    double stdStd = winSTD.getStdDev();
    //double stdStd = winALL.getStdDev();
    boolean wasSampleAdded = false;
    if ( totalSamples < 10) {
      wasSampleAdded = true;
      win.update(sample);
      println();
    } else if ( (sample <= up_tol && sample >= bot_tol) || (stdStd > 100) ) {
      wasSampleAdded = true;
      win.update(sample);
      //println("\t in tolerence.");
    } else {
      if ( sample > up_tol ) {
        //println("\t sample is greater than tolerance. Ignoring");
      } else {
        //println("\t sample is less then tolerance. Ignoring");
      }
    }

    String previousStr = "";
    if (wasSampleAdded)
    {
      prevSampleUsed = sample;
      previousStr = String.valueOf(sample);
    } else {
      previousStr = "";
    }

    output.println(sample+","+win.getMean()+","+win.getStdDev()+","+winSTD.getMean()+","+winSTD.getStdDev()+","+previousStr);
  }

  public double getStdStd()
  {
    return winSTD.getStdDev();
  }

  public void close()
  {
    output.flush(); // Writes the remaining data to the file
    output.close();
  }

  private String getFormattedYMD()
  {
    int y = year();
    int m = month();
    int d = day();

    return y + ((m < 10)?"0"+str(m):str(m)) + ((d < 10)?"0"+str(d):str(d));
  }

  private String getFormattedTime(boolean delim)
  {
    int h = hour();
    int m = minute();
    int s = second();

    if (delim) {
      return((h < 10)?"0"+str(h):str(h)) + ":" + ((m < 10)?"0"+str(m):str(m)) + ":" + ((s < 10)?"0"+str(s):str(s));
    } else {
      return((h < 10)?"0"+str(h):str(h)) + ((m < 10)?"0"+str(m):str(m)) + ((s < 10)?"0"+str(s):str(s));
    }
  }
}
