

Table table;

DataStore[] dataList; //= new Peg[PegGrid.GRID_W*PegGrid.GRID_H];
int dataListSize = 0;
DataDump[] dataDump;

public void setup() {

  table = loadTable("scale_recording.csv", "header");

  println(table.getRowCount() + " total rows in table");

  dataListSize = table.getRowCount();
  dataList = new DataStore[dataListSize];
  dataDump = new DataDump[dataListSize];

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

  final int windowSize = 50;
  final MeanVarianceSlidingWindow win = new MeanVarianceSlidingWindow(windowSize);
  final MeanVarianceSlidingWindow winALL = new MeanVarianceSlidingWindow(windowSize);
  final MeanVarianceSlidingWindow winSTD = new MeanVarianceSlidingWindow(10);

  
  double prevSampleUsed = 0;
  for (int i = 0; i < dataListSize; i++ ) {
    println(i + ": " + dataList[i].print() );
    long sample = dataList[i].getRaw();
    
    
    double std_dev_multiplier = 1.75;
    double up_tol = win.getMean() + (win.getStdDev() * std_dev_multiplier);
    double bot_tol = win.getMean() - (win.getStdDev() * std_dev_multiplier);
    print( (int)bot_tol + " <-> " + (int)win.getMean() + " <-> " + (int)up_tol);

    winALL.update(sample);
    winSTD.update(winALL.getStdDev());
    //win.update(sample);
    
    double stdStd = winSTD.getStdDev();
    //double stdStd = winALL.getStdDev();
    boolean wasSampleAdded = false;
    if ( i < 10) {
      wasSampleAdded = true;
      win.update(sample);
      println();
    } else if ( (sample <= up_tol && sample >= bot_tol) || (stdStd > 100) ) {
      wasSampleAdded = true;
      win.update(sample);
      println("\t in tolerence.");
    } else {
      if ( sample > up_tol ) {
        println("\t sample is greater than tolerance. Ignoring");
      } else {
        println("\t sample is less then tolerance. Ignoring");
      }
    }
    
    String previousStr = "";
    if(wasSampleAdded)
    {
      prevSampleUsed = sample;
      previousStr = String.valueOf(sample);
    }else{
      previousStr = "";
    }
    


    dataDump[i] = new DataDump(sample, win.getMean(), win.getStdDev(), winSTD.getMean(), winSTD.getStdDev(), previousStr);

    println();
    delay(0);
  }

  PrintWriter output = createWriter("datadump.csv");

  output.println(dataDump[0].printHeader());
  for (int i = 0; i < dataListSize; i++ ) {
    output.println(dataDump[i].print());
  }

  output.flush(); // Writes the remaining data to the file
  output.close();
  exit();
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
