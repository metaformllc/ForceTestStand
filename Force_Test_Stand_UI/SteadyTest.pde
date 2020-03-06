
public class SteadyTest
{

  PApplet parent;

  TestState state;
  private Arduino arduino;

  DataProcessorSolo steadySampler;
  
  private Timer timeout;

  SteadyTest(Arduino a) {    
    this.arduino = a;
    this.steadySampler = new DataProcessorSolo();
    
    this.timeout = new Timer(config.STEADY_TIMEOUT, config.STEADY_TIMEOUT_UNIT);

    this.state = TestState.IDLE;
  }

  public void start()
  {
    println("Starting Test");

    steadySampler.init();

    arduino.clearData();
    arduino.enable();
    
    timeout.start();

    state = TestState.RUNNING;
  }

  public TestState update()
  {
    if (state != TestState.RUNNING) {
      return state;
    }
    
    arduino.update();
    while (arduino.isDataAvailable())
    {
      steadySampler.addSample( arduino.getData() );
    }

    if (steadySampler.isSteadyState())
    {
      arduino.disable();
      arduino.clearData();
      state = TestState.COMPLETE;
    }else if(timeout.update()){
      timeout.stop();
      state = TestState.TIMEOUT;
    }
    
    return state;
  }
  
  public void reset()
  {
    state = TestState.IDLE;
    steadySampler.init();    
  }

  public TestState getState()
  {
    return state;
  }

  public double getSteadyState()
  {
    return steadySampler.getSteadyAverage();
  }
}
