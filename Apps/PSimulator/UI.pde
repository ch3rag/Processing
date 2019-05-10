class Button {
	
	PVector position;
	PImage image;
	boolean isVisible = true;
	boolean pressed = false;

	Button() {
		position = new PVector(0,0);
	}

	Button setPosition(float x, float y) {
		position = new PVector(x,y);
		return this;
	}

	Button setImages(PImage image) {
		this.image = image;
		return this;
	}

	Button show() {
		isVisible = true;
		return this;
	}

	Button hide() {
		isVisible = false;
		return this;
	}


	void draw() {
		if(isVisible) image(image, position.x, position.y);

	}

	void updatePosition(float x, float y) {
		position.x = x;
		position.y = y;
	}

	boolean isPressed() {
		if(isVisible) {
			if(!pressed && mousePressed && mouseX > position.x && mouseX < position.x + image.width && mouseY > position.y && mouseY < position.y + image.height) {
				pressed = true;
			}

			if(pressed && !mousePressed && mouseX > position.x && mouseX < position.x + image.width && mouseY > position.y && mouseY < position.y + image.height) {
				pressed = false;
				return true;
			}
		}
		return false;
	}
}

class Slider {

	float currentValue;
	float maxValue;
	float minValue;
	PVector position;
	PVector size;
	boolean isVisible = false;
	color backgroundColor = color(0);
	color fillColor = color(255);
	color strokeColor = color(150);
	int strokeSize = 2;

	Slider() {
		position = new PVector(0,0);
		size  = new PVector(100,10);
	}

	Slider setValue(float value) {
		currentValue = value;
		return this;
	}

	Slider setRange(float min, float max) {
		minValue = min;
		maxValue = max;
		return this;
	}

	Slider setPosition(float x, float y) {
		position.x = x;
		position.y = y;
		return this;
	}

	Slider setSize(float width, float height) {
		this.size.x = width;
		this.size.y = height;
		return this;
	}

	Slider hide() {
		isVisible = false;
		return this;
	}

	Slider show() {
		isVisible = true;
		return this;
	}

	Slider setBackgroundColor(color c) {
		backgroundColor = c;
		return this;
	}

	Slider setFillColor(color c) {
		fillColor = c;
		return this;
	}

	Slider setStrokeColor(color c) {
		strokeColor = c;
		return this;
	}

	Slider setStrokeWeight(int weight) {
		strokeSize = weight;
		return this;
	}

	float getValue() {
		return currentValue;
	}

	void draw() {

		if(isVisible) {
			pushMatrix();
				fill(color(fillColor));
				noStroke();
				updateValues();
				rect(position.x, position.y, map(currentValue, minValue, maxValue, 0, size.x), size.y);
				textSize(20);
				textAlign(LEFT,TOP);
				text(int(minValue), position.x, position.y + size.y + 10);
				textAlign(RIGHT,TOP);
				text(int(maxValue), position.x + size.x, position.y + size.y + 10);
				fill(color(backgroundColor));
				stroke(color(strokeColor));
				strokeWeight(strokeSize);
				rect(position.x, position.y, size.x, size.y);
			popMatrix();
		}
	}

	void updateValues() {
		if(isVisible) {
			if(mousePressed && mouseX > position.x && mouseX < position.x + size.x && mouseY > position.y && mouseY < position.y + size.y) {
				float dx = map(mouseX - position.x, 0, size.x, minValue, maxValue);
				currentValue = dx;
				//println("currentValue: "+currentValue);
			}
		}
	}
} 
