import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.*;

Car c;
Box2DProcessing box2d;
Boundary floor;


final float TIME_STEP = 0.03;
final int VELOCITY_ITERATION = 20;
final int POSITION_ITERATION = 20;

void setup() {
	
	size(800, 600);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -20);
	
	c = new Car(width/2, height / 2, new DNA());
	floor = new Boundary(width / 2, height, width, 10);
}

void draw() {

	background(255);
	box2d.step(TIME_STEP, VELOCITY_ITERATION, POSITION_ITERATION);
	c.draw();
	floor.draw();
}

void mousePressed() { 
	c = new Car(width/2, height / 2, new DNA());
}