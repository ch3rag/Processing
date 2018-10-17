import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;



Box2DProcessing box2d;

Box b1,b2;
Boundary floor;

void setup() {

	size(640, 480);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);
	b1 = new Box(width/2-50, 100, 50, 50);
	b2 = new Box(width/2+50, 100, 50, 50);
	floor = new Boundary(width/2, height - 10, width, 10);

	WeldJointDef wjd = new WeldJointDef();
	wjd.bodyA = b1.body;
	wjd.bodyB = b2.body;
	wjd.localAnchorA.set(b1.body.getWorldCenter());
	wjd.localAnchorB.set(b2.body.getWorldCenter());
	WeldJoint wj = (WeldJoint)box2d.world.createJoint(wjd);
}

void draw() {

	background(255);
	box2d.step();
	b1.draw();
	b2.draw();
	floor.draw();
}