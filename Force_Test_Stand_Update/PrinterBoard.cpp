#include "PrinterBoard.h"

PrinterBoard::PrinterBoard(int rx, int tx)
{
  m_rx = rx;
  m_tx = tx;
}

void PrinterBoard::init()
{
  m_serial = new SoftwareSerial(m_rx, m_tx);
  
  m_serial->begin(BAUD_RATE);
  delay(1000);
  //m_serial->println("G91");
  //delay(1000);
  //  smoothie.send("G0X10Y10Z10F1000;");

}

void PrinterBoard::send(String cmd)
{
  m_serial->println(cmd);
}

void PrinterBoard::update()
{
  if (m_serial->available() > 0) {
    m_serial->read();
  }
}

void PrinterBoard::command(const String & command)
{
  //Serial.println("PrinterBoard: Command:" + command);

  if (command.startsWith("PT_")) {
    Serial.print("Sending to passthrough to SB");
    m_serial->print("G0 Y100 F100");
    m_serial->println();
    //m_serial->println(command.substring(3));
  } else if (command.startsWith("BA_")) {

  } else if (command.startsWith("GO")) {
    Serial.print("Sending to passthrough to SB");
    m_serial->print("G0 Y100 F100");
  }
}
