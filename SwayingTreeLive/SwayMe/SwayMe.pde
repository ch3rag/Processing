float x = 0;
float y = 1000;
PImage moon;
PImage bg;
FallingStar fs;
Cloud[] clouds = new Cloud[10];

void setup() {

 size(800, 800);
 moon = loadImage("moon.png");
 moon.resize(0, 100);
 fs = new FallingStar();

 for (int i = 0; i < clouds.length; i++) {
  clouds[i] = new Cloud();
 }

 bg = createImage(width, height, RGB);
 bg.loadPixels();
 for (int i = 0; i < bg.pixels.length; i++) {
  if (random(1) > 0.999) {
   bg.pixels[i] = color(255);
  }
 }
 bg.updatePixels();

}

void draw() {
 background(0);
 image(bg, 0, 0);
 x += 0.002;
 y += 0.002;
 image(moon, 100, 100);
 for (Cloud c: clouds) {
  c.draw();
 }
 fs.fall();
 if (frameCount % 200 == 0) fs = new FallingStar();
 pushMatrix();
 translate(width / 2, height);
 branch(height / 7);
 popMatrix();
}

void branch(float length) {
 strokeWeight(length / 7);
 stroke(255);
 line(0, 0, 0, -length);
 translate(0, -length);
 if (length > 10) {
  pushMatrix();
  rotate(noise(x) + 0.25);
  branch(length * 0.7);
  popMatrix();
  pushMatrix();
  rotate(-noise(y) - 0.25);
  branch(length * 0.7);
  popMatrix();
 } else {
  noStroke();
  fill(255, 0, 144);
  ellipse(0, 0, 5, 5);
 }
}
