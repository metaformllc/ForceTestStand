
public class DataProcessor
{
  private final int windowSize = 50;
  private final int stdDevWindowSize = 10;
  private final double std_dev_multiplier = 1.75;

  private String recordingPath = "testout";

  private final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);

  private PrintWriter output;

  DataProcessor() {
  }

  DataProcessor(String folder)
  {
    this.recordingPath = folder;
  }


  public void init()
  {
    win.reset();
    winALL.reset();
    winSTD.reset();

    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    //output = createWriter(recordingPath + "/fts"+ timestamp + ".csv");
    output = createWriter(recordingPath + "/fts"+ timestamp + ".csv");
    output.println("raw,rawFiltered,average,std,stdstd");
  }

  public void init(String filename)
  {
    close();

    win.reset();
    winALL.reset();
    winSTD.reset();

    output = createWriter(recordingPath +"/trial_"+ filename + ".csv");
    output.println("raw,rawFiltered,average,std,stdstd");
  }


  public void addSample(long sample)
  {
    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);
    //print( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());
    //win.update(sample);

    double stdStd = winSTD.getStdDev();
    //double stdStd = winALL.getStdDev();
    boolean wasSampleAdded = false;
    if ( win.getCount() < win.getWindowSize() ) {
      wasSampleAdded = true;
      win.update(sample);
    } else if ( (sample <= up_tol && sample >= bot_tol) || (stdStd > 100) ) {
      wasSampleAdded = true;
      win.update(sample);
    }

    String previousStr = "";
    if (wasSampleAdded)
    {
      previousStr = String.valueOf(sample);
    }

    output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev());
  }

  public double getStdStd()
  {
    return winSTD.getStdDev();
  }

  public void close()
  {
    if (output != null) {
      output.flush(); // Writes the remaining data to the file
      output.close();
    }
  }
}
