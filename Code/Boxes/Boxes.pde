import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.ArrayList;
import java.util.Iterator;

Box2DProcessing box2d; 
//Box 2D object
ArrayList <Box> boxes;
Boundary b;

void setup() {
	
	size(640, 480);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);
	boxes = new ArrayList <Box> ();
	b = new Boundary(width/2 , height - 10, width, 10);

}

void draw() {

	background(255);
	box2d.step();
	b.display();
	if (mousePressed) {
		boxes.add(new Box(mouseX, mouseY, 30, 30));
	}

	Iterator <Box> i = boxes.iterator();
	
	while(i.hasNext()) {
		Box b = i.next();
		b.display();
		if(b.killBody()) {
			i.remove();
		}
	}
}