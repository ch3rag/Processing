float boxWidth = 20;
final float rotX = atan(1 / sqrt(2));
float angle = 0;
float boxHeight;
float distance;
float ang;
float offset;
float dAngle = PI * 1.2;
int numBoxes = 16;
PVector [][] coords = new PVector[numBoxes][numBoxes];

void setup() {

  fullScreen(P3D);
  noStroke();
  int half = numBoxes / 2;
  for(int i = 0 ; i < coords.length ; i++) {
    for(int j = 0 ; j < coords[0].length ; j++) {
      coords[i][j] = new PVector((j - half) * boxWidth, (i - half) * boxWidth);
    }
  }
}

void draw() {
  background(0);
  translate(width/2, height/2, 0);
  ortho();
  rotateX(-rotX);
  rotateY(angle * 0.05);
  directionalLight(230, 228, 176, -1, 0, 0);
  directionalLight(130, 186, 180, 0, 1, 0);
  directionalLight(255, 16, 80, 1, 0, 0);
  directionalLight(12, 217, 242, 0, 0, 1);
  directionalLight(63, 84, 132, 0, 0, -1);
  for(int i = 0 ; i < numBoxes ; i++)  { 
    for(int j = 0 ; j < numBoxes ; j++) {
        pushMatrix();
        translate(coords[i][j].x, 0, coords[i][j].y);
        distance = (coords[i][j].x * coords[i][j].x + coords[i][j].y * coords[i][j].y);
        offset = map(distance, 0, 50000, -dAngle, dAngle);
        ang = angle + offset;
        boxHeight = map(sin(ang), -1, 1, 100, 250);
        box(boxWidth - 1, boxHeight, boxWidth - 1);
        popMatrix();
    }
    angle -= 0.0035;
  }
}
