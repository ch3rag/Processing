import java.util.ArrayList;
import java.util.Iterator;




class Particle {

	PVector position;
	PVector velocity;
	PVector acceleration;
	PVector previousPosition;
	int randomNum = int(random(255));

	Particle(PVector origin) {
	
		position = origin.get();
		previousPosition = position.get();
		velocity = new PVector(random(-5,5),random(-5, 5));
		acceleration = new PVector(0,0);
	
	}

	void update() {

		previousPosition = position.get();
		velocity.add(acceleration);
		position.add(velocity);
		acceleration.mult(0);
		velocity.limit(15);
	}
	

	void applyForce(PVector force) {

		acceleration.add(force);

	}

	void display() {

		stroke(randomNum,255,255);
		strokeWeight(2);
		line(position.x, position.y, previousPosition.x, previousPosition.y);
		
		//DRAW AS A RECTANGLE
		// noStroke();
		// fill(randomNum,255,255);
		// rect(position.x,position.y,2,2);

	}

	void run() {
		
		update();
		display();

	}
}

class ParticleSystem {

	ArrayList <Particle> particles;

	ParticleSystem() {

		particles = new ArrayList <Particle>();

	}

	void createParticles(int num) {

		for(int i = 0 ; i < num ; i++) {
			particles.add(new Particle(new PVector(random(width),random(height))));
		}

	}

	void applyAttractor(Attractor r) {

    for(Particle p : particles) {

      PVector force = r.attract(p);
      p.applyForce(force);

    	}	

  	}

	void run() {

		Iterator <Particle> i = particles.iterator();

		while(i.hasNext()) {

			Particle p = i.next();
			p.run();
			if(p.position.x > width || p.position.x < 0) {
				p.velocity.x *= -1;
			}

			if(p.position.y > height || p.position.y < 0) {
				p.velocity.y *= -1;
			}
			
		}
	}
}


class Attractor {

  PVector position;
  float G = 1000;

  Attractor(float x, float y) {

    position = new PVector(x,y);

  } 

  PVector attract(Particle p) {

    PVector force = PVector.sub(p.position, position);
    float d = force.mag();
    d = constrain(d, 5, 30);
    force.normalize();
    force.mult(-1 * G/(d*d));
    return force;
  }
}
