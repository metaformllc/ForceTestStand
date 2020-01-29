

Table table;

long[] samples;
int dataListSize = 0;
DataDump[] dataDump;

DataProcessor data;

final String FILENAME = "fts_20200129_074441_f200d200_03.csv";

public void setup() {
  
  data = new DataProcessor();
  data.init(FILENAME);

  table = loadTable("recordings/"+FILENAME, "header");

  println(table.getRowCount() + " total rows in table");

  dataListSize = table.getRowCount();
  samples = new long[dataListSize];

  int x = 0;
  for (TableRow row : table.rows()) {
    long r = row.getInt("raw");
    samples[x++] = r;
  }
  
  for (int i = 0; i < dataListSize; i++ ) {
    data.addSample(samples[i]);
    
    delay(0);
  }

  exit();
}

public void draw()
{
  background(230);
}
