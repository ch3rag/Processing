PImage shadow;
color[][] strColors;
byte [][] states;
float scale = 80;
float scaleHalf = scale / 2;
float scaleThreeForth = (scale * 3) / 4;
float scaleOneForth   = scale / 4;
int rows;
int cols;
int numStrings;
int index = 0;
int lastIndex;
float scrollSpeed = 0;
final color []  pallet = { #042a2b, #4b2e39, #dccca3, #3a3335, #7d7e75 };
final color [] pallet2 = { #c76165, #586ba4, #324376, #f5dd90, #f42a2b };
final color [] pallet3 = { #f2d7ee, #d3bcc0, #a5668b, #69306d, #0e103d };
final color [] pallet4 = { #ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875 };
final color [] pallet5 = { #ffffff, #00171f, #003459, #007ea7, #00a8e8 };
final color [] pallet6 = { #0b132b, #1c2541, #3a506b, #5bc0be, #6fffe9 };
final color [] pallet7 = { #ffffff, #ffffff, #ffffff, #ffffff, #ffffff };

void setup() {
  fullScreen();
  smooth(8);
  scale = width/10;
  scaleHalf = scale / 2;
  scaleThreeForth = (scale * 3) / 4;
  scaleOneForth   = scale / 4;
  
  strokeWeight(scale / 8);
  shadow = loadImage("shadow1.png");
  shadow.resize(0, 100);
  imageMode(CENTER);
  rows = floor(height/scale) + 2;
  cols = floor(width/scale) + 2;
  numStrings = cols * 2;
  strColors = new color [rows][numStrings];
  for(int i = 0 ; i < numStrings ; i++) {
   strColors[0][i] = pallet2[int(random(pallet2.length))]; 
  }
  states = new byte[rows][numStrings];
  for(int i = 1 ; i < rows ; i++) {
    for(int j = 0 ; j < numStrings - 1 ; j++) {
      byte ret = states[i][j] = generatePattern();
      if(ret > 0) {
        strColors[i][j] = strColors[i-1][j+1];
        strColors[i][j+1] = strColors[i-1][j];
        j++;
      } else {
        strColors[i][j] = strColors[i-1][j];
      }
    }
  }
  noFill();
}
void draw() {
  background(0);
  pushMatrix();
  translate(0, (-index * scale) + scrollSpeed);
  for(int i = index ; i < rows ; i++) {
    int j = 0;
    while(j < numStrings - 1) {
      byte state = states[i][j];
      drawPattern(j * scaleHalf, i * scale, scale, state, strColors[i][j], strColors[i][j+1]);
      if(state > 0) j += 2;
      else j++;
    }
   }
   popMatrix();
   translate(0, (rows - index) * scale +  scrollSpeed);
   for(int i = 0 ; i < index ; i++) {
    int j = 0;
    while(j < numStrings - 1) {
      byte state = states[i][j];
      drawPattern(j * scaleHalf, i * scale, scale, state, strColors[i][j], strColors[i][j+1]);
      if(state > 0) j += 2;
      else j++;
    }
   }
     scrollSpeed  -= 1;
     if(scrollSpeed < - scale) {
       scrollSpeed = 0;
       lastIndex = (index + rows - 1) % rows;
       for(int j = 0 ; j < numStrings - 1 ; j++) {
          byte ret = states[index][j] = generatePattern();
          if(ret > 0) {
            strColors[index][j] = strColors[lastIndex][j+1];
            strColors[index][j+1] = strColors[lastIndex][j];
            j++;
          } else {
            strColors[index][j] = strColors[lastIndex][j];
          }
        }
        index = (index + 1) % (rows);
     }
}
byte generatePattern() {
  float randomNum = random(1);
  if(randomNum < 0.3) {
    return 0;
  } else if(randomNum < 0.6) {
    return 1;
  } else {
    return 2;
  }
}
void drawPattern(float x, float y, float scale, byte state, color cl, color cr) { 
  // STATES
  // 0 SINGLE STRING
  // 1 POSITIVE CROSSOVER
  // 2 NEGATIVE CROSSOVER
  switch(state) {
   case 0:      
    stroke(cl);
    line(x , y, x ,  y + scale);
    break;
   case 1:
      stroke(cr);
      bezier(x, y, x, y + scaleThreeForth, x + scaleHalf, y  + scaleOneForth,  x + scaleHalf, y + scale);
      image(shadow, x + scaleOneForth, y + scaleHalf);
      stroke(cl);
      bezier(x + scaleHalf, y, x + scaleHalf, y + scaleThreeForth, x, y  + scaleOneForth,  x, y + scale);
      break;
   case 2:
      stroke(cl);
      bezier(x + scaleHalf, y, x + scaleHalf, y + scaleThreeForth, x, y  + scaleOneForth,  x, y + scale);
      image(shadow, x + scaleOneForth, y + scaleHalf);
      stroke(cr);
      bezier(x, y, x, y + scaleThreeForth, x + scaleHalf, y  + scaleOneForth,  x + scaleHalf, y + scale);
      break;
  }
}
