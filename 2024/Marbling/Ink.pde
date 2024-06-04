class Ink {

  PVector[] vertices;

  PVector center;
  float r;
  color col;

  Ink(float x, float y, float r, int numVertices) {
    center = new PVector(x, y);
    this.r = r;
    vertices = new PVector[numVertices];
    for (int i = 0; i < vertices.length; i++) {
      float angle = map(i, 0, numVertices, 0, TWO_PI);
      vertices[i] = PVector.fromAngle(angle);
      vertices[i].setMag(r);
      vertices[i].add(center);
    }
    col = color(random(255));
  }

  void marble(Ink other) {
    for (PVector v : vertices) {
      PVector c = other.center;
      PVector p = v.copy();
      p.sub(c);
      float rad = other.r;
      float root = sqrt(1 + (rad * rad) / p.magSq());
      p.mult(root);
      p.add(c);
      v.set(p);
    }
  }

  void tine(float x, float z, float c) {
    float u = 1 / pow(2, 1/c);
    for (PVector v : vertices) {
      v.x = v.x;
      v.y = v.y + z * pow(u, abs(v.x - x));
    }
  }

  void show() {
    fill(col);
    noStroke();
    beginShape();
    for (PVector v : vertices) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }
}
