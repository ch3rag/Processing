int cHeight;
int cWidth;
final color [] pallet = { #042a2b,#4b2e39,#dccca3,#3a3335,#7d7e75 };
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
  float rand = 0;
  for(int i = 0 ; i < 1000 ; i += 1) {
    beginShape();
    stroke(pallet[int(random(pallet.length))], 50);
    float a = rand;
    for(int j = 10; j < cWidth ; j += 10) {
      curveVertex(j, cHeight/2  + pow(sin(a), 3) * 250);
      a += 0.1;
     }
     rand += 0.0025;
     endShape();
  }
  save("10Print.png");
}
