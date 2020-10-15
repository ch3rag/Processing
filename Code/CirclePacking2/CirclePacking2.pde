import java.util.ArrayList;

class Circle {
 PVector position;
 float radius;
 boolean growing = true;
 Circle(float x, float y) {
  position = new PVector(x, y);
  radius = 1;
 }
 void draw() {
  stroke(0);
  strokeWeight(1);
  noFill();
  ellipse(position.x, position.y, radius * 2, radius * 2);
 }

 void grow() {
  if (growing)
   radius += 0.2;
 }

 boolean edges() {
  float relativeXRight = this.position.x + this.radius;
  float relativeXLeft = this.position.x - this.radius;
  float relativeYBottom = this.position.y + this.radius;
  float relativeYTop = this.position.y - this.radius;
  return (relativeXRight > width || relativeXLeft <= 0 || relativeYTop < 0 || relativeYBottom > height);
 }
}

ArrayList < Circle > circles = new ArrayList < Circle > ();
ArrayList < PVector > spots = new ArrayList < PVector > ();
PImage image;

void setup() {
 size(700, 794);
 image = loadImage("./data/test1.jpg");
 image.loadPixels();
 for (int y = 0; y < image.height; y++) {
  for (int x = 0; x < image.width; x++) {
   int index = y * image.width + x;
   color c = image.pixels[index];
   float b = brightness(c);
   if (b < 1) {
    spots.add(new PVector(x, y));
   }
  }
 }
}

void draw() {
 for (int i = 0; i < 30; i++) {
  Circle circle = newCircle();
  if (circle != null) {
   circles.add(circle);
  }
 }
 background(255);
 for (Circle c: circles) {
  if (c.edges()) {
   c.growing = false;
  } else {
   for (Circle other: circles) {
    float d = PVector.dist(c.position, other.position);
    if (d < (c.radius + other.radius) && c != other) {
     c.growing = false;
     break;
    }
   }
  }
  c.draw();
  c.grow();
 }
}

Circle newCircle() {

 int index = int(random(0, spots.size()));
 PVector point = spots.get(index);
 //float x = random(width);
 //float y = random(height);
 boolean valid = true;
 for (Circle c: circles) {

  float distance = dist(point.x, point.y, c.position.x, c.position.y);
  if (distance < c.radius) {
   valid = false;
   break;
  }
 }
 if (valid) {
  return new Circle(point.x, point.y);
 } else {
  return null;
 }
}
