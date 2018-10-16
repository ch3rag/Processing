import shiffman.box2d.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.joints.*;
import java.util.ArrayList;
import java.util.Iterator;

Box2DProcessing box2d;
ArrayList <Circle> circles;
Bridge b;

void setup() {
	size(640, 480);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);	
	circles = new ArrayList <Circle> ();
	b = new Bridge(0, (height * 0.6), width, 70);

}
	
void draw() {

	background(255);
	box2d.step();
	if (mousePressed) {
		circles.add(new Circle(mouseX, mouseY, 10, BodyType.DYNAMIC));
	}

	Iterator <Circle> i = circles.iterator();
	b.draw();
	while(i.hasNext()) {
		Circle c = i.next();
		c.draw();
		if(c.killBody()) {
			i.remove();
		}
	}
} 

