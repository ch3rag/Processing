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
		fd.friction = 0.3;
		fd.restitution = 0.5;

		body.createFixture(fd);
	
	}

	void draw() {

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

	boolean killBody() {
		Vec2 pos = box2d.getBodyPixelCoord(body);
		if(pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
			box2d.destroyBody(body);
			return true;
		}
		return false;
	}
}