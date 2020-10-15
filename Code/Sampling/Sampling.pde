int sampleSize = 100;
PVector[] samples = new PVector[5000];
int index = 0;

void setup() {
  size(800, 800);
  background(255);
  strokeWeight(3);
  stroke(0);
}

void draw() {
  background(255);
  sample();
  for (int i = 0; i < index; i++) {
     point(samples[i].x, samples[i].y); 
  }
  if(index == samples.length) 
    noLoop();
}

void sample() {
  
}
