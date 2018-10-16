import java.util.ArrayList;

final int maxIterations = 200;
int counter = 1;
int index = 0;
float progress = 1;
float delta;
float scaleFactor;
int arcColor;
float max = 0;
ArrayList <Integer> sequence = new ArrayList <Integer> ();
ArrayList <Arc> arcs = new ArrayList <Arc> ();

int sgn(double num) {
	return (int)(num / num);
}

void step() {

	if (((index - counter) > 0) && !sequence.contains(index - counter))  {
		index = index - counter;
		sequence.add(index);
	} else {
		index = index + counter;
		sequence.add(index);
	}

	counter = counter + 1;
	int curIndex = sequence.get(sequence.size()-1);
	int preIndex = sequence.get(sequence.size()-2);
	int diameter = abs(preIndex - curIndex);
	float x = (float)(preIndex + curIndex) / 2; 
	//println(x,diameter, preIndex, curIndex);
	if (x > max) {
		max = x;
	}
	arcs.add(new Arc(x, diameter, counter % 2, preIndex-curIndex, (int)map(counter,1, maxIterations, 0, 255)));
}

void setup() {

	size(800, 600);
	noFill();
	colorMode(HSB);
	background(0,0,255);
	smooth();
	sequence.add(0);
	step();
	println("arcs.size(): "+arcs.size());
	// for (int i = 0 ; i < maxIterations ; i++) {
	// 	step();
	// }
}

void draw() {

	//background(255,0,255);
	background(0);
	strokeWeight(0.5);


	translate(20, height/2);
	//scale(650/max);

	delta = map(counter, 1, maxIterations, 0.01, 1);
	scaleFactor += delta;
	scale(500/scaleFactor);

	
	
	// for(int i = 0 ; i < arcs.size() ; i++) {
	// 		arcs.get(i).draw(1);
	// }
	

	for(int i = 0 ; i < arcs.size() - 1; i++) {
			arcs.get(i).draw(1);
	}

	if (progress < 1) {
		arcs.get(arcs.size() - 1).draw(progress);
		delta = map(arcs.size(),0,maxIterations,0.001,1);
		progress = progress + delta;
	} else {
		arcs.get(arcs.size() - 1).draw(1);
		step();
		progress = 0;
	}

	if (counter == maxIterations) {
		noLoop();
	}
}


class Arc {
	
	float x;
	float diameter;
	int direction;
	float reversed;
	int col;

	Arc(float x, float dia, int dir, int reversed,int col) {
		this.x = x;
		this.diameter = dia;
		this.direction = dir;
		this.reversed = reversed;
		this.col = col;
	}

	void draw(float progress) {
		stroke(col, 255, 255);
		if (direction == 0) {
			if (reversed < 0) {
				arc(x, 0, diameter, diameter, PI * (1- progress), PI);
			} else {
				arc(x, 0, diameter, diameter, 0, PI * progress);
			}
		} else {
			if(reversed < 0) {
				arc(x, 0, diameter, diameter, PI, PI +  PI * progress);
			} else {
				arc(x, 0, diameter, diameter, PI + PI * (1 - progress), PI * 2);
			}
		}
	}
}