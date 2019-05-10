import java.util.ArrayList;
ArrayList <PVector> path = new ArrayList <PVector> (); 
final color [] pallet = { #042a2b,#4b2e39,#dccca3,#3a3335,#7d7e75 };
final color [] pallet2 = { #c76165,#586ba4,#324376,#f5dd90,#000000 };
final color [] pallet3 = { #f2d7ee,#d3bcc0,#a5668b,#69306d,#0e103d };
final color [] pallet4 = { #ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875 };
final color [] pallet5 = { #ffffff, #00171f, #003459, #007ea7, #00a8e8 };
final color [] pallet6 = { #0b132b, #1c2541, #3a506b, #5bc0be, #6fffe9 };
int i = 0;
void setup() {
  size(800, 800, P3D);
  background(255);
  PFont font = createFont("font.ttf", 52);
  textFont(font);
  strokeWeight(40);
  rect(0, 0, width, height);
  //colorMode(HSB);
  smooth();
  for(float i = -PI ; i <= PI ; i += 0.01) {
    path.add(new PVector(cos(i), sin(i), map(i, -PI, PI, 0.5, 0)));
  }
  PVector last = new PVector(path.get(path.size() - 1).x, path.get(path.size() - 1).y);
  for(float i = 0 ; i <= TWO_PI ; i += 0.01) {
      path.add(new PVector(last.x - 1 + cos(-i), last.y + sin(-i), last.z + 0.08 * i));
  }
  smooth();
}

void draw() {
  textSize(32);
  fill(0);
  text("infinity", width - 140, height - 60); 
  translate(width/2 + 120, height/2 , 200);
  rotateY(PI/5);
  rotateX(0.6);
  noFill();
  strokeWeight(1);
  for(int i = 0 ; i < 2000 ; i++) {
    float randX = random(-20,20); //<>//
    float randY = random(-20,20);
    float randZ = random(-20,20);
    stroke(pallet[int(random(pallet.length))], 50);
    beginShape();
    for(PVector pathVertex : path) {
     curveVertex((pathVertex.x * 100) + randX, (pathVertex.y * 100) + randY, (pathVertex.z * 100) + randZ); //<>//
  }
    endShape(CLOSE);
  }
  saveFrame("infinty.png");
  noLoop();
}
