float x = 0;
float angle = PI/8;
PImage light ;
PImage light2 ;
PImage light3 ;
PImage main;
void setup() {
 size(1000, 800);

 strokeWeight(30);
 stroke(15, 0, 0);
 fill(245);
 rect(0, 0, width, height);
 translate(width/2, 50);
 strokeWeight(30);
 stroke(255, 255, 255);
 colorMode(HSB);
 strokeWeight(1);
 light  = loadImage("light.png");
 light.resize(0, 30);
 light2  = loadImage("light2.png");
 light2.resize(0, 30);
 light3  = loadImage("light3.png");
 light3.resize(0, 130);
 main = loadImage("chris.png");
 main.resize(0, 200);
 branch(370);
 image(main, 250, -50);
 rotate(0.03);
 image(light3, -width/2, -110);
 save("image.png");
}

void branch(float len) {
  stroke(map(len, 12, 370, 100, 255), 100, 60, 30);
  strokeWeight(map(len, 10, 300, 2, 50));
  line(0, 0, 0, len);
  pushMatrix();
  rotate(angle);
  line(0, 0, 0, len);
  popMatrix();
  pushMatrix();
  rotate(-angle);
  line(0, 0, 0, len);
  popMatrix();
  if (len > 12) {
   pushMatrix();
   rotate(angle);
   translate(0, len/2); 
   branch(len / 2);
   popMatrix();
   pushMatrix();
   rotate(-angle);
   translate(0, len/2);
   branch(len / 2);
   popMatrix();
   pushMatrix();
   translate(0, len/2);
   branch(len / 2);
   popMatrix();
   pushMatrix();
   rotate(angle);
   translate(0, len); 
   branch(len / 2);
   popMatrix();
   pushMatrix();
   rotate(-angle);
   translate(0, len);
   branch(len / 2);
   popMatrix();
   pushMatrix();
   translate(0, len);
   branch(len / 2);
   popMatrix();
   
   pushMatrix();
   rotate(angle);
   branch(len / 2);
   popMatrix();
   pushMatrix();
   rotate(-angle);
   branch(len / 2);
   popMatrix();
   pushMatrix();
   branch(len / 2);
   popMatrix();
  } else {
         if(random(1) > 0.99) { 
    fill(random(255), 255, 255, 150);
    noStroke();
    float edge = random(15);
    ellipse(0, 0, edge, edge);
         }
      if(random(1) > 0.999) { 
        if(random(1) < 0.5) {
          image(light, 0, -len);
        } else {
          image(light2, 0, -len);
        }
      }
    }  
}
  
