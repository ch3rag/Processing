class FallingStar {
  PVector currentPos;
  PVector prePos;
  FallingStar() {
    currentPos = new PVector(random(width), 0);
    prePos = new PVector(0,0);
  }
  
  void fall() {
    prePos.x = currentPos.x;
    prePos.y = currentPos.y;
    currentPos.x -= 30;
    currentPos.y += 30;
    stroke(255);
    line(currentPos.x, currentPos.y, prePos.x, prePos.y);
  } 
}
