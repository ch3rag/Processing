class Spring {

	MouseJoint mj;

	Spring() {
		mj = null;
	}

	void bind(Box box, float x, float y) {

		MouseJointDef mjd = new MouseJointDef();
		mjd.bodyA = box2d.getGroundBody();
		mjd.bodyB = box.body;
		mjd.target.set(box2d.coordPixelsToWorld(x,y));
		mjd.maxForce = 5000.0;
		mjd.frequencyHz = 60.0;
		mjd.dampingRatio = 0.0;
		
		mj = (MouseJoint) box2d.world.createJoint(mjd);
		print("jc");
	}

	void destroy() {
		if(mj != null) {
			box2d.world.destroyJoint(mj);
			mj = null;
		}
	}

	void update(float x, float y) {
		
		if(mj!=null) {
			Vec2 mouseLoc = box2d.coordPixelsToWorld(x, y);
			mj.setTarget(mouseLoc);
		}
	}
	
	//void draw();



}