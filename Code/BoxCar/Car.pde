final short CATEGORY_CAR = 0x0001;
final short CATEGORY_PATH = 0x0002;
final short MASK_CAR = CATEGORY_PATH;
final short MASK_PATH = -1;


class Car {

	Fixture[] fixtures;
	ArrayList <Fixture> brokenFixtures;
	PolygonShape[] bodyShapes;
	PolygonShape[] axleShapes;
	Fixture[] axleFixtures;
	Body[] axleBodies;
	PrismaticJoint[] suspensions;
	RevoluteJoint[] motor;
	Fixture[] wheels;
	Body body;
	color col;
	int wheelCount;
	DNA dna;	
	
	Car(float x, float y, DNA dna) {

		this.dna = dna;
		col = color(random(255), random(255), random(255), 200);

		bodyShapes = new PolygonShape[DNA.NUM_VERTICES];
		fixtures = new Fixture[DNA.NUM_VERTICES];
		brokenFixtures = new ArrayList <Fixture> ();
		axleShapes = new PolygonShape[DNA.NUM_VERTICES];
		axleFixtures = new Fixture[DNA.NUM_VERTICES];
		axleBodies = new Body[DNA.NUM_VERTICES];
		suspensions = new PrismaticJoint[DNA.NUM_VERTICES];
		wheels = new Fixture[DNA.NUM_VERTICES];
		motor = new RevoluteJoint[DNA.NUM_VERTICES];

		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.position.set(box2d.coordPixelsToWorld(x, y));
		body = box2d.createBody(bd);

		for (int i = 0 ; i < dna.carVectors.length ; i++) {
			int nextIndex = (i + 1) % dna.carVectors.length;
			Vec2[] vertices = new Vec2[3];
			vertices[0] = box2d.vectorPixelsToWorld(0,0);
			vertices[1] = box2d.vectorPixelsToWorld(dna.carVectors[i].x, dna.carVectors[i].y);
			vertices[2] = box2d.vectorPixelsToWorld(dna.carVectors[nextIndex].x, dna.carVectors[nextIndex].y);
			
			PolygonShape ps = new PolygonShape();
			ps.set(vertices, vertices.length);
			bodyShapes[i] = ps;

			FixtureDef fd = new FixtureDef();
			fd.density = 2;
			fd.friction = 10;
			fd.restitution = 0.05;
			fd.shape = ps;
			fd.userData = col;
			fd.filter.categoryBits = CATEGORY_CAR;
			fd.filter.maskBits = MASK_CAR;
			Fixture f = body.createFixture(fd);
			body.setUserData(i);
			fixtures[i] = f;
		}

		// WHEELS

		PrismaticJointDef pjd = new PrismaticJointDef();
		
		float axleBoxW = DNA.MAX_R / 10;
		float axleBoxH = DNA.MAX_R / 20;


		pjd.enableLimit = true;
		pjd.enableMotor = true;

		float axleBoxWWorld = box2d.scalarPixelsToWorld(axleBoxW);
		float axleBoxHWorld = box2d.scalarPixelsToWorld(axleBoxH);

		pjd.lowerTranslation = - axleBoxWWorld / 10;
		pjd.upperTranslation =	 axleBoxWWorld / 10;
		pjd.maxMotorForce    =   100;

		 for (int i = 0 ; i < DNA.NUM_VERTICES ; i++) {
			if (dna.wheels[i] == null) {
				continue;
			} else {
				
				wheelCount++;

				Vec2 vertexPos = box2d.vectorPixelsToWorld(dna.carVectors[i].x, dna.carVectors[i].y);
				float axleAngle = dna.wheels[i].axleAngle;
				
				//AXLE FIXTURE ATTACHED TO BODY

				axleShapes[i] =  new PolygonShape();
				axleShapes[i].setAsBox(axleBoxWWorld, axleBoxHWorld, vertexPos, axleAngle);
				
				FixtureDef fd = new FixtureDef();
				fd.filter.categoryBits = CATEGORY_CAR;
				fd.filter.maskBits = MASK_CAR;

				fd.shape = axleShapes[i];
				fd.density = 2;
				fd.restitution = 0.05;
				fd.friction = 10;
				axleFixtures[i] = createFixture(fd, body, col/2);
				
				// AXLE BODY CONTAINING WHEEL
				bd = new BodyDef();
				bd.position.set(new Vec2(vertexPos.x - axleBoxWWorld * cos(axleAngle), vertexPos.y - (axleBoxWWorld) * sin(axleAngle)));
				bd.type = BodyType.DYNAMIC;

				axleBodies[i] = box2d.createBody(bd);
				
				PolygonShape ps = new PolygonShape();
				ps.setAsBox(axleBoxWWorld, axleBoxHWorld/2, new Vec2(0,0), axleAngle);
				fd.shape = ps;
				fd.density = 20;
				createFixture(fd, axleBodies[i], col/3);
				
				pjd.initialize(body, axleBodies[i], axleBodies[i].getWorldCenter(), new Vec2(cos(axleAngle), sin(axleAngle)));
				PrismaticJoint pj = (PrismaticJoint) box2d.world.createJoint(pjd);

				suspensions[i] = pj;
				
				// WHEEL DEFINITION

				CircleShape cs = new CircleShape();
				cs.m_radius = box2d.scalarPixelsToWorld(dna.wheels[i].radius);
				fd.shape = cs;
				fd.density = 2;
				fd.friction = 10;
				fd.restitution = 0.1;
				fd.filter.categoryBits = CATEGORY_CAR;
				fd.filter.maskBits = MASK_CAR;

				bd.type = BodyType.DYNAMIC;
				bd.allowSleep = false;
				bd.position.set(vertexPos.x - 2 * axleBoxWWorld * cos(axleAngle), vertexPos.y  - 2 * axleBoxWWorld * sin(axleAngle));
				Body wheelBody = box2d.createBody(bd);
				wheels[i] = createFixture(fd, wheelBody, color(175, 175, 175, 255));
				RevoluteJointDef rdj = new RevoluteJointDef();
				rdj.enableMotor = true;
				rdj.motorSpeed = - 20 * PI;
				rdj.initialize(axleBodies[i], wheelBody, wheelBody.getWorldCenter());
				motor[i] = (RevoluteJoint) box2d.world.createJoint(rdj);
				motor[i].setMotorSpeed(-10 * PI);
				updateTorque();

		 	}
		 }
	} 

	void draw() {

		for(Fixture f : wheels) {
			if (f != null) drawBody(f.getBody());
		}

		for(Fixture f : brokenFixtures) {
			drawBody(f.getBody());
		}

		for(Body b : axleBodies) {
			 if (b != null) drawBody(b);
		}

		drawBody(body);
	}


	void breakFixture(int index) {

		color c = (color) fixtures[index].getUserData();
		body.destroyFixture(fixtures[index]);
		fixtures[index] = null;
		BodyDef bd = new BodyDef();
		bd.type = BodyType.DYNAMIC;
		bd.angle = body.getAngle();
		bd.position.set(body.getPosition());
		Body piece = box2d.createBody(bd);
		Fixture f = piece.createFixture(bodyShapes[index], 2);
		f.setUserData(c);
		brokenFixtures.add(f);
	}

	Fixture createFixture(FixtureDef fd, Body bd, color col) {
		Fixture f;
		f = bd.createFixture(fd);
		f.setUserData(col);
		return f;
	}

	void updateTorque() {
		
		float torque;

		if(wheelCount > 0) {
			torque = body.getMass() * 1.5 * 15 / pow(2, wheelCount - 1);
		} else {
			torque = 0;
		}

		for(int i = 0 ; i < DNA.NUM_VERTICES ; i++) {
			if (motor[i] != null) motor[i].setMaxMotorTorque(torque);
		}
	}

}



