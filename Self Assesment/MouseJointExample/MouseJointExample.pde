import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import shiffman.box2d.*;
import org.jbox2d.dynamics.joints.*;
import java.util.ArrayList;
import java.util.Iterator;


Box2DProcessing box2d;

Spring s;
Box b;


void setup() {

	size(640, 480);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0,-10);
	b = new Box(width/2, height/2, 30,30);
	s = new Spring();
}

void mousePressed() {

	s.bind(b, mouseX, mouseY);

}

void mouseReleased() {

	s.destroy();

}


void draw() {

	background(255);
	box2d.step();
	b.display();
	s.update(mouseX, mouseY);
  
}
