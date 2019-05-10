void setup() {
  size(800, 800, P3D);
  background(0);
  stroke(255, 50);
  noStroke();
  colorMode(HSB);
  fill(255);
  float xStart = random(10);
  float yNoise = random(10);

  translate(width/2, height/2);
  for(float y = -(height/8); y <= (height/8); y += 1) {
    yNoise += 0.03;
    float xNoise = xStart;
    for(float x = -(width/8); x <= (width/8); x += 1) {
      xNoise += 0.03;
      drawPoint(x, y, noise(xNoise, yNoise));
    }
  }
}

void drawPoint(float x, float y, float noiseFactor) {
  pushMatrix();
  translate(x * noiseFactor * 4, y * noiseFactor * 4, -y);
  float edgeSize = noiseFactor * 30;
  fill(int(255 - map(noiseFactor, 0, 1, 0, 100)), 255, 255, 200);
  ellipse(0, 0, edgeSize, edgeSize);
  popMatrix();
}
