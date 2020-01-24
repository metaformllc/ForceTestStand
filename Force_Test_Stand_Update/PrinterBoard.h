#ifndef PRINTERBOARD_H
#define PRINTERBOARD_H

#include <Arduino.h>
#include <SoftwareSerial.h>

typedef struct {
        uint8_t parentIndex;    //The index in the vector that this instance exists.
        int id;             //The ID of the current timer. //TODO Char?

        int index;
        uint32_t c;

        uint16_t c1;
        uint16_t c2;
        uint16_t c3;

        int ticksRem;        //The number of ticks remaining. //TODO Char?
        int ticksTotal;      //The total number of ticks that will be made. //TODO Char?
        int tickInterval;    //The interval between ticks. //TODO Char?

        //Used for the bullet effect to revert pixel to previous state when finished with it.
        int modifiedIndex; //TODO Char?
        uint32_t unmodifiedColor[3];

        boolean isEnabled;    //Is this timer enabled?
} fl_timer_storage;


class PrinterBoard
{
  public:

    //Light constructor - Yeah, I know it's horribly ugly.
    PrinterBoard(int rx, int tx);

    //Function:  init()
    //Description:  Calls the init method of all light and sensor children.
    void init();
    
    //Function:  update()
    //Description:  Performs check on sensors, updates light strips values. Needs to be called every cycle!
    void update();

    void send(String cmd);

    //Function:  command(String)
    //Description:  Used for issuing commands to the Field Lights object/passes the command to the approrpriate child object.
    void command(const String & command);

  private:
    const int BAUD_RATE = 115200;
    
    int m_rx, m_tx;
    SoftwareSerial *m_serial;
  
    String m_command;
};

#endif
