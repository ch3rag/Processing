final color []  pallet = { #042a2b, #4b2e39, #dccca3, #3a3335, #7d7e75 };
final color [] pallet2 = { #c76165, #586ba4, #324376, #f5dd90, #f42a2b };
final color [] pallet3 = { #f2d7ee, #d3bcc0, #a5668b, #69306d, #0e103d };
final color [] pallet4 = { #ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875 };
final color [] pallet5 = { #ffffff, #00171f, #003459, #007ea7, #00a8e8 };
final color [] pallet6 = { #0b132b, #1c2541, #3a506b, #5bc0be, #6fffe9 };
final color [] pallet7 = { #ffffff, #ffffff, #ffffff, #ffffff, #ffffff };

void setup() {
 size(800, 800);
 background(255);
 

}

void drawGrid(int x, int y, int w, int h, int stepSize, float angle) {
  pushMatrix();
  translate(x, y);
  rotate(angle);
  for(int i = - w/2 ; i <= w/2 ; i += stepSize) {
    line(i, - h/2, i, h/2);
  }
  
  for(int i = - h / 2 ; i <= + h / 2 ; i += stepSize) {
    line(- w/2, i, w / 2, i);    
  }
  popMatrix();
}

void draw() {
 background(255);
  stroke(0);
  strokeWeight(40);
  rect(0, 0, width, height);
 float f = 0.25;
 strokeWeight(1);
 stroke(pallet6[0],255);
 int s = (int)random(200);
 
 // CONCENTRIC CIRCLES
 //drawCircle(width / 2 - s, height / 2, (int)(width * f), 5);
 //drawCircle(width / 2 + s, height / 2, (int)(width * f), 5);
 //drawCircle(width / 2, height / 2 - s, (int)(width * f), 5);
 //drawCircle(width / 2, height / 2  + s, (int)(width * f), 5);
 
 // SPIKES
 drawSpikes(width / 2 - s, height / 2, (int)(width * f), 0.03);
 drawSpikes(width / 2 + s, height / 2, (int)(width * f), 0.03);
 drawSpikes(width / 2, height / 2 - s, (int)(width * f), 0.03);
 drawSpikes(width / 2, height / 2  + s, (int)(width * f), 0.03);
 
 // GRIDS
 //drawGrid(width / 2, height / 2, (int)(width * f), (int)(height * f), 4, random(5));
 //drawGrid(width / 2, height / 2, (int)(width * f), (int)(height * f), 4, random(5));
 //drawGrid(width / 2, height / 2, (int)(width * f), (int)(height * f), 4, random(5));
 noLoop();
 saveFrame(random(1000) + ".jpg");
}

void drawCircle(int x, int y, int r, int step) {
 pushMatrix();
 translate(x, y);
 noFill();
 for(int i = 0 ; i <= r ; i += step) {
   ellipse(0, 0, i, i);
 }
 popMatrix(); 
}

void drawSpikes(int x, int y, int r, float step) {
 pushMatrix();
 translate(x, y);
 noFill();
 for(float i = 0 ; i <= 2 * PI ; i += step) {
   float a = r * cos(i);
   float b = r * sin(i);
   line(0, 0, a, b);
 }
 popMatrix(); 
}
