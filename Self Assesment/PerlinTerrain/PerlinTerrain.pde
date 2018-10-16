import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.ArrayList;
import java.util.Iterator;

Box2DProcessing box2d;
ArrayList <Circle> circles;
Terrain surface;

void setup() {

	size(640, 480);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);
	circles = new ArrayList <Circle> ();
	surface = new Terrain(100, 0.05);
}


void draw() {

	background(255);
	box2d.step();
	surface.display();

	if (mousePressed) {
		circles.add(new Circle(mouseX, mouseY, 10));
	}

	Iterator <Circle> i = circles.iterator();

	while(i.hasNext()) {
		Circle c = i.next();
		c.display();
		
		if(c.killBody()) {
			i.remove();
		}
	}
 
}