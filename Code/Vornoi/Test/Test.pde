import java.util.ArrayList;

class Line {
  PVector start;
  PVector end;
  public Line(float x1, float y1, float x2, float y2) {
    this.start = new PVector(x1, y1);
    this.end = new PVector(x2, y2);
  }
  
  public void draw() {
   stroke(0); 
   strokeWeight(10);
   line(start.x, start.y, end.x, end.y); 
  }
  
  public Line getCopy() {
     return new Line(start.x, start.y, end.x, end.y); 
  }
  
  public void rotateAbout(float x, float y, float angle) {
    start.x -= x;
    start.y -= y;
    
    end.x -= x;
    end.y -= y;
    
    start.rotate(angle);
    end.rotate(angle);
    
    start.x += x;
    start.y += y;
    
    end.x += x;
    end.y += y;
  }
}

ArrayList<Line> lines = new ArrayList<Line>();
ArrayList<Line> newLines = new ArrayList<Line>();
void setup() {
  size(800, 800);
  lines.add(new Line(50, 150 - 50, 50, 50));
  copyLines();
}

final float cosPiBy2 = cos(PI/2);
final float sinPiBy2 = sin(PI/2);
int dx = 2;
float scaleFactor = 1;
float angle =  - dx * PI / 180;
float counter = 0;
float dtx = 0, dty = 0, ddtx = 0, ddty = 0, dSf = 0;
int iter = 0;
void draw() {
  pushMatrix();
  
  scale(1/scaleFactor);
  translate(dtx, dty);

  background(255);
  animate(angle);
  counter += dx;
  for(Line line : lines) {
    line.draw();  
  }
  popMatrix();
  if(counter >= 90 && iter <= 12) {
    iter++;
    dSf  += 0.005;
    ddtx += 2.5;
    ddty += 2.5;
    //float temp = ddtx;
    //ddtx = ddty;
    //ddty = temp;
     counter = 0;
     for(int i = newLines.size() - 1; i >= 0; i--) {
       lines.add(newLines.get(i));
     }
     start = false;
     copyLines();
  } else if(iter > 12) {
    dtx -= ddtx;
    dty -= ddty;
    scaleFactor -= dSf; 
  } else {
    scaleFactor += dSf;
    dtx += ddtx;
    dty += ddty; 
  }
  
}

public void copyLines() {
  newLines.clear();
  for(Line line : lines) {
    newLines.add(line.getCopy());  
  }
}
public boolean start = true;
public void animate(float dtheta) {
  Line last = lines.get(lines.size() - 1);
  PVector origin = new PVector(0, 0);
  if(!start) {
     origin = new PVector(last.start.x, last.start.y);
  } else {
     origin = new PVector(last.end.x, last.end.y);
  }
  for(Line line : newLines) {
    line.rotateAbout(origin.x, origin.y, dtheta);
    line.draw();
  }
}
  
