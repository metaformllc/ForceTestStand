
public static class UtilityMethods
{
  
  UtilityMethods() {
  }
  
  public static String getFormattedYMD()
  {
    int y = year();
    int m = month();
    int d = day();

    return y + ((m < 10)?"0"+str(m):str(m)) + ((d < 10)?"0"+str(d):str(d));
  }

  public static String getFormattedTime(boolean delim)
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
  
  public static int durationToDistance(int duration, int feedrate)
  {
    //feedrate = mm/min
    //duration = seconds
    return (int)( (float)duration * ((float)feedrate / 60.0));
  }
  
  private static String createLine(double ...a) 
  { 
    String result = "";
    for (double i : a) {
      result += i + ",";
    }
    return result;
  } 
  
  private static String createLine(String ...s) 
  { 
    String result = ""; 
    for (String i : s) {
      result += i + ",";
    }
    return result;
  }
  
}
