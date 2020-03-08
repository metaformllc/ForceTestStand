
public class DataProcessor
{
  private final int windowSize = 50;
  private final int stdDevWindowSize = 10;
  private final double std_dev_multiplier = 3.0;
  private final int STD_STD_DEVIATION_TOLERANCE = 400;
  private  double STEADY_TOLERANCE = 500;

  private  double STABLE_THRESHOLD = 50; //The number of readings to be considered in a steady state.

  private String recordingPath = "testout";

  private final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);

  private final MeanVarianceSlidingWindow winFilteredSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);


  private final MeanVarianceSampler readingSampler = new MeanVarianceSampler();

  private PrintWriter output;

  private boolean isSteadyState = false;
  private boolean steadyCheckEnabled = false;

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
    winFilteredSTD.reset();
    readingSampler.reset();
    isSteadyState = false;

    String timestamp = UtilityMethods.getFormattedYMD() + "_" + UtilityMethods.getFormattedTime(false);
    //output = createWriter(recordingPath + "/fts"+ timestamp + ".csv");
    output = createWriter(config.ROOT_DIR + recordingPath + "/fts"+ timestamp + ".csv");
    output.println( UtilityMethods.createLine("sample", "zeroedSample", "scaledSample", "zeroedScaledSample", "zeroedSampleAverage", "zeroedScaledSampleAverage", "sampleStd", "scaledSampleStd", "stbck", "steadyAverage") );
  }

  public void init(String filename)
  {
    close();

    win.reset();
    winALL.reset();
    winSTD.reset();
    winFilteredSTD.reset();
    readingSampler.reset();
    isSteadyState = false;
    steadyCheckEnabled = false;

    output = createWriter(config.ROOT_DIR + recordingPath +"/trial_"+ filename + ".csv");
    output.println( UtilityMethods.createLine("sample", "zeroedSample", "scaledSample", "zeroedScaledSample", "zeroedSampleAverage", "zeroedScaledSampleAverage", "sampleStd", "scaledSampleStd", "stbck", "steadyAverage") );
  }

  double prevReading  = 0;
  int stbck = 0;

  public void addSample(long sample)
  {
    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);
    //println( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());

    double stdStd = winSTD.getStdDev();
    boolean wasSampleAdded = false;
    if ( win.getCount() < win.getWindowSize() ) {
      wasSampleAdded = true;
      win.update(sample);
      winFilteredSTD.update(win.getStdDev());
    } else if ( ((sample >= bot_tol) && (sample <= up_tol)) || (stdStd > STD_STD_DEVIATION_TOLERANCE) ) {
      wasSampleAdded = true;
      win.update(sample);
      winFilteredSTD.update(win.getStdDev());
    }

    if (wasSampleAdded) {
      prevReading = sample;
    }

    if (!isSteadyState && steadyCheckEnabled) {
      stbck = stableCheck(winFilteredSTD.getStdDev(), prevReading);
    }
    if (stbck == STABLE_THRESHOLD) {
      println("STEADY STATE REACHED. AVERAGE: " + getSteadyAverage());
      isSteadyState = true;
      stbck++;
    }

    //sample
    double  zeroedSample = config.getZeroDataPoint( sample );

    double scaledSample = config.getScaledDataPoint(sample);
    double zeroedScaledSample = config.getZeroScaledDataPoint( sample );

    double  zeroedSampleAverage = config.getZeroDataPoint( win.getMean() );
    double  zeroedScaledSampleAverage = config.getZeroScaledDataPoint( win.getMean() );

    double sampleStd = win.getStdDev();
    double scaledSampleStd = config.getScaledDataPoint( win.getStdDev() );

    if (isSteadyState) {
      //sample
      //zeroedSample

      //scaledSample
      //zeroedScaledSample

      //zeroedSampleAverage
      //zeroedScaledSampleAverage

      //sampleStd
      //scaledSamplestd

      //stbck
      //steadyAverage


      output.println( UtilityMethods.createLine(sample, zeroedSample, scaledSample, zeroedScaledSample, zeroedSampleAverage, zeroedScaledSampleAverage, sampleStd, scaledSampleStd, stbck, getSteadyAverage()) );

      //TODO output.println(rawSample zeroedRawSample scaledForce scaledForceAverage) 
      //output.println(sample +","+ zeroedSample +","+ scaledZeroSample +","+ scaledZeroAverage +", STEADY, " + getSteadyAverage());

      //output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev()+","+stbck + ", STEADY");
    } else {
      //output.println(sample +","+ zeroedSample +","+ scaledZeroSample +","+ scaledZeroAverage);
      //output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev()+","+stbck);
      output.println( UtilityMethods.createLine(sample, zeroedSample, scaledSample, zeroedScaledSample, zeroedSampleAverage, zeroedScaledSampleAverage, sampleStd, scaledSampleStd, stbck) );
    }
  }

  public boolean isSteadyState() {
    return isSteadyState;
  }

  public void enableSteadyCheck() {
    steadyCheckEnabled = true;
  }

  public void disableSteadyCheck() {
    steadyCheckEnabled = false; 
    readingSampler.reset();
  }

  public double getSteadyAverage() {
    return config.getZeroScaledDataPoint(readingSampler.getMean());
  }

  double steadyReading = -1;
  private int stableCheck(double stddev, double sample)
  {
    //If s1 - s2 around 0-TOLERANCE for X number samples
    if (steadyReading == -1) {
      steadyReading = stddev;
      readingSampler.add(sample);
    }
    if (Math.abs((steadyReading - stddev)) < STEADY_TOLERANCE) {
      readingSampler.add(sample);
    } else {
      readingSampler.reset();
      steadyReading = stddev;
      readingSampler.add(sample);
    }
    return (int) readingSampler.getCount();
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
