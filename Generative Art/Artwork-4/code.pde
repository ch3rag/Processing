import java.util.ArrayList;

ArrayList <PVector> line = new ArrayList <PVector> ();

int cHeight;
int cWidth;
final color [] pallet = { #042a2b,#4b2e39,#dccca3,#3a3335,#7d7e75 };
final color [] pallet2 = { #c76165,#586ba4,#324376,#f5dd90,#000000 };
final color [] pallet3 = { #f2d7ee,#d3bcc0,#a5668b,#69306d,#0e103d };
final float randomness = 1.5;
void setup() {
  size(800, 800);
  background(255);
  strokeWeight(40);
  rect(0, 0, width, height);
  cHeight = height - 80;
  cWidth  = width  - 80;
  translate(40, 40);
  strokeWeight(2);
  noStroke();
  noFill();
  for(int i = 0 ; i <= cWidth ; i += 40) {
    line.add(new PVector(i, cHeight/2));
  }  
  for(int i = 0 ; i < 1000 ; i++) {
    stroke(pallet[int(random(pallet.length))], 30);
    beginShape(); 
    for(int j = 0 ; j < line.size(); j++) {
      PVector vertex = line.get(j);
     curveVertex(vertex.x, vertex.y);
     vertex.y += random(-randomness, randomness);
   }
   endShape();
  }
  translate(0, -cHeight/4);
  for(int i = 0 ; i < 1000 ; i++) {
    stroke(pallet2[int(random(pallet.length))], 30);
    beginShape(); 
    for(int j = 0 ; j < line.size(); j++) {
      PVector vertex = line.get(j);
     curveVertex(vertex.x, vertex.y);
     vertex.y += random(-randomness, randomness);
   }
   endShape();
  }
  translate(0, cHeight/2);
  for(int i = 0 ; i < 1000 ; i++) {
    stroke(pallet3[int(random(pallet.length))], 30);
    beginShape(); 
    for(int j = 0 ; j < line.size(); j++) {
      PVector vertex = line.get(j);
     curveVertex(vertex.x, vertex.y);
     vertex.y += random(-randomness, randomness);
   }
   endShape();
  }
  save("10Print.png");
}
