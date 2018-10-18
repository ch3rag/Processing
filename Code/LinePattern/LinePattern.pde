int i,x ,y;
void setup() {
	size(800, 600);
	background(255);
	smooth();
	colorMode(HSB);
	x = 200; y =180;	
}

void draw() {
	i = (i + 1) % height;
	strokeWeight(12);
	stroke(y + random(x), random(255),random(255),100);
	line(0,i,width, random(height));
	line(width,i,0, random(height)); 
}