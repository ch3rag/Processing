final int resolutionX = 2;
final int resolutionY = 2;

final color []  pallet = { #042a2b, #4b2e39, #dccca3, #3a3335, #7d7e75 };
final color [] pallet2 = { #c76165, #586ba4, #324376, #f5dd90, #f42a2b };
final color [] pallet3 = { #f2d7ee, #d3bcc0, #a5668b, #69306d, #0e103d };
final color [] pallet4 = { #ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875 };
final color [] pallet5 = { #ffffff, #00171f, #003459, #007ea7, #00a8e8 };
final color [] pallet6 = { #0b132b, #1c2541, #3a506b, #5bc0be, #6fffe9 };
final color [] pallet7 = { #ffffff, #ffffff, #ffffff, #ffffff, #ffffff };
float maxLen = dist(0, 0, 800, 800);
void setup() {
  
  size(800, 800, P3D);
  smooth(8);
  noFill();

  background(0);


  strokeWeight(2);
  int rows = height / resolutionY;
  int cols = width / resolutionX;
  
  PVector[][] grid = new PVector[rows][cols];
  for(int i = 0 ; i < grid.length ; i++) {
    for(int j = 0 ; j < grid[0].length ; j++) {
      grid[i][j] = new PVector(j * resolutionY,  i * resolutionX, 0); 
    }
  }
 
  Repeller[] repellers = new Repeller[30];
  for(int i = 0 ; i < repellers.length ; i++) {
    repellers[i] = new Repeller(random(width),random(height), -random(0, 1));
  }
  
  repellers[0] = new Repeller(width/2 - 100,height/2, -random(0, 1));
  repellers[1] = new Repeller(width/2 + 100,height/2, -random(0, 1));
  
  for(PVector[] row : grid) {
    for(PVector v : row) {
      for(Repeller r : repellers) {
        v.add(r.getForce(v));
      }
    }
  }
  for(int i = 0 ; i < grid.length ; i++) {
    beginShape();
    for(int j = 0 ; j < grid[0].length ; j++) {
      curveVertex(grid[i][j].x, grid[i][j].y, grid[i][j].z); 
    }
    //stroke(255);
    stroke(pallet5[int(random(pallet.length))], 255);
    endShape();
  }
  
  for(int i = 0 ; i < grid.length ; i++) {
    beginShape();
    for(int j = 0 ; j < grid[0].length ; j++) {
      curveVertex(grid[j][i].x, grid[j][i].y); 
          
    }
    stroke(255);
    stroke(pallet6[int(random(pallet.length))], 100);
    endShape();
  }
    strokeWeight(60);
    stroke(255);  
    rect(0, 0, width, height);

    strokeWeight(30);
    stroke(0);
    rect(0, 0, width, height);
    saveFrame("Pic.png");
}
