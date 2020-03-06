import java.util.Random;


enum State { 
  NORMAL, TARE, CALIBRATE;
}

enum TestState { 
  IDLE, RUNNING, COMPLETE, TIMEOUT, PRESTEADY, POSTSTEADY, PRETEST, POSTTEST;
}
enum TestStateDetail { 
  TIMEOUT, PRETEST, POSTTEST;
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
