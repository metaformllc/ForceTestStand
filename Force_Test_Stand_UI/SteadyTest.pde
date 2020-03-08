
public class SteadyTest
{

  PApplet parent;

  TestState state;
  private Arduino arduino;

  DataProcessorSolo steadySampler;
  
  private Timer timeout;

  SteadyTest() {    
    this.steadySampler = new DataProcessorSolo();
    
    this.timeout = new Timer(config.STEADY_TIMEOUT, config.STEADY_TIMEOUT_UNIT);

    this.state = TestState.IDLE;
  }
  
  SteadyTest(Arduino a) {    
    this.arduino = a;
    this.steadySampler = new DataProcessorSolo();
    
    this.timeout = new Timer(config.STEADY_TIMEOUT, config.STEADY_TIMEOUT_UNIT);

    this.state = TestState.IDLE;
  }
  
  public void setArduino(Arduino a)
  {
    this.arduino = a;
  }

  public void start()
  {
    println("Starting Steady Test");

    steadySampler.init();
    
    timeout.start();

    state = TestState.RUNNING;
  }

  public TestState update()
  {
    if (state != TestState.RUNNING) {
      return state;
    }
    
    if(arduino.isDataAvailable())
    {
      Queue<Long> tempData = arduino.getData();
      for(Long val: tempData){
        steadySampler.addSample( val );
      }
    }
    
    if (steadySampler.isSteadyState())
    {
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
