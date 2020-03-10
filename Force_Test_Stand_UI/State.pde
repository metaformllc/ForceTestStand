import java.util.Random;


enum State { 
  NORMAL, TARE, CALIBRATE;
}

enum TestState { 
  IDLE, RUNNING, COMPLETE, TIMEOUT, PRESTEADY, POSTSTEADY, PRETEST, POSTTEST, UNRETRACT;
}
enum TestStateDetail { 
  TIMEOUT, PRETEST, POSTTEST, RETRACTDELAY;
}
/*
public static class State
 {
 public final static int NORMAL = 0;
 public final static int TARING = 1;
 
 State() {
 }
 
 }
 */
