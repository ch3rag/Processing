final int resolutionX = 10;
final int resolutionY = 10;
void setup() {
  
  size(800, 800);
  noFill();
  background(0);
  stroke(0);
  
  for(int i = 0 ; i <= width ; i += resolutionY) {
    beginShape();
    for(int j = 0 ; j <= height ; j += resolutionX) {
      curveVertex(j, i);
    }
    endShape();
  }

}
