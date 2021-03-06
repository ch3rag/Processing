import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.ArrayList;
import java.util.Iterator;

Box2DProcessing box2d;

ArrayList <Circle> circles;
Boundary b;

void setup() {

	size(640, 480);

	circles = new ArrayList <Circle> ();
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);
	b = new Boundary(width/2 , height - 10, width, 10);
}

void draw() {

	background(255);
	b.display();
	if(mousePressed) {
		circles.add(new Circle(mouseX, mouseY, 5));
	}

	box2d.step();
	Iterator <Circle> i = circles.iterator();
	while(i.hasNext()) {
		Circle c = i.next();
		c.display();
		if(c.killBody()) {
			i.remove();
		}
	}
}
