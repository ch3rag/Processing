float randomness = 0.4;

final color []  pallet = { #042a2b, #4b2e39, #dccca3, #3a3335, #7d7e75 };
final color [] pallet2 = { #c76165, #586ba4, #324376, #f5dd90, #f42a2b };
final color [] pallet3 = { #f2d7ee, #d3bcc0, #a5668b, #69306d, #0e103d };
final color [] pallet4 = { #ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875 };
final color [] pallet5 = { #ffffff, #00171f, #003459, #007ea7, #00a8e8 };
final color [] pallet6 = { #0b132b, #1c2541, #3a506b, #5bc0be, #6fffe9 };
final color [] pallet7 = { #ffffff, #ffffff, #ffffff, #ffffff, #ffffff };

void setup() {
  size(800, 800);
  background(0);
  noFill();
  stroke(pallet5[int(random(pallet.length))],255);
  strokeWeight(30);
  
  rect(0, 0, width, height);
  strokeWeight(1);
  translate(width/2, height/2);
  for(float z = 0 ; z < TWO_PI ; z += 0.1) {
    pushMatrix();
    rotate(z);
    branch(130);
    popMatrix();
  }
  saveFrame("art.png");
}
  
void branch(float length) {
  strokeWeight(map(length, 120, 0, 1, 0));
  stroke(pallet6[int(random(pallet.length))], 90);
  line(0, 0, length, 0);
  if(length > 60) {
    pushMatrix();
    translate(length * random( 1), 0);
    rotate(random(-randomness, randomness));
    branch(length * 0.8);
    popMatrix();
    pushMatrix();
    translate(length * random(1), 0);
    rotate(random(-randomness, randomness));
    branch(length * 0.8);
    popMatrix();
    pushMatrix();
    translate(length * random(1), 0);
    rotate(random(-randomness, randomness));
    branch(length * 0.8);
    popMatrix();
     pushMatrix();
    translate(length * random(1), 0);
    rotate(random(-randomness, randomness));
    branch(length * 0.8);
    popMatrix();
  }
}
