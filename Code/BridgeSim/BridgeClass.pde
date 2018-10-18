class Bridge {
	
	int numPoints;
	Circle[] circles;

	Bridge(float start, float y, float bWidth, int numPoints) {

		float delta = bWidth / numPoints;
		circles = new Circle[numPoints];


		for(int i = 0 ; i < numPoints ; i ++) {
			
			Circle c = null;
			if(i == 0 || i == numPoints - 1) {
				 c = new Circle((i-1) * delta, y, 5, BodyType.STATIC);		
			} else {
				 c = new Circle((i-1) * delta, y, 5, BodyType.DYNAMIC);	
			}

			circles[i] = c;

			if (i > 0) {

				Circle cp = circles[i - 1];

				DistanceJointDef djd = new DistanceJointDef();
				djd.bodyA = c.body;
				djd.bodyB = cp.body;
				djd.length = box2d.scalarPixelsToWorld(delta);
				djd.frequencyHz = 0;
				djd.dampingRatio = 0;

				DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);

			}
		}
	}

	void draw() {
		for(Circle c : circles) {
			c.draw();
		}
	}
}