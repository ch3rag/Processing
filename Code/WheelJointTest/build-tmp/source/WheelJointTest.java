import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.joints.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class WheelJointTest extends PApplet {







Box2DProcessing box2d;
Boundary floor;
Box b;
Circle c;

public void setup() {
	
	
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

public void draw() {

	background(255);
	box2d.step();
	floor.draw();
	b.draw();
	c.draw();
}
class Boundary {

	float w;
	float h;
	float x;
	float y;

	Boundary(float x, float y, float w, float h) {
		
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		
		Body body;
		BodyDef bd = new BodyDef();
		bd.type = BodyType.STATIC;
		bd.position.set(box2d.coordPixelsToWorld(x,y));
		body = box2d.createBody(bd);

		PolygonShape ps = new PolygonShape();
		float boxW = box2d.scalarPixelsToWorld(w/2);
		float boxH = box2d.scalarPixelsToWorld(h/2);
		ps.setAsBox(boxW, boxH);


		body.createFixture(ps, 1);

	}

	public void draw() {

		fill(0);
		noStroke();
		rectMode(CENTER);
		rect(x,y,w,h);

	}
}
class Box {

	float w;
	float h;
	Body body;

	Box(float x, float y, float w, float h) {

		this.w = w;
		this.h = h;

		//Creating Body
		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.position.set(box2d.coordPixelsToWorld(x, y));
		body = box2d.createBody(bd);
		//Creating Shape
		PolygonShape ps = new PolygonShape();

		float box2dW = box2d.scalarPixelsToWorld(w/2);
		float box2dH = box2d.scalarPixelsToWorld(h/2);

		ps.setAsBox(box2dW, box2dH);

		//Creating Fixture

		FixtureDef fd = new FixtureDef();
		fd.shape = ps;
		fd.density = 10;
		fd.friction = 0.3f;
		fd.restitution = 0.5f;

		body.createFixture(fd);
	
	}

	public void draw() {

		Vec2 pos = box2d.getBodyPixelCoord(body);
		float angle = body.getAngle();
		
		pushMatrix();
		translate(pos.x, pos.y);
		rotate(-angle);
		rectMode(CENTER);
		fill(175);
		stroke(0);
		rect(0,0,w,h);
		popMatrix();
	}

	public boolean killBody() {
		Vec2 pos = box2d.getBodyPixelCoord(body);
		if(pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
			box2d.destroyBody(body);
			return true;
		}
		return false;
	}
}
class Circle {
	
	float radius;
	Body body;


	Circle(float x, float y, float radius) {

		this.radius = radius;

		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.position.set(box2d.coordPixelsToWorld(x,y));
		body = box2d.createBody(bd);

		CircleShape cs = new CircleShape();
		cs.m_radius = box2d.scalarPixelsToWorld(radius);

		FixtureDef fd = new FixtureDef();
		fd.shape = cs;
		fd.density = 1;
		fd.friction = 1;
		fd.restitution = 0.5f;

		body.createFixture(fd);

	}

	public void draw() {

		Vec2 pos = box2d.getBodyPixelCoord(body);
		float angle = body.getAngle();
		pushMatrix();
		translate(pos.x, pos.y);
		rotate(-angle);
		fill(175);
		stroke(0);
		ellipse(0,0,radius * 2, radius * 2);
		line(0,0,radius,0);
		popMatrix();

	}

	public boolean killBody() {

		Vec2 pos = box2d.getBodyPixelCoord(body);
		if(pos.x < 0 || pos.x > width || pos.y > height || pos.y < 0) {
			box2d.destroyBody(body);
			return true;
		}
		return false;
	}
}
  public void settings() { 	size(600, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WheelJointTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
