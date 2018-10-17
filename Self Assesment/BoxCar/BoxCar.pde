import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import java.util.*;

Car c;
Box2DProcessing box2d;
Boundary floor;

void setup() {
	
	size(800, 600);
	//translate(width/2, height/2);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -20);
	c = new Car(width/2, height / 2);
	floor = new Boundary(width / 2, height - 10, width, 10);
}

void draw() {

	background(255);
	box2d.step();
	c.draw();
	floor.draw();
	//c.checkForCollisions();

}

void mousePressed() {
	c = new Car(width/2, height / 2);
}