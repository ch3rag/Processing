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

	void display() {

		fill(0);
		noStroke();
		rectMode(CENTER);
		rect(x,y,w,h);

	}
}