// A sketch to express any given image in the form of k-given colors
// Vinayak Nayak - 04th December 2018
// K-means algorithm implemented on an image.
PImage sample;
PImage actual;
Table imageData;
int k = 2;
ArrayList<Pxls> data = new ArrayList<Pxls>();
ArrayList<ArrayList> clusters = new ArrayList<ArrayList>();
ArrayList<Pxls> centroid = new ArrayList<Pxls>();

void setup() {
  size(1280, 853);
  sample = loadImage("sample.jpg");
  actual = createImage(sample.width, sample.height, RGB);
  loadData();
  centroid = initializeCentroid();
  for (int i = 0; i < k; i++) {
    clusters.add(new ArrayList<Pxls> ());
  }
}// end of setup

void draw() {
  ArrayList<Pxls> c = new ArrayList<Pxls>();

  for (Pxls pix : data) {
    float d_min = 10000;
    int centroidIndex = 0;
    Pxls closestMean = centroid.get(centroidIndex);
    for (int j = 0; j < centroid.size(); j++) {
      float d = euclideanDistance(pix, centroid.get(j));
      if (d <= d_min) {
        d_min = d;
        centroidIndex = j;
        closestMean = centroid.get(centroidIndex);
      }
    }
    clusters.get(centroidIndex).add(pix);
  }

  centroid = resetCentroid(clusters);
  paintActual();
  delay(1000);
}// end of draw

//Optional Function to create a csv file of the original image data
void generateCSV() {
  imageData = new Table();
  imageData.addColumn("x_Loc");
  imageData.addColumn("y_Loc");
  imageData.addColumn("r");
  imageData.addColumn("g");
  imageData.addColumn("b");
  sample.loadPixels();
  int count = 0;
  for (int i = 0; i < sample.width; i++) {
    for (int j = 0; j < sample.height; j++) {
      TableRow newRow = imageData.addRow();
      int index = i + j * sample.width;
      newRow.setInt("x_Loc", i);
      newRow.setInt("y_Loc", j);
      newRow.setInt("r", int(red(sample.pixels[index])));
      newRow.setInt("g", int(green(sample.pixels[index])));
      newRow.setInt("b", int(blue(sample.pixels[index])));
    }
  }
  saveTable(imageData, "imageinfo.csv");
  print("Printed the data to imageinfo.csv");
}// end of generateCSV

//Load all the pixels in an ArrayLIst for processing purposes
void loadData() {
  sample.loadPixels();
  for (int i = 0; i < sample.width; i++) {
    for (int j = 0; j < sample.height; j++) {
      int index = i + j * sample.width;
      int r = int(red(sample.pixels[index]));
      int g = int(green(sample.pixels[index]));
      int b = int(blue(sample.pixels[index]));
      data.add(new Pxls(i, j, r, g, b));
    }
  }
}// end of loadData

//Pick k locations at random as the k means for an image
//For the sake of intitialization
ArrayList<Pxls> initializeCentroid() {
  int[] choices = new int[k];
  ArrayList<Pxls> centroid = new ArrayList<Pxls>();
  //Get k random non-repeated values from the range 0 to 1 less than the size of the data array
  int count = 0;
  while (count < k) {
    int x = int(random(data.size()));
    boolean add = true;
    for (int i: choices){
      if(x == i){
        add = false;
        break;
      }
    }
    if(add){
      choices[count] = x;
      count = count + 1;
    }
  }
  //Get the pixel data of the above selected random indices
  for (int p : choices) {
    centroid.add(data.get(p));
  }
  return centroid;
}// end of initializeCentroid()

//Calculates the euclidean distance between two 
//Colors of a pixel.
float euclideanDistance(Pxls a, Pxls b) {
  int dr = a.r - b.r;
  int dg = a.g - b.g;
  int db = a.b - b.b;
  return sqrt(dr*dr + dg*dg + db*db);
}// end of euclideanDistance()


//Resets the mean/centroid as per the new clustering arrangement
ArrayList<Pxls> resetCentroid(ArrayList<ArrayList> clst) {
  ArrayList<Pxls> centroids = new ArrayList<Pxls>();

  for (ArrayList<Pxls> cls : clst) {
    int avgR = 0;
    int avgG = 0;
    int avgB = 0;
    int avgX = 0;
    int avgY = 0;
    for (Pxls p : cls) {
      avgX += p.x;
      avgY += p.y;
      avgR += p.r;
      avgG += p.g;
      avgB += p.b;
    }
    float div = 1 + cls.size();
    centroids.add(new Pxls(int(avgX/div), int(avgY/div), int(avgR/div), int(avgG/div), int(avgB/div)));
  }
  return centroids;
}// end of resetCentroid


//Writes the data to an image and displays it on the screen after every iteration
void paintActual() {
  actual.loadPixels();
  for (int i = 0; i < clusters.size(); i++) {
    color c = color(centroid.get(i).r, centroid.get(i).g, centroid.get(i).b);
    ArrayList<Pxls> cls = clusters.get(i);
    for (int j = 0; j < cls.size(); j++) {
      int x_Pos = cls.get(j).x;
      int y_Pos = cls.get(j).y;
      int index = x_Pos + y_Pos * actual.width;
      actual.pixels[index] = c;
    }
  }
  actual.updatePixels();
  image(actual, 0, 0, actual.width, actual.height);
  fill(0);
  textSize(actual.width/11);
  text("Post iteration: " + str(frameCount), 20, actual.height/11);
}// end of paint actual
