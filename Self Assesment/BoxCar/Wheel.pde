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
		fd.friction = 0.9;
		fd.restitution = 0;
		fd.shape = cs;
		fd.filter.categoryBits = CATEGORY_CAR;
		fd.filter.maskBits = MASK_CAR;
		body.createFixture(fd);

	}

	void draw() {

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