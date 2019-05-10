class Repeller {
 PVector position;
 float strength;
 
 Repeller(float x, float y, float strength) {
   position = new PVector(x, y);
   this.strength = strength; 
   
 }
 
 PVector getForce(PVector pos) {
    PVector resultant = PVector.sub(position, pos);
    float mag = resultant.mag();
    resultant.normalize();
    mag = constrain(mag, 0, 300);
    if (mag <= 300) {
      resultant.mult(strength * map(mag, 300, 0, 0, 70));
      return new PVector(resultant.x * .8, resultant.y);
    } else {
     return new PVector(0, 0);
    }
    
 }
 void draw() {
   ellipse(position.x, position.y, 16, 16);
 }
}
