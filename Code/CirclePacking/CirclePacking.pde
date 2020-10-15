class Circle {
  PVector position;
  float radius;
  Circle(PVector pos, float r) {
   this.position = pos;
   this.radius = r;
  }
  void show() {
    ellipse(position.x, position.y, radius * 2, radius * 2); 
  }
}

int sampleSize = 1;
Circle[] circles = new Circle[5000];
int index = 1;
float maxRad = 40;

void setup() {
  size(800, 800);
  background(255);
  strokeWeight(1);
  stroke(0);
  noFill();
  circles[0] = new Circle(new PVector(width/2,  height/2), maxRad);
}
boolean clicked = false;
void draw() {
  if(clicked) {
  background(255);
  sample();
  for (int i = 0; i < index; i++) {
     circles[i].show();
  }
  if(index == circles.length) 
    noLoop();
  }
  clicked = false;
}

void mousePressed() {
 clicked = true; 
}

void sample() {
  float bestRadius = 0;
  PVector bestPosition = new PVector(0, 0);
  
  // SAMPLE AND SEARCH THE BEST AMONG THE GOOD
  for(int i = 0; i < sampleSize ; i++) {
    PVector randomPoint = new PVector(random(1) * width, random(1) * height);
    float closestDistance = 99999;
    float closestRadius = 0;
    float dist = 9999999;
    // FIND THE CLOSEST CIRCLE
    for(int j = 0; j < index; j++) {
      float distance = PVector.dist(randomPoint, circles[j].position);
      println("i = " + i + ", dis = >" + distance);
      if(dist > closestDistance - closestRadius) {
        dist = closestDistance - closestRadius;
        closestDistance = distance;
        closestRadius = circles[j].radius; 
      }
    }
    
    float newRadius = Math.min((closestDistance - closestRadius), maxRad);
    println(closestDistance, closestRadius, newRadius);
    if(newRadius > bestRadius) {
     bestRadius = newRadius;
     bestPosition = randomPoint;
    }
  }
   
  circles[index++] = new Circle(bestPosition, bestRadius);
  println(index, bestRadius);
}
