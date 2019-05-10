class Rule {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  float p;
  color clr;
  Rule(float a, float b, float c, float d, float e, float f, float p, color clr) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.e = e;
    this.f = f;
    this.p = p;
    this.clr = clr;
  }
  PVector getXY(float x, float y) {
    float newX = ((a * x) + (b * y)) + e;
    float newY = ((c * x) + (d * y)) + f;
    //print(newX, newY);
    return new PVector(newX, newY);
  }
}



final Rule [] ruleSet = {
  new Rule(0, 0, 0.0, 0.16, 0, 0, 0.01, color(255,255, 0)),
  new Rule(0.85, 0.04, -0.06, 0.85, 0, 1.60, 0.85, color(255,255, 0)),
  new Rule(0.20, -0.26, 0.23, 0.22, 0, 1.60, 0.07, color(255, 255, 0)),
  new Rule(-0.15, 0.28, 0.26, 0.24, 0, 0.44, 0.07, color(255, 255, 0)),
  };
  
float x;
float y;

Rule generateRule() {
  float prob = 1;
  int index = 0;
  while(prob > 0) {
    index = int(random(ruleSet.length));
    prob -= ruleSet[index].p;
  }
  return ruleSet[index];
}

void setup() {
  background(0);
  size(800, 800);
  x = 0;
  y = 0;
 noFill();
}

void draw() {
  translate(width/2, height);
  rotate(PI);
  for(int i = 0 ; i < 10000 ; i++) {
    Rule rule = generateRule();
    PVector newCoords = rule.getXY(x, y);
    x = newCoords.x;
    y = newCoords.y;
    stroke(rule.clr);
    ellipse(-x * 70, y * 70, 0.1, 0.1);
  }
}
