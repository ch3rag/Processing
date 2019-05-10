int cHeight;
int cWidth;
final color [] pallet = { #dccca3,#824c71,#4a2545,#000001,#9da2ab };
void setup() {
  size(800, 800);
  background(255);
  strokeWeight(40);
  rect(0, 0, width, height);
  
  cHeight = height - 80;
  cWidth  = width  - 80;
  translate(40, 40);
  strokeWeight(2);
  
  for(int i = 10 ; i < cHeight ; i += 15) {
     for(int j = 10; j < cWidth ; j += 15) {
       stroke(pallet[int(random(pallet.length))]);
       if(random(1) < 0.5) {
         pushMatrix();
         translate(j, i);
         rotate(-PI/4);
         line(-10, 0, 10, 0);
         popMatrix();
       } else {
         pushMatrix();
         translate(j, i);
         rotate(PI/4);
         line(-10, 0, 10, 0);
         popMatrix();
       }
     }
  }
  save("10Print.png");
}
