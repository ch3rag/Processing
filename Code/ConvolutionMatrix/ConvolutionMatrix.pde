PImage flower;
PImage outputGx;
PImage outputGy;

void setup() {

	size(633, 480);
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

PImage applyConvolution(int[][] conMat, PImage image) {
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
			color c = color(averageR ,averageG , averageB);
			output.pixels[pixelLoc] = c;
		}
	}
	output.updatePixels();
	return output;
}
