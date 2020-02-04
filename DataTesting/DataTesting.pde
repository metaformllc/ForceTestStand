
import java.util.Arrays;
import java.io.*; 
import java.util.*;



long[] samples;
int dataListSize = 0;

DataProcessor data;

//final String FILENAME = "fts_20200129_074441_f200d200_03";
final String BASE_PATH =  "/recordings/F350D233/";

File[] files;

public void setup() {
  File folder = new File(dataPath(sketchPath() + BASE_PATH));
  String[] filenames = folder.list();
  
  for (String file : filenames) {
    println(file);
  }

  // get and display the number of jpg files
  println(filenames.length + " files in specified directory");

  for (int i = 0; i<filenames.length; i++)
  {
    println("Processing; " + filenames[i]);
    processFile(filenames[i], "Test_0"+i);
  }

  exit();
}

public void processFile(String inName, String outName )
{
  Table table = loadTable(sketchPath() + BASE_PATH + inName, "header");
  println(table.getRowCount() + " total rows in table");
  dataListSize = table.getRowCount();
  samples = new long[dataListSize];

  int x = 0;
  for (TableRow row : table.rows()) {
    long r = row.getInt("raw");
    samples[x++] = r;
  }

  data = new DataProcessor("../processed/batch/");
  data.init(outName);

  for (int i = 0; i < dataListSize; i++ ) {
    data.addSample(samples[i]);
    delay(0);
  }
  data.close();
  
}

public void draw()
{
  background(230);
}

void listFiles()
{
  println("\nListing info about all files in a directory: ");

  for (int i = 0; i < files.length; i++) {
    File f = files[i];   
    if (!f.isDirectory()) {
      println("Full path: " + f.getAbsolutePath());
    }
  }
}
