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