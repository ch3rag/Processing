import de.looksgood.ani.*;


Button start_button;
Button pause_button;
Button play_button;
Slider numParticles;

ArrayList <Button> buttons = new ArrayList <Button> ();
PFont font;
ParticleSystem particleSystem;
Attractor[] attractors;
PImage start;
PImage settings;
PImage play;

//ANI ANIMATION VARIABLES

float startY;
float textY;

enum states {

  MENU, PARTICLESELECTION, MAIN

};

states current;

void animateMenu() {
    startY = -start.height;
    textY = height;
    Ani.to(this, 2, "startY", height/2 - start.height/2);
    Ani.to(this, 2, "textY", height * 0.7);

}
void menu() {

  background(0);
  start_button.updatePosition(start_button.position.x, startY);
  particleSystem.run();
  fill(255);
  textAlign(CENTER,CENTER);
  textSize(30);
  text("PARTICLE SIMULATOR",width/2,textY);
  textAlign(RIGHT,BOTTOM);
  textSize(12);
  text("Created By Chirag Singh Rajput", width,height);

}

void selectParticles() {

  background(0);
  particleSystem.run();
  textAlign(CENTER, CENTER);
  textSize(30);
  text("Number Of Particles", width/2, height/2 + 140);

}

void mainGame() {

  noStroke();
  fill(0,15);
  rect(0,0,width,height);
  particleSystem.run();

  //FOR TESTING
  //attractors[0].position.x = mouseX;
  //attractors[0].position.y = mouseY;
  //particleSystem.applyAttractor(attractors[0]);
  
   for(int i = 0 ; i < touches.length ; i++) {
     particleSystem.applyAttractor(attractors[i]);
     attractors[i].position.x = touches[i].x;
     attractors[i].position.y = touches[i].y;
   }
}


void manageUI () {

  for(Button button : buttons) {
    button.draw();
  }

  numParticles.draw();

  if(start_button.isPressed()) {
    start_button.hide();
    play_button.show();
    numParticles.show();
    current = states.PARTICLESELECTION;
  }

  if(play_button.isPressed()) {
    play_button.hide();
    pause_button.show();
    numParticles.hide();
    particleSystem.particles.clear();
    particleSystem.createParticles((int)numParticles.getValue());
    current = states.MAIN;
  }

  if(pause_button.isPressed()) {
    pause_button.hide();
    start_button.show();
    animateMenu();
    current = states.MENU;
  }
}



void setup() {

  //size(640,480);
  fullScreen();
  orientation(LANDSCAPE);
  colorMode(HSB);

  Ani.init(this);
  textY = height;
  font = createFont("Brand.ttf", 10 * displayDensity);
  textFont(font);
  current = states.MENU;

  particleSystem = new ParticleSystem();
  particleSystem.createParticles(500);
  attractors = new Attractor[5];
  for(int i = 0 ; i < attractors.length ; i++) {
    attractors[i] = new Attractor(0, 0);
  }

  start = loadImage("start.png");
  start.resize(int(width * 0.2),0);

  
  settings = loadImage("pause.png");
  settings.resize(int(width * 0.06),0);


  play = loadImage("play.png");
  play.resize(int(width * 0.1),0);

  //start_button = new Button().setPosition(width/2 - start.width/2, height/2 - start.height/2).setImages(start);
  play_button = new Button().setPosition(width/2 - play.width/2, height/2 - play.height/2 - 130).setImages(play).hide();
  pause_button = new Button().setPosition(width - settings.width - 10, 10).setImages(settings).hide();
  numParticles = new Slider().setPosition(width/4,height/2 - 50).setSize(width/2,100).setValue(200).setRange(100,500).setBackgroundColor(color(0,0,255,0)).setFillColor(color(0,0,255,175)).setStrokeColor(220).setStrokeWeight(10).hide();
  start_button = new Button().setPosition(width/2 - start.width/2, startY).setImages(start);
  
  animateMenu();

  buttons.add(start_button);
  buttons.add(play_button);
  buttons.add(pause_button);

}


void draw() {



  switch(current) {

    case MENU : 
      menu();
      break;
    case PARTICLESELECTION :
      selectParticles();
      break;
    case MAIN :
      mainGame();
  }

  manageUI();
}
