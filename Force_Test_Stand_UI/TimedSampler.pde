
public class TimedSampler
{
  private final MeanVarianceSampler sampler = new MeanVarianceSampler();

  boolean isRunning = false;

  int startTime = 0;

  TimedSampler() {
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

    if (currentTime > (startTime + config.ZERO_DURATION_MS) ) {
      isRunning =  false;
      return;
    }
    sampler.add(sample);
  }
}
