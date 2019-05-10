class Cloud {
  PVector pos;
  PImage img;
  float grad;
  Cloud() {
    if(random(1) > 0.7) {
        img = loadImage("cloud1.png");      
    } else {
        img = loadImage("cloud2.png");
    }
    pos = new PVector(random(width), random(50, 150));
    img.resize(0, width/5);
    grad = random(0.2, 1.2);
  }
  
  void draw() {
    image(img, pos.x, pos.y);
    pos.x += grad;
    if(pos.x > width + 100) pos.x = -img.width;
  }
}
