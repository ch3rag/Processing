import java.util.ArrayList;

// GLOBALS
int perSampleTry = 100;
int index = 0;
int numSamples = 5000;
Point[] points = new Point[numSamples];
PImage image;
ArrayList <Point> allowedPoints = new ArrayList <Point> ();
float threshold = 5;
class Point {
  PVector position;
  color pointColor;
  Point(PVector position, color pointColor) {
    this.position = position;
    this.pointColor = pointColor;
  }
  
  void draw() {
    strokeWeight(3);
    stroke(0);
    point(this.position.x, this.position.y);
  }
}

void setup() {
  size(540 , 697);
  image = loadImage("./data/test.jpg");
  image.loadPixels();

  for(int y = 0; y < image.height; y++) {
    for(int x = 0; x < image.width; x++) {
      int index = y * image.width + x;
      color c = image.pixels[index];
      float brightness = brightness(c);
//      if(brightness < 255) { 
        allowedPoints.add(new Point(new PVector(x, y), c));
  //    }
    }
  }
  
  for(int i = 0; i < numSamples; i++) {
     sample(); 
  }
}

void draw() {
  background(255);
  for(Point p : points) {
    p.draw(); 
  }
  // GENERATE VORNOI
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      PVector thisPixel = new PVector(x, y);
      Point closestPoint = null;
      float closestDistance = Float.MAX_VALUE;
      for(Point p : points) {
         float distance = PVector.dist(p.position, thisPixel);
         if(distance < closestDistance) {
           closestDistance = distance;
           closestPoint = p;
         }
      }
      // if(closestDistance < threshold) {
        stroke(closestPoint.pointColor);
        point(thisPixel.x, thisPixel.y);
      // }
    }
  }
  saveFrame(random(100) + ".jpg");
  noLoop();
}


// CREATE SAMPLE POINTS USING MITCHELL'S BEST CANDIDATE ALGORITHM
void sample() {
  // GOAL IS TO FIND A POINT THAT IS FARTHEST TO ALL OTHER EXISTING POINTS ON CANVAS
  // TRY A NUMBER OF TIMES AND PICK THE BEST
  float bestDistance = 0;
  Point bestPoint = null;
  for(int i = 0; i < perSampleTry; i++) {
     // GENERATE RANDOM POINT ON CANVAS
     // PVector randomPoint = new PVector(random(width), random(height));
     Point randomPoint = allowedPoints.get(floor(random(allowedPoints.size())));
     // FIND ITS CLOSEST NEIGHBOUR
     float closestNeighbourDistance = Float.MAX_VALUE;
     for(int j = 0; j < index; j++) {
        // CALCULATE THE DISTANCE BETWEEN RANDOM POINT AND THIS POINT
        float distance = PVector.dist(randomPoint.position, points[j].position);
        if(distance < closestNeighbourDistance) {
          closestNeighbourDistance = distance; 
        }
     }
     if(closestNeighbourDistance > bestDistance) {
       bestDistance = closestNeighbourDistance;
       bestPoint = randomPoint;
     }
  }
  // ADD THIS POINT TO ARRAY
  points[index] = bestPoint;
  index++;
}
