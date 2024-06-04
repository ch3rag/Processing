final int circleDetail = 100;
ArrayList<Ink> drops;

void addInk(float x, float y, float r) {
  Ink newDrop = new Ink(x, y, r, circleDetail);

  for (Ink other : drops) {
    other.marble(newDrop);
  }

  drops.add(newDrop);
}

void tineLine(float xl, float z, float c) {
  for (Ink drop : drops) {
    drop.tine(xl, z, c);
  }
}

void setup() {
  drops = new ArrayList<Ink>();
  size(800, 800);
  for (int i = 0; i < 10; i++) {
    addInk(400, 400, 50);
  }
}

void draw() {
  background(220);
  
  if (mousePressed) {
      tineLine(400, 1, 16);
  }

  // float x = random(width);
  // float y = random(height);
  // float r = random(10, 20);
  // addInk(x, y, r);

  for (Ink drop : drops) {
    drop.show();
  }
}
