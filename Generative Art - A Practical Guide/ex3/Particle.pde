class Particle {
  PVector position;
  PVector pPos;
  float factor;
  color c;
  Particle(float x, float y, float z) {
   position = new PVector(x, y, z); 
   pPos = new PVector(x, y, z);
   factor = random(70, 90);
   position.mult(factor);
   pPos.mult(factor);
   c = color(100, 124, random(255), 250);
  }
  void setPos(float x, float y, float z) {
   pPos.x = position.x;
   pPos.y = position.y;
   pPos.z = position.z;
   position.x = x;
   position.y = y;
   position.z = z;
   position.mult(factor);

  }
  void draw() {
    stroke(c);
    //pushMatrix();
    //translate(position.x, position.y);
    //ellipse(0, 0, 1, 1);
    //popMatrix();
    line(pPos.x, pPos.y, pPos.z, position.x, position.y, position.z);
  }
}
