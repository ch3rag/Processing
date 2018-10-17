class CarVector {
	float r;
	float theta;
	float x;
	float y;
	

	CarVector(float r, float theta) {
		
		this.r = r;
		this.theta = theta;

		x = r * cos(theta);
		y = r * sin(theta);

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