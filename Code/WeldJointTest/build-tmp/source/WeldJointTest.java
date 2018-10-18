import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.dynamics.joints.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class WeldJointTest extends PApplet {









Box2DProcessing box2d;

Box b1,b2;
Boundary floor;

public void setup() {

	
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

public void draw() {

	background(255);
	box2d.step();
	b1.draw();
	b2.draw();
	floor.draw();
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
		bd.angle = random(PI * 2);
		body = box2d.createBody(bd);

		//Creating Shape
		PolygonShape ps = new PolygonShape();

		float box2dW = box2d.scalarPixelsToWorld(w/2);
		float box2dH = box2d.scalarPixelsToWorld(h/2);

		ps.setAsBox(box2dW, box2dH);

		//Creating Fixture

		FixtureDef fd = new FixtureDef();
		fd.shape = ps;
		fd.density = 1;
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
  public void settings() { 	size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WeldJointTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
