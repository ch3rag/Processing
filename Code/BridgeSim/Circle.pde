class Circle {
	
	Body body;
	float radius;


	Circle(float x, float y, float radius, BodyType bodyType) {
		
		this.radius = radius;

		BodyDef bd = new BodyDef();
		bd.position.set(box2d.coordPixelsToWorld(x,y));
		bd.type = bodyType;

		body = box2d.createBody(bd);

		CircleShape cs = new CircleShape();
		cs.m_radius = box2d.scalarPixelsToWorld(radius);

		FixtureDef fd = new FixtureDef();
		fd.density  = 1;
		fd.restitution = 0.5;
		fd.friction = 0.3;
		fd.shape = cs;

		body.createFixture(fd);

	}

	void draw() {

		Vec2 pos = box2d.getBodyPixelCoord(body);
		float angle = body.getAngle();
		pushMatrix();
		translate(pos.x, pos.y);
		rotate(-angle);
		ellipse(0,0,radius * 2, radius * 2);
		popMatrix();
	}

	boolean killBody() {
		Vec2 pos = box2d.getBodyPixelCoord(body);
		if(pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
			box2d.destroyBody(body);
			return true;
		}
		return false;
	}
}