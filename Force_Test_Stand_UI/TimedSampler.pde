
public class TimedSampler
{
  private final MeanVarianceSampler sampler = new MeanVarianceSampler();

  boolean isRunning = false;

  int startTime = 0;
  int duration = 1000;

  TimedSampler(int d) {
    this.duration = d;
  }

  public void start()
  {
    isRunning = true;
    startTime = millis();
    sampler.reset();
  }

  public boolean isRunning()
  {
    return isRunning;
  }

  public double getAverage() 
  {
    return sampler.getMean();
  }

  public void update(long sample)
  {
    int currentTime = millis();

    if (currentTime > (startTime + duration) ) {
      isRunning =  false;
      return;
    }
    sampler.add(sample);
  }
}
