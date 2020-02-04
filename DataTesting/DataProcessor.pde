
public class DataProcessor
{
  private final int windowSize = 50;
  private final int stdDevWindowSize = 10;
  private final double std_dev_multiplier = 3.0;
  private final int STD_STD_DEVIATION_TOLERANCE = 400;
  private  double STEADY_TOLERANCE = 300;

  private  double STABLE_THRESHOLD = 50; //The number of readings to be considered in a steady state.

  private String recordingPath = "processed";

  private final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);
  
  private final MeanVarianceSlidingWindow winFilteredSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);


  private final MeanVarianceSampler readingSampler = new MeanVarianceSampler();

  private PrintWriter output;

  private ArrayList<Double> reading = new ArrayList<Double>();

  private boolean isSteadyState = false;

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
    output = createWriter("recordings/" + recordingPath + "/fts"+ timestamp + ".csv");
    output.println("raw,rawFiltered,average,std,stdstd");
  }

  public void init(String filename)
  {
    close();

    win.reset();
    winALL.reset();
    winSTD.reset();

    output = createWriter("recordings/" + recordingPath +"/trial_"+ filename + ".csv");
    output.println("raw,rawFiltered,average,std,stdstd");
  }

  double prevReading  = 0;
  
  public void addSample(long sample)
  {
    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);
    //println( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());
    //win.update(sample);

    double stdStd = winSTD.getStdDev();
    //double stdStd = winALL.getStdDev();
    boolean wasSampleAdded = false;
    if ( win.getCount() < win.getWindowSize() ) {
      wasSampleAdded = true;
      win.update(sample);
      winFilteredSTD.update(win.getStdDev()); 
    } else if ( ((sample >= bot_tol) && (sample <= up_tol)) || (stdStd > STD_STD_DEVIATION_TOLERANCE) ) {
    //} else if ( (sample <= up_tol && sample >= bot_tol) ) {
      wasSampleAdded = true;
      win.update(sample);
      winFilteredSTD.update(win.getStdDev());
    }
    
    String previousStr = "";
    if (wasSampleAdded)
    {
      prevReading = sample;
      previousStr = String.valueOf(sample);
    }

    int stbck = stableCheck(winFilteredSTD.getStdDev(), prevReading);
    if (stbck == STABLE_THRESHOLD) {
      println("STEADY STATE REACHED. AVERAGE: " + getSteadyAverage());
      isSteadyState = true;
    }
    
    if (isSteadyState) {
      output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev()+","+stbck + ", STEADY");
    } else {
      output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev()+","+stbck);
    }
  }

  public boolean isSteadyState() {
    return isSteadyState;
  }

  public double getSteadyAverage() {
    return readingSampler.getMean();
  }

  double steadyReading = -1;
  public int stableCheck(double stddev, double sample)
  {
    if (steadyReading == -1) {
      steadyReading = stddev;
      readingSampler.add(sample);
    }
    if (Math.abs((steadyReading - stddev)) < STEADY_TOLERANCE) {
      readingSampler.add(sample);
    } else {
      //readingSampler.clear();
      readingSampler.reset();
      steadyReading = stddev;
      readingSampler.add(sample);
    }
    return (int) readingSampler.getCount();
    //If s1 - s2 around 0-TOLERANCE for X number samples
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
