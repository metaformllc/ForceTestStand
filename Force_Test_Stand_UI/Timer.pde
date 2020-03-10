public class Timer
{
  boolean isEnabled = false;

  int ticks;

  int interval;
  int timer;

  Timer(int interval, int unit) {
    setTimer(interval, unit);
    reset();
  }
  
  void setTimer(int interval, int unit)
  {
    switch(unit)
    {
    case UnitTime.MILLISECOND:
      this.interval = interval;
      break;
    case UnitTime.SECOND:
      this.interval = interval*1000;
      break;
    case UnitTime.MINUTE:
      this.interval = interval*1000*60;
      break;
    case UnitTime.HOUR:
      this.interval = interval*1000*60*60;
      break;
    }
  }

  int getTicks()
  {
    return ticks;
  }

  boolean isEnabled()
  {
    return isEnabled;
  }

  void start()
  {
    isEnabled = true;
    timer = millis() + interval;
  }

  void stop()
  {
    isEnabled = false;
  }

  void reset()
  {
    ticks = 0;
    timer = 0;
  }


  boolean update() {
    if (millis() > timer) {
      timer = millis() + interval;
      if (isEnabled) {
        ticks++;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

public static class UnitTime
{
  public final static int MILLISECOND = 0;
  public final static int SECOND = 1;
  public final static int MINUTE = 2;
  public final static int HOUR = 3;

  UnitTime() {
  }
}
