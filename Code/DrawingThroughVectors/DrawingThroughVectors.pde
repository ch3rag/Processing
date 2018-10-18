import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.collision.shapes.*;



Box2DProcessing box2d;

Body body;
Boundary b;
Box box;
Vec2[] v;

void setup() {

	size(600, 400);

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
	v2[2] = new Vec2(1.3 * scale, 1 * scale);
	v2[3] = new Vec2(-1.3 * scale, 1 * scale);
	v2[4] = new Vec2(-2 * scale, 0);

	v[0] = box2d.vectorPixelsToWorld(0, scale * -3);
	v[1] = box2d.vectorPixelsToWorld(2 * scale, 0);
	v[2] = box2d.vectorPixelsToWorld(1.3 * scale, 1 * scale);
	v[3] = box2d.vectorPixelsToWorld(-1.3 * scale, 1 * scale);
	v[4] = box2d.vectorPixelsToWorld(-2 * scale, 0);

	PolygonShape ps = new PolygonShape();
	ps.set(v, v.length);
	FixtureDef fd = new FixtureDef();
	fd.density = 10;
	fd.friction = 0.5;
	fd.restitution = 0.05;
	fd.shape = ps;
	fd.userData = color(255,100,100);
	body.createFixture(fd);
	b = new Boundary(width/2, height, width, 10);


}

void drawBody(Body body) {

	Vec2 bodyPos = box2d.getBodyPixelCoord(body);
	float angle = body.getAngle();
	pushMatrix();
	translate(bodyPos.x, bodyPos.y);
	rotate(-angle);
	
	for(Fixture f = body.getFixtureList(); f != null ; f = f.getNext()) {
		color c = (color)f.getUserData();
		
		fill(c);

		switch(f.getType()) {
			case POLYGON:
				PolygonShape ps = (PolygonShape) f.getShape();
				beginShape();
				for (int i = 0 ; i < ps.getVertexCount() ; i++) {
						Vec2 vtx = box2d.vectorWorldToPixels(ps.m_vertices[i]);
						vertex(vtx.x, vtx.y);
				}
				endShape(CLOSE);
			case CIRCLE:
				CircleShape cs = (CircleShape) f.getShape();
				Vec2 center = box2d..vectorWorldToPixels(cs.m_p);
				float radius = box2d.scalarWorldToPixels(cs.m_radius);
				ellipse(center.x, center.y, radius * 2, radius * 2);
				break;
			
			default : break;	
		}
	}

	popMatrix();
}

void draw() {





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
