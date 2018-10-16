class Terrain {

	ArrayList <Vec2> terrain;

	Terrain(int numPoints, float noiseFactor) {

		terrain = new ArrayList <Vec2> ();
		float delta = width / numPoints;
		float x = 0;
		for(int i = 0 ; i <= width ; i += delta) {
			terrain.add(new Vec2(i, height/2 + noise(x) * height/3));
			x += noiseFactor;
		}

		Vec2[] vertices = new Vec2[terrain.size()];

		for(int i = 0 ; i < terrain.size() ; i++) {
			vertices[i] = box2d.coordPixelsToWorld(terrain.get(i));
		}

		ChainShape cs = new ChainShape();
		cs.createChain(vertices, vertices.length);
		Body body;
		BodyDef bd = new BodyDef();
		body = box2d.createBody(bd);
		body.createFixture(cs, 1);
	}

	void display()  {

		beginShape();

		stroke(0);
		strokeWeight(2);
		noFill();
		for(Vec2 v : terrain) {
			vertex(v.x, v.y);
		}
		endShape();
 	}

}