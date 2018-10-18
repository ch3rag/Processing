class DNA {


	static final int NUM_VERTICES = 8;

	static final int MAX_R = 100;
	static final int MIN_R = 20;
	
	static final int MAX_WHEELS = 4; 
	static final int MIN_WHEELS = 2;

	static final int MAX_WHEEL_RADIUS = 50;
	static final int MIN_WHEEL_RADIUS = 10;

	float[] chromosome;
	int length;

	CarVector[] carVectors;
	Wheel[] wheels;

	DNA() {		
		
		chromosome = new float[(NUM_VERTICES * 2) + (MAX_WHEELS * 3)];
		carVectors = new CarVector[NUM_VERTICES];
		wheels = new Wheel[NUM_VERTICES];

		generateCarVectors();
		generateWheels();

	}

	void generateCarVectors() {

		for(int i = 0 ; i < NUM_VERTICES ; i++) {
			float r = random(MIN_R, MAX_R);
			float theta = random(0, 2 * PI);
			carVectors[i] = new CarVector(r, theta);
		}

		Arrays.sort(carVectors, byTheta);
	}

	void generateWheels() {
	
		for (int i = 0 ; i < MAX_WHEELS ; i++) {
			if (random(1) < 0.3) {
				int randomVertex = (int) random(0, NUM_VERTICES);
				float randomRadius = random(MIN_WHEEL_RADIUS, MAX_WHEEL_RADIUS);
				float randomAxleAngle = random(0,  PI);
				wheels [i] = new Wheel(randomRadius, randomVertex, randomAxleAngle);
			}
		}
	}
}


Comparator <CarVector> byTheta = new Comparator <CarVector> () {
	public int compare(CarVector c1, CarVector c2) {
		if (c1.theta > c2.theta) {
			return 1;
		}
		return -1;
	}
};

		