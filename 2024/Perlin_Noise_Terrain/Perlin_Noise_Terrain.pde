int tWidth = 1600;
int tHeight = 1800;
int tDetail = 20;
int rows = tHeight / tDetail;
int cols = tWidth / tDetail;
float step = 0.15;
float yStart = 0.0;
float speed = 0.15;
float[][] elevation = new float[rows][cols];

void setup() {
  size(600, 600, P3D); 
}

void computeTerrain() {
  float yOff = yStart;
  for (int y = 0; y < rows; y++) {
    float xOff = 0.0;
    for (int x = 0; x < cols; x++) {
      elevation[y][x] = map(noise(xOff, yOff), 0, 1, -100, 100);
      xOff += step;
    }
    yOff += step;
  }
  yStart -= speed;
}

void draw() {
  computeTerrain();

  background(135, 206, 235);
  //noFill();
  //noStroke();
  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-tWidth / 2, -tHeight / 2);
  for (int y = 0; y < rows - 1; y++) {
    // beginShape(TRIANGLE_STRIP);
    beginShape(QUAD_STRIP);
    for (int x = 0; x < cols; x++) {
      fill(map(elevation[y][x], -100, 100, 0, 255), 255);
      vertex(x * tDetail, y * tDetail, elevation[y][x]);
      vertex(x * tDetail, (y + 1) * tDetail, elevation[y + 1][x]);
    }
    endShape();
  }
}
  
