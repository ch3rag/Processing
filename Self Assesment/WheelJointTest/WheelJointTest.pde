import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;

Box2DProcessing box2d;
Boundary floor;
Box b;
Circle c;

void setup() {
	
	size(600, 400);
	translate(width/2, height/2);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);
	floor = new Boundary(width / 2, height - 10, width, 10);

	b = new Box(width/2, height/2, 100, 50);
	c = new Circle(width/2 - 50, height/2 + 25, 30);

	WheelJointDef wjd = new WheelJointDef();
	wjd.bodyA = b.body;
	wjd.bodyB = c.body;
	wjd.enableMotor = true;
	wjd.maxMotorTorque = 10000;
	wjd.motorSpeed = 10 * PI;
	wjd.localAxisA.set(new Vec2(0,1));
	wjd.dampingRatio = 1;
	wjd.frequencyHz = 1000;
	wjd.localAnchorA.set(box2d.vectorPixelsToWorld(-50, 25));
	wjd.localAnchorB.set(0,0);

	WheelJoint w = (WheelJoint) box2d.world.createJoint(wjd);

}

void draw() {

	background(255);
	box2d.step();
	floor.draw();
	b.draw();
	c.draw();
}