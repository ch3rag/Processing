import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.collision.shapes.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DrawingThroughVectors extends PApplet {








Box2DProcessing box2d;

Body body;
Boundary b;
Box box;
Vec2[] v;
Vec2[] v2;
public void setup() {

	

	box2d = new Box2DProcessing(this);
	box2d.createWorld();
	box2d.setGravity(0, -10);

	
	box = new Box(100, 100, 10, 10);

	BodyDef bd = new BodyDef();

	bd.position.set(box2d.coordPixelsToWorld(100 , 100));
	bd.type = BodyType.DYNAMIC;
	bd.angle = (PI/4);
	
	body = box2d.createBody(bd);

	int scale = 5;

	v = new Vec2[5];
	v2 = new Vec2[5];

	v2[0] = new Vec2(0, scale * -3);
	v2[1] = new Vec2(2 * scale, 0);
	v2[2] = new Vec2(1.3f * scale, 1 * scale);
	v2[3] = new Vec2(-1.3f * scale, 1 * scale);
	v2[4] = new Vec2(-2 * scale, 0);

	v[0] = box2d.vectorPixelsToWorld(0, scale * -3);
	v[1] = box2d.vectorPixelsToWorld(2 * scale, 0);
	v[2] = box2d.vectorPixelsToWorld(1.3f * scale, 1 * scale);
	v[3] = box2d.vectorPixelsToWorld(-1.3f * scale, 1 * scale);
	v[4] = box2d.vectorPixelsToWorld(-2 * scale, 0);

	PolygonShape ps = new PolygonShape();
	ps.set(v, v.length);
	FixtureDef fd = new FixtureDef();
	fd.density = 10;
	fd.friction = 0.5f;
	fd.restitution = 0.05f;
	fd.shape = ps;
	fd.userData = color(255,100,100);
	body.createFixture(fd);
	b = new Boundary(width/2, height, width, 10);
}

public void drawBody(Body body) {

	Vec2 bodyPos = box2d.getBodyPixelCoord(body);
	float angle = body.getAngle();
	pushMatrix();
	translate(bodyPos.x, bodyPos.y);
	rotate(-angle);
	
	for(Fixture f = body.getFixtureList(); f != null ; f = f.getNext()) {
		int c = (int)f.getUserData();
		
		fill(c);

		switch(f.getType()) {
			case POLYGON:
				PolygonShape ps = (PolygonShape) f.getShape();
				beginShape();
				for (int i = 0 ; i < ps.getVertexCount() ; i++) {
						Vec2 vtx = ps.m_vertices[i];
						vtx = box2d.vectorWorldToPixels(vtx);
						vertex(vtx.x, vtx.y);
				}
				endShape(CLOSE);
				break;
			
			default : break;	
		}
	}

	popMatrix();
}

public void draw() {





	// // for(int i = 0 ; i < 100 ; i++) {
	box2d.step();
	// // }
	background(255);
	drawBody(body);
	// box.display();
	// fill(175);
	// stroke(0);
	// Fixture f = body.getFixtureList();
	// Vec2[] v = new Vec2[5];

	// PolygonShape ps = (PolygonShape) f.getShape();
	// Transform ts = body.getTransform();
	// //println("ts.toString(): "+ts.toString());
	// for(int i = ps.getVertexCount() - 1 ; i >= 0 ; i--) {
		
	// 	//println(ps.m_vertices[i].x, ps.m_vertices[i].y);
	// 	//v[i] = new Vec2(ps.m_vertices[i].x, ps.m_vertices[i].y);
		
	// 	v[i] = new Vec2(ps.m_vertices[i].x, ps.m_vertices[i].y);

	// 	//v[i].addLocal(box2d.getBodyPixelCoord(body));
	// 	//ts.mulToOut(ts, ps.m_vertices[i], v[i]);
	// 	//v[i].addLocal(body.getPosition());
	// 	float angle = ts.q.getAngle();
	// 	v[i].x = v[i].x * cos(angle) - v[i].y * sin(angle);
	// 	v[i].y = v[i].x * sin(angle) + v[i].y * cos(angle);
	// 	v[i] = box2d.vectorWorldToPixels(v[i]);
	// 	//v[i].addLocal(box2d.getBodyPixelCoord(body));
	// 	println(v[i].x, v[i].y);
	// }
	// println(box2d.getBodyPixelCoord(body).x,box2d.getBodyPixelCoord(body).y);
	Vec2 pos = box2d.getBodyPixelCoord(body);
	// pushMatrix();
	// 	translate(pos.x, pos.y);
	// 	beginShape();
	// 		for(int i = v.length - 1 ; i >= 0 ; i--) {
	// 			vertex(v[i].x, v[i].y);
	// 		}			
	// 	endShape(CLOSE);
	// popMatrix();
	b.draw();
	// box2d.step();
	// noLoop();

	// float angle = body.getAngle();
	// pushMatrix();
	// 	translate(pos.x, pos.y);
	// 	rotate(-angle);
	// 	beginShape();
	// 	for(int i = 0 ; i < v2.length ; i++) {
	// 		vertex(v2[i].x, v2[i].y);
	// 	}
	// 	endShape();
	// popMatrix();
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
		fd.density = 1;
		fd.friction = 0.3f;
		fd.restitution = 0.5f;

		body.createFixture(fd);
	
	}

	public void display() {

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
  public void settings() { 	size(600, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DrawingThroughVectors" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
