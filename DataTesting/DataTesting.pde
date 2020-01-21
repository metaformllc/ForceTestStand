

Table table;

DataStore[] dataList; //= new Peg[PegGrid.GRID_W*PegGrid.GRID_H];
int dataListSize = 0;

public void setup() {

  final int windowSize = 3;
  final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);

  table = loadTable("scale_recording.csv", "header");

  println(table.getRowCount() + " total rows in table");

  dataListSize = table.getRowCount();
  dataList = new DataStore[dataListSize];

  int x = 0;
  for (TableRow row : table.rows()) {
    long r = row.getInt("rawReading");
    double a = row.getFloat("average");
    double v = row.getFloat("variance");
    double s = row.getFloat("std_dev");
    dataList[x++] = new DataStore(r, a, v, s);

    //String name = row.getString("name");

    //println(name + " (" + species + ") has an ID of " + id);
  }


  int std_dev_multiplier = 2;
  for (int i = 0; i < dataListSize; i++ ) {
    println(i + ": " + dataList[i].print() );
    long sample = dataList[i].getRaw();

    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);

    print( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    if ( i < 10) {
      win.update(sample);
      println();
    } else if (sample <= up_tol && sample >= bot_tol) {  
      win.update(sample);
      println("\t in tolerence.");
    } else {
      if ( sample > up_tol ) {
        println("\t sample is greater than tolerance. Ignoring");
      } else {
         println("\t sample is less then tolerance. Ignoring");
      }
    }



    println();
    delay(200);
  }

  /*

   double mean, var, stdDev;
   
   win.update(1);
   win.update(2);
   win.update(3);
   mean = win.getMean();
   var = win.getVariance();
   stdDev = win.getStdDev();
   
   int i = 1;
   
   println("Sample " + i++);
   println("mean: " + mean);
   println("std dev: " + stdDev);
   println();
   
   //1 drops out now
   win.update(4);
   mean = win.getMean();
   var = win.getVariance();
   stdDev = win.getStdDev();
   
   println("Sample " + i++);
   println("mean: " + mean);
   println("std dev: " + stdDev);
   println();
   
   //2 drops out now
   win.update(5);
   mean = win.getMean();
   var = win.getVariance();
   stdDev = win.getStdDev();
   
   println("Sample " + i++);
   println("mean: " + mean);
   println("std dev: " + stdDev);
   println();
   */
}

public void draw()
{
  background(230);
}
