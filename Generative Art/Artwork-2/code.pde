int cHeight;
int cWidth;
final color [] pallet = { #dccca3,#824c71,#4a2545,#000001,#9da2ab  };
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
  fill(#000000 ,255);  
  ellipse(cWidth/2, cHeight/2, 400, 400);
  noFill();
  for(int i = 10 ; i < cHeight ; i += 15) {
    beginShape();
    stroke(pallet[int(random(pallet.length))]);
    float rand = 10;
    for(int j = 10; j < cWidth ; j += 15) {
      if(dist(j, i, cWidth/2, cHeight/2) < 200) {
        curveVertex(j, i);  
        continue;
    }
      curveVertex(j, i + random(-rand, rand));
     }
     endShape();
  }

  save("10Print.png");
}
