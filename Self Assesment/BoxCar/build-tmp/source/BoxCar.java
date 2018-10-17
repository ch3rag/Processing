import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.joints.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BoxCar extends PApplet {








Car c;
Box2DProcessing box2d;
Boundary floor;

public void setup() {
	
	
	//translate(width/2, height/2);
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -20);
	c = new Car(width/2, height / 2);
	floor = new Boundary(width / 2, height - 10, width, 10);
}

public void draw() {

	background(255);
	box2d.step();
	c.draw();
	floor.draw();
	//c.checkForCollisions();

}

public void mousePressed() {
	c = new Car(width/2, height / 2);
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

		FixtureDef fd = new FixtureDef();
		//fd.density = 1;
		fd.friction = 1;
		fd.restitution = 1;
		fd.filter.categoryBits = CATEGORY_PATH;
		fd.filter.maskBits = MASK_PATH;
		fd.shape = ps;

		body.createFixture(fd);

	}

	public void draw() {

		fill(0);
		noStroke();
		rectMode(CENTER);
		rect(x,y,w,h);

	}
}
final short CATEGORY_CAR = 0x0001;
final short CATEGORY_PATH = 0x0002;
final short MASK_CAR = CATEGORY_PATH;
final short MASK_PATH = -1;


class Car {

	ArrayList <CarVector> carVectors;
	ArrayList <Wheel> wheels;
	ArrayList <Body> bodies;
	ArrayList <WeldJoint> joints;

	Car(float x, float y) {

		int numVertex = 8;
		int numWheels = 0;
		int rMin = 40;
		int rMax = 120;
		int minWheelRad = 15;
		int maxWheelRad = 50;


		carVectors = new ArrayList <CarVector> ();
		wheels = new ArrayList <Wheel> ();
		bodies = new ArrayList <Body> ();
		joints = new ArrayList <WeldJoint> ();







		for(int i = 0 ; i < numVertex ; i++) {
			float r = random(rMin,rMax);
			float theta = random(0, 2 * PI);
			carVectors.add(new CarVector(r, theta));
		}

		Collections.sort(carVectors, byTheta);

		for (int i = 0 ; i < carVectors.size() ; i++) {
			Vec2[] vertices = new Vec2[3];
			vertices[0] = box2d.vectorPixelsToWorld(0,0);
			vertices[1] = box2d.vectorPixelsToWorld(carVectors.get(i).x, carVectors.get(i).y);
			vertices[2] = box2d.vectorPixelsToWorld(carVectors.get((i + 1) % carVectors.size()).x, carVectors.get((i + 1) % carVectors.size()).y);
			
			BodyDef bd = new BodyDef();
			bd.type = BodyType.DYNAMIC;
			bd.position.set(box2d.coordPixelsToWorld(x, y));

			Body body = box2d.createBody(bd);

			PolygonShape ps = new PolygonShape();
			ps.set(vertices, vertices.length);
			
			FixtureDef fd = new FixtureDef();
			fd.density = 100;
			fd.friction = 0.8f;
			fd.restitution = 0;
			fd.shape = ps;
			fd.filter.categoryBits = CATEGORY_CAR;
			fd.filter.maskBits = MASK_CAR;
			body.createFixture(fd);

			body.setUserData(i);
			bodies.add(body);		
		}

		for(int i = 0 ; i < bodies.size() ; i++) {
			WeldJointDef wjd = new WeldJointDef();
			wjd.bodyA = bodies.get(i);
			wjd.bodyB = bodies.get((i + 1) % bodies.size());
			wjd.localAnchorA.set(0,0);
			wjd.localAnchorB.set(0,0);
			wjd.dampingRatio = 1;
			wjd.frequencyHz = 0;
			WeldJoint wj = (WeldJoint) box2d.world.createJoint(wjd);
			joints.add(wj);

			wjd.bodyA = bodies.get(i);
			wjd.bodyB = bodies.get((i + 1) % bodies.size());
			wjd.localAnchorA.set(box2d.vectorPixelsToWorld(carVectors.get(i).x,carVectors.get(i).y));
			wjd.localAnchorB.set(box2d.vectorPixelsToWorld(carVectors.get(i).x,carVectors.get(i).y));
			wjd.dampingRatio = 1;
			wjd.frequencyHz = 0;
			wj = (WeldJoint) box2d.world.createJoint(wjd);
			joints.add(wj);


		}
		
		while(numWheels > 0) {
			int guess = (int)random(0, numVertex);
			boolean flag = false;
			for(int i = 0 ; i < wheels.size() ; i++) {
				if (wheels.get(i).vertex == guess) {
					flag = true;
					break;
				}
			}
			//Improvement
			if (!flag) {
				Vec2 pos = box2d.getBodyPixelCoord(bodies.get(guess));
				pos.addLocal(carVectors.get(guess).x, carVectors.get(guess).y);
				Wheel w = new Wheel(random(minWheelRad, maxWheelRad), guess, random(0, PI), pos.x, pos.y);
				
				wheels.add(w);
				numWheels--;

				WheelJointDef wjd = new WheelJointDef();
				wjd.bodyA = bodies.get(guess);
				wjd.bodyB = w.body;
				wjd.localAnchorA.set(box2d.vectorPixelsToWorld(carVectors.get(guess).x,carVectors.get(guess).y));
				//wjd.localAnchorA.set(1,1);
				wjd.localAnchorB.set(new Vec2(0,0));
				wjd.localAxisA.set(new Vec2(cos(w.axis), sin(w.axis)));
				//wjd.localAxisA.set(new Vec2(0,-1));
				wjd.enableMotor = true;
				wjd.collideConnected = false;
				wjd.dampingRatio = 1;
				wjd.frequencyHz = 0;
				wjd.motorSpeed = 20 * PI;
				wjd.maxMotorTorque = 10000;
				WheelJoint wj = (WheelJoint) box2d.world.createJoint(wjd);
			}
		}
	} 

	public void draw() {
		
		strokeWeight(0.5f);
		fill(219,133,216, 200);
		stroke(153,43,148);
		for(int i = 0 ; i < bodies.size() ; i++) {

			Body body = bodies.get(i);
			Vec2 pos = box2d.getBodyPixelCoord(body);
			float angle = body.getAngle();

			pushMatrix();
				translate(pos.x, pos.y);
				rotate(-angle);
				line(0,0, carVectors.get(i).x, carVectors.get(i).y);
				beginShape();
					vertex(0,0);
					vertex(carVectors.get(i).x, carVectors.get(i).y);
					vertex(carVectors.get((i + 1) % carVectors.size()).x, carVectors.get((i + 1) % carVectors.size()).y);
				endShape(CLOSE);
			popMatrix();					
		}

		for (int i = 0 ; i < wheels.size() ; i++) {
			wheels.get(i).draw();
		}
	}

	public void checkForCollisions() {

		float maxForce = 50000;
		for(int i = 0 ; i < joints.size() ; i++) {
			
			Vec2 argOut = new Vec2();
			float inv_dt = 1;
			WeldJoint wj = joints.get(i);
			if (wj != null) {
				joints.get(i).getReactionForce(inv_dt, argOut);
				if(argOut.lengthSquared() > maxForce) {
					box2d.world.destroyJoint(joints.get(i));
					joints.set(i,null);
				}
			}
		}
	}
}
class CarVector {
	float r;
	float theta;
	float x;
	float y;
	

	CarVector(float r, float theta) {
		
		this.r = r;
		this.theta = theta;

		x = r * cos(theta);
		y = r * sin(theta);

	} 
}


Comparator <CarVector> byTheta = new Comparator <CarVector> () {
	public int compare(CarVector c1, CarVector c2) {
		if (c1.theta > c2.theta) {
			return 1;
		}
		return -1;
	}
};
class Wheel {
	
	float radius;
	int vertex;
	float axis;
	Body body;

	Wheel(float radius, int vertex, float axis, float x, float y) {
		this.radius = radius;
		this.vertex = vertex;
		this.axis = axis;
	
		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.position.set(box2d.coordPixelsToWorld(x,y));
		
		body = box2d.createBody(bd);

		CircleShape cs = new CircleShape();
		cs.m_radius = box2d.scalarPixelsToWorld(radius);

		FixtureDef fd = new FixtureDef();
		fd.density = 100;
		fd.friction = 0.9f;
		fd.restitution = 0;
		fd.shape = cs;
		fd.filter.categoryBits = CATEGORY_CAR;
		fd.filter.maskBits = MASK_CAR;
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
			ellipse(0, 0, radius * 2, radius * 2);
			line(0, 0, radius, 0);
		popMatrix();
	}
}
  public void settings() { 	size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BoxCar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
