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
		fd.restitution = 0.5;

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
		ellipse(0,0,radius * 2, radius * 2);
		line(0,0,radius,0);
		popMatrix();

	}

	boolean killBody() {

		Vec2 pos = box2d.getBodyPixelCoord(body);
		if(pos.x < 0 || pos.x > width || pos.y > height || pos.y < 0) {
			box2d.destroyBody(body);
			return true;
		}
		return false;
	}
}