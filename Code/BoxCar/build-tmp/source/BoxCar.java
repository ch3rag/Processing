import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.joints.*; 
import org.jbox2d.dynamics.contacts.*; 
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


final float TIME_STEP = 0.03f;
final int VELOCITY_ITERATION = 20;
final int POSITION_ITERATION = 20;

public void setup() {
	
	
	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -20);
	
	c = new Car(width/2, height / 2, new DNA());
	floor = new Boundary(width / 2, height, width, 10);
}

public void draw() {

	background(255);
	box2d.step(TIME_STEP, VELOCITY_ITERATION, POSITION_ITERATION);
	c.draw();
	floor.draw();
}

public void mousePressed() { 
	c = new Car(width/2, height / 2, new DNA());
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

	Fixture[] fixtures;
	ArrayList <Fixture> brokenFixtures;
	PolygonShape[] bodyShapes;
	PolygonShape[] axleShapes;
	Fixture[] axleFixtures;
	Body[] axleBodies;
	PrismaticJoint[] suspensions;
	RevoluteJoint[] motor;
	Fixture[] wheels;
	Body body;
	int col;
	int wheelCount;
	DNA dna;	
	
	Car(float x, float y, DNA dna) {

		this.dna = dna;
		col = color(random(255), random(255), random(255), 200);

		bodyShapes = new PolygonShape[DNA.NUM_VERTICES];
		fixtures = new Fixture[DNA.NUM_VERTICES];
		brokenFixtures = new ArrayList <Fixture> ();
		axleShapes = new PolygonShape[DNA.NUM_VERTICES];
		axleFixtures = new Fixture[DNA.NUM_VERTICES];
		axleBodies = new Body[DNA.NUM_VERTICES];
		suspensions = new PrismaticJoint[DNA.NUM_VERTICES];
		wheels = new Fixture[DNA.NUM_VERTICES];
		motor = new RevoluteJoint[DNA.NUM_VERTICES];

		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.position.set(box2d.coordPixelsToWorld(x, y));
		body = box2d.createBody(bd);

		for (int i = 0 ; i < dna.carVectors.length ; i++) {
			int nextIndex = (i + 1) % dna.carVectors.length;
			Vec2[] vertices = new Vec2[3];
			vertices[0] = box2d.vectorPixelsToWorld(0,0);
			vertices[1] = box2d.vectorPixelsToWorld(dna.carVectors[i].x, dna.carVectors[i].y);
			vertices[2] = box2d.vectorPixelsToWorld(dna.carVectors[nextIndex].x, dna.carVectors[nextIndex].y);
			
			PolygonShape ps = new PolygonShape();
			ps.set(vertices, vertices.length);
			bodyShapes[i] = ps;

			FixtureDef fd = new FixtureDef();
			fd.density = 2;
			fd.friction = 10;
			fd.restitution = 0.05f;
			fd.shape = ps;
			fd.userData = col;
			fd.filter.categoryBits = CATEGORY_CAR;
			fd.filter.maskBits = MASK_CAR;
			Fixture f = body.createFixture(fd);
			body.setUserData(i);
			fixtures[i] = f;
		}

		// WHEELS

		PrismaticJointDef pjd = new PrismaticJointDef();
		
		float axleBoxW = DNA.MAX_R / 10;
		float axleBoxH = DNA.MAX_R / 20;


		pjd.enableLimit = true;
		pjd.enableMotor = true;

		float axleBoxWWorld = box2d.scalarPixelsToWorld(axleBoxW);
		float axleBoxHWorld = box2d.scalarPixelsToWorld(axleBoxH);

		pjd.lowerTranslation = - axleBoxWWorld / 10;
		pjd.upperTranslation =	 axleBoxWWorld / 10;
		pjd.maxMotorForce    =   100;

		 for (int i = 0 ; i < DNA.NUM_VERTICES ; i++) {
			if (dna.wheels[i] == null) {
				continue;
			} else {
				
				wheelCount++;

				Vec2 vertexPos = box2d.vectorPixelsToWorld(dna.carVectors[i].x, dna.carVectors[i].y);
				float axleAngle = dna.wheels[i].axleAngle;
				
				//AXLE FIXTURE ATTACHED TO BODY

				axleShapes[i] =  new PolygonShape();
				axleShapes[i].setAsBox(axleBoxWWorld, axleBoxHWorld, vertexPos, axleAngle);
				
				FixtureDef fd = new FixtureDef();
				fd.filter.categoryBits = CATEGORY_CAR;
				fd.filter.maskBits = MASK_CAR;

				fd.shape = axleShapes[i];
				fd.density = 2;
				fd.restitution = 0.05f;
				fd.friction = 10;
				axleFixtures[i] = createFixture(fd, body, col/2);
				
				// AXLE BODY CONTAINING WHEEL
				bd = new BodyDef();
				bd.position.set(new Vec2(vertexPos.x - axleBoxWWorld * cos(axleAngle), vertexPos.y - (axleBoxWWorld) * sin(axleAngle)));
				bd.type = BodyType.DYNAMIC;

				axleBodies[i] = box2d.createBody(bd);
				
				PolygonShape ps = new PolygonShape();
				ps.setAsBox(axleBoxWWorld, axleBoxHWorld/2, new Vec2(0,0), axleAngle);
				fd.shape = ps;
				fd.density = 20;
				createFixture(fd, axleBodies[i], col/3);
				
				pjd.initialize(body, axleBodies[i], axleBodies[i].getWorldCenter(), new Vec2(cos(axleAngle), sin(axleAngle)));
				PrismaticJoint pj = (PrismaticJoint) box2d.world.createJoint(pjd);

				suspensions[i] = pj;
				
				// WHEEL DEFINITION

				CircleShape cs = new CircleShape();
				cs.m_radius = box2d.scalarPixelsToWorld(dna.wheels[i].radius);
				fd.shape = cs;
				fd.density = 2;
				fd.friction = 10;
				fd.restitution = 0.1f;
				fd.filter.categoryBits = CATEGORY_CAR;
				fd.filter.maskBits = MASK_CAR;

				bd.type = BodyType.DYNAMIC;
				bd.allowSleep = false;
				bd.position.set(vertexPos.x - 2 * axleBoxWWorld * cos(axleAngle), vertexPos.y  - 2 * axleBoxWWorld * sin(axleAngle));
				Body wheelBody = box2d.createBody(bd);
				wheels[i] = createFixture(fd, wheelBody, color(175, 175, 175, 255));
				RevoluteJointDef rdj = new RevoluteJointDef();
				rdj.enableMotor = true;
				rdj.motorSpeed = - 20 * PI;
				rdj.initialize(axleBodies[i], wheelBody, wheelBody.getWorldCenter());
				motor[i] = (RevoluteJoint) box2d.world.createJoint(rdj);
				motor[i].setMotorSpeed(-10 * PI);
				updateTorque();

		 	}
		 }
	} 

	public void draw() {

		for(Fixture f : wheels) {
			if (f != null) drawBody(f.getBody());
		}

		for(Fixture f : brokenFixtures) {
			drawBody(f.getBody());
		}

		for(Body b : axleBodies) {
			 if (b != null) drawBody(b);
		}

		drawBody(body);
	}


	public void breakFixture(int index) {

		int c = (int) fixtures[index].getUserData();
		body.destroyFixture(fixtures[index]);
		fixtures[index] = null;
		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.angle = body.getAngle();
		bd.position.set(body.getPosition());
		Body piece = box2d.createBody(bd);
		Fixture f = piece.createFixture(bodyShapes[index], 2);
		f.setUserData(c);
		brokenFixtures.add(f);
	}

	public Fixture createFixture(FixtureDef fd, Body bd, int col) {
		Fixture f;
		f = bd.createFixture(fd);
		f.setUserData(col);
		return f;
	}

	public void updateTorque() {
		
		float torque;

		if(wheelCount > 0) {
			torque = body.getMass() * 1.5f * 15 / pow(2, wheelCount - 1);
		} else {
			torque = 0;
		}

		for(int i = 0 ; i < DNA.NUM_VERTICES ; i++) {
			if (motor[i] != null) motor[i].setMaxMotorTorque(torque);
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
// void postSolve(Contact cp, ContactImpluse imp) {
	


// }
class DNA {


	static final int NUM_VERTICES = 8;

	static final int MAX_R = 100;
	static final int MIN_R = 20;
	
	static final int MAX_WHEELS = 4; 
	static final int MIN_WHEELS = 2;

	static final int MAX_WHEEL_RADIUS = 50;
	static final int MIN_WHEEL_RADIUS = 10;

	float[] chromosome;
	int length;

	CarVector[] carVectors;
	Wheel[] wheels;

	DNA() {		
		
		chromosome = new float[(NUM_VERTICES * 2) + (MAX_WHEELS * 3)];
		carVectors = new CarVector[NUM_VERTICES];
		wheels = new Wheel[NUM_VERTICES];

		generateCarVectors();
		generateWheels();

	}

	public void generateCarVectors() {

		for(int i = 0 ; i < NUM_VERTICES ; i++) {
			float r = random(MIN_R, MAX_R);
			float theta = random(0, 2 * PI);
			carVectors[i] = new CarVector(r, theta);
		}

		Arrays.sort(carVectors, byTheta);
	}

	public void generateWheels() {
	
		for (int i = 0 ; i < MAX_WHEELS ; i++) {
			if (random(1) < 0.3f) {
				int randomVertex = (int) random(0, NUM_VERTICES);
				float randomRadius = random(MIN_WHEEL_RADIUS, MAX_WHEEL_RADIUS);
				float randomAxleAngle = random(0,  PI);
				wheels [i] = new Wheel(randomRadius, randomVertex, randomAxleAngle);
			}
		}
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

		
// class GA {

// 	int currentCar;

// 	GA(int populationSize, )


// }
public void drawBody(Body body) {

	Vec2 bodyPos = box2d.getBodyPixelCoord(body);
	float angle = body.getAngle();
	pushMatrix();
	translate(bodyPos.x, bodyPos.y);
	rotate(-angle);
	
	for(Fixture f = body.getFixtureList(); f != null ; f = f.getNext()) {
		int c = (int)f.getUserData();
		
		fill(c);
		stroke(c/2);
		strokeWeight(1);
		
		switch(f.getType()) {
			case POLYGON:
				PolygonShape ps = (PolygonShape) f.getShape();
				beginShape();
				for (int i = 0 ; i < ps.getVertexCount() ; i++) {
						Vec2 vtx = box2d.vectorWorldToPixels(ps.m_vertices[i]);
						vertex(vtx.x, vtx.y);
				}
				endShape(CLOSE);
				break;

			case CIRCLE:
				CircleShape cs = (CircleShape) f.getShape();
				Vec2 center = box2d.vectorWorldToPixels(cs.m_p);
				float radius = box2d.scalarWorldToPixels(cs.m_radius);
				ellipse(center.x, center.y, radius * 2, radius * 2);
				line(0, 0, radius, 0);
				break;
			
			default : break;	
		}
	}

	popMatrix();
}
class Wheel {
	
	float radius;
	int vertex;
	float axleAngle;

	Wheel(float radius, int vertex, float axis) {
		
		this.radius = radius;
		this.vertex = vertex;
		this.axleAngle = axis;
	
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
