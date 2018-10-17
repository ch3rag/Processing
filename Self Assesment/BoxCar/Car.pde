final short CATEGORY_CAR = 0x0001;
final short CATEGORY_PATH = 0x0002;
final short MASK_CAR = CATEGORY_PATH;
final short MASK_PATH = -1;


class Car {

	ArrayList <CarVector> carVectors;
	ArrayList <Wheel> wheels;
	ArrayList <Body> bodies;
	ArrayList <WeldJoint> joints;

	Car(float x, float y) {

		int numVertex = 8;
		int numWheels = 0;
		int rMin = 40;
		int rMax = 120;
		int minWheelRad = 15;
		int maxWheelRad = 50;


		carVectors = new ArrayList <CarVector> ();
		wheels = new ArrayList <Wheel> ();
		bodies = new ArrayList <Body> ();
		joints = new ArrayList <WeldJoint> ();







		for(int i = 0 ; i < numVertex ; i++) {
			float r = random(rMin,rMax);
			float theta = random(0, 2 * PI);
			carVectors.add(new CarVector(r, theta));
		}

		Collections.sort(carVectors, byTheta);

		for (int i = 0 ; i < carVectors.size() ; i++) {
			Vec2[] vertices = new Vec2[3];
			vertices[0] = box2d.vectorPixelsToWorld(0,0);
			vertices[1] = box2d.vectorPixelsToWorld(carVectors.get(i).x, carVectors.get(i).y);
			vertices[2] = box2d.vectorPixelsToWorld(carVectors.get((i + 1) % carVectors.size()).x, carVectors.get((i + 1) % carVectors.size()).y);
			
			BodyDef bd = new BodyDef();
			bd.type = BodyType.DYNAMIC;
			bd.position.set(box2d.coordPixelsToWorld(x, y));

			Body body = box2d.createBody(bd);

			PolygonShape ps = new PolygonShape();
			ps.set(vertices, vertices.length);
			
			FixtureDef fd = new FixtureDef();
			fd.density = 100;
			fd.friction = 0.8;
			fd.restitution = 0;
			fd.shape = ps;
			fd.filter.categoryBits = CATEGORY_CAR;
			fd.filter.maskBits = MASK_CAR;
			body.createFixture(fd);

			body.setUserData(i);
			bodies.add(body);		
		}

		for(int i = 0 ; i < bodies.size() ; i++) {
			WeldJointDef wjd = new WeldJointDef();
			wjd.bodyA = bodies.get(i);
			wjd.bodyB = bodies.get((i + 1) % bodies.size());
			wjd.localAnchorA.set(0,0);
			wjd.localAnchorB.set(0,0);
			wjd.dampingRatio = 1;
			wjd.frequencyHz = 0;
			WeldJoint wj = (WeldJoint) box2d.world.createJoint(wjd);
			joints.add(wj);

			wjd.bodyA = bodies.get(i);
			wjd.bodyB = bodies.get((i + 1) % bodies.size());
			wjd.localAnchorA.set(box2d.vectorPixelsToWorld(carVectors.get(i).x,carVectors.get(i).y));
			wjd.localAnchorB.set(box2d.vectorPixelsToWorld(carVectors.get(i).x,carVectors.get(i).y));
			wjd.dampingRatio = 1;
			wjd.frequencyHz = 0;
			wj = (WeldJoint) box2d.world.createJoint(wjd);
			joints.add(wj);


		}
		
		while(numWheels > 0) {
			int guess = (int)random(0, numVertex);
			boolean flag = false;
			for(int i = 0 ; i < wheels.size() ; i++) {
				if (wheels.get(i).vertex == guess) {
					flag = true;
					break;
				}
			}
			//Improvement
			if (!flag) {
				Vec2 pos = box2d.getBodyPixelCoord(bodies.get(guess));
				pos.addLocal(carVectors.get(guess).x, carVectors.get(guess).y);
				Wheel w = new Wheel(random(minWheelRad, maxWheelRad), guess, random(0, PI), pos.x, pos.y);
				
				wheels.add(w);
				numWheels--;

				WheelJointDef wjd = new WheelJointDef();
				wjd.bodyA = bodies.get(guess);
				wjd.bodyB = w.body;
				wjd.localAnchorA.set(box2d.vectorPixelsToWorld(carVectors.get(guess).x,carVectors.get(guess).y));
				//wjd.localAnchorA.set(1,1);
				wjd.localAnchorB.set(new Vec2(0,0));
				wjd.localAxisA.set(new Vec2(cos(w.axis), sin(w.axis)));
				//wjd.localAxisA.set(new Vec2(0,-1));
				wjd.enableMotor = true;
				wjd.collideConnected = false;
				wjd.dampingRatio = 1;
				wjd.frequencyHz = 0;
				wjd.motorSpeed = 20 * PI;
				wjd.maxMotorTorque = 10000;
				WheelJoint wj = (WheelJoint) box2d.world.createJoint(wjd);
			}
		}
	} 

	void draw() {
		
		strokeWeight(0.5);
		fill(219,133,216, 200);
		stroke(153,43,148);
		for(int i = 0 ; i < bodies.size() ; i++) {

			Body body = bodies.get(i);
			Vec2 pos = box2d.getBodyPixelCoord(body);
			float angle = body.getAngle();

			pushMatrix();
				translate(pos.x, pos.y);
				rotate(-angle);
				line(0,0, carVectors.get(i).x, carVectors.get(i).y);
				beginShape();
					vertex(0,0);
					vertex(carVectors.get(i).x, carVectors.get(i).y);
					vertex(carVectors.get((i + 1) % carVectors.size()).x, carVectors.get((i + 1) % carVectors.size()).y);
				endShape(CLOSE);
			popMatrix();					
		}

		for (int i = 0 ; i < wheels.size() ; i++) {
			wheels.get(i).draw();
		}
	}

	void checkForCollisions() {

		float maxForce = 50000;
		for(int i = 0 ; i < joints.size() ; i++) {
			
			Vec2 argOut = new Vec2();
			float inv_dt = 1;
			WeldJoint wj = joints.get(i);
			if (wj != null) {
				joints.get(i).getReactionForce(inv_dt, argOut);
				if(argOut.lengthSquared() > maxForce) {
					box2d.world.destroyJoint(joints.get(i));
					joints.set(i,null);
				}
			}
		}
	}
}
