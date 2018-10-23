import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ConvolutionMatrix extends PApplet {

PImage flower;
PImage outputGx;
PImage outputGy;

public void setup() {

	
	flower = loadImage("flower.jpg");
	
	int[][] conMatX = {{-1,0,1},{-2,0,2},{-1,0,1}};
	int[][] conMatY = {{-1,-2,-1},{0,0,0},{1,2,1}};
	int[][] emboss = {{-2, -1, 0}, {-1, 1, 1}, {0, 1, 2}};
	//outputGy = applyConvolution(conMatY, flower);
	// outputGx = applyConvolution(conMatX, flower);
	tint(255, 150);
	background(0);
	PImage op = applyConvolution(emboss, flower);
	image(op,0,0);
	// for (int i = 0 ; i < 5 ; i++) {
	// 	image(outputGx, 0,0);
	// 	image(outputGy, 0,0);
	// }

}

public PImage applyConvolution(int[][] conMat, PImage image) {
	int factor = 5;
	PImage output = createImage(image.width, image.height, ARGB);
	output.loadPixels();
	image.loadPixels();
	for(int i = 1 ; i < 2 ; i++) {
		for(int j = 1 ; j < 2 ; j++) {
			int pixelLoc = j + i * image.width;
			float averageR = 0;
			float averageG = 0;
			float averageB = 0;
			for(int y = -1 ; y <= 1  ; y++) {
				for(int x = -1 ; x <= 1 ; x++) {
					int neighbourLoc = pixelLoc + (x + y * image.width);
					 float r = red(image.pixels[neighbourLoc]);
					 float g = green(image.pixels[neighbourLoc]);
					 float b = blue(image.pixels[neighbourLoc]);
					 println(r,g,b);
					averageR += (r * conMat[y + 1][x + 1] * factor);
					averageG += (g * conMat[y + 1][x + 1] * factor);
					averageB += (b * conMat[y + 1][x + 1] * factor);
				}
			}
			averageR /= 9;
			averageG /= 9;
			averageB /= 9; 
			println(averageR, averageG, averageB);
			int c = color(averageR ,averageG , averageB);
			output.pixels[pixelLoc] = c;
		}
	}
	output.updatePixels();
	return output;
}
  public void settings() { 	size(633, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ConvolutionMatrix" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
