
public class DataProcessorSolo
{
  private final int windowSize = 50;
  private final int stdDevWindowSize = 10;
  private final double std_dev_multiplier = 3.0;
  private final int STD_STD_DEVIATION_TOLERANCE = 400;
  private  double STEADY_TOLERANCE = 300;

  private  double STABLE_THRESHOLD = 50; //The number of readings to be considered in a steady state.

  private final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  private final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);

  private final MeanVarianceSlidingWindow winFilteredSTD = new MeanVarianceSlidingWindow(stdDevWindowSize);
  private final MeanVarianceSampler readingSampler = new MeanVarianceSampler();

  private boolean isSteadyState = false;
  
  private Stack<String> readings = new Stack<String>();

  DataProcessorSolo() {
  }

  public void init()
  {
    win.reset();
    winALL.reset();
    winSTD.reset();
    winFilteredSTD.reset();
    readingSampler.reset();
    isSteadyState = false;
    
  }

  double prevReading  = 0;

  public boolean addSample(long sample)
  {
    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());

    double stdStd = winSTD.getStdDev();
    if ((win.getCount() < win.getWindowSize() ) ||
      (((sample >= bot_tol) && (sample <= up_tol)) || (stdStd > STD_STD_DEVIATION_TOLERANCE)) ) {
        
      win.update(sample);
      winFilteredSTD.update(win.getStdDev());
      
      prevReading = sample;
    }

    int stbck = stableCheck(winFilteredSTD.getStdDev(), prevReading);
    if (stbck == STABLE_THRESHOLD) {
      //TODO  Update with scaled number.
      println("STEADY STATE REACHED. AVERAGE: " + getSteadyAverage());
      isSteadyState = true;
    }

    if (isSteadyState) {
      return true;
    } else {
      return false;
      //TODO output.println(rawSample zeroedRawSample scaledForce scaledForceAverage) 
      //readings.push(sample +","+ win.getMean());
      //output.println(sample+","+previousStr+","+win.getMean()+","+win.getStdDev()+","+winSTD.getStdDev()+","+stbck);
      
    }
    
  }

  public boolean isSteadyState() {
    return isSteadyState;
  }

  public double getSteadyAverage() {
    return readingSampler.getMean();
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
}
