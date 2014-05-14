////IMPORTS
import java.util.Random;
Random javaRandom;

final int INIT_ORGANISMS = 2;
final int INIT_CANDIES = 20;
final int MAX_CANDIES = 100;
final float CANDY_REFILL_RATE = 0.03;

ArrayList organisms;
Organism sentient;
ArrayList candies;

PFont dataFont;

// add guassian 
// evolution, vary behaviour, properties
// Ecosystem of people ansikten som komponenet
// ögon som rör sig
// miner
// kollision detection then opengl supported drawing 
// fix timestep & tweak anmation values
// visualize brain & signals

// === VISUAL SETUP ===
void setup() {
  //size(displayWidth, displayHeight, JAVA2D);
  //size(displayWidth, displayHeight, OPENGL);
  size(600  , 600, JAVA2D);
  //size(600  , 600, OPENGL);
  frameRate(60);
  //smooth();
  colorMode(HSB, 360, 100, 100);
  background(198, 30, 100);
  ellipseMode(CENTER);
  dataFont = loadFont("LetterGothicMTStd-Bold-10.vlw");
  textAlign(CENTER, CENTER);
  
  javaRandom = new Random();
  
  organisms = new ArrayList();
  for (int i = 0; i < INIT_ORGANISMS; i++) {
    organisms.add(new Organism(new AiNetwork()));
  }
  
  sentient = new Organism(new AiNetwork());
  
  candies = new ArrayList();
  for (int i = 0; i < INIT_CANDIES; i++) {
    candies.add(new Candy());
  }
}

//Main loop
void draw() {
  background(198, 30, 100);
  drawOrganisms();
  drawCandy();
  createCandy();
}

//Update and draw organisms
void drawOrganisms() {
  for (int i = 0; i < organisms.size(); i++) {
    Organism organism = (Organism) organisms.get(i);
    organism.update();
    organism.draw();
  
    //Check if it starves to death
    if (organism.fat <= 0) {
      organisms.remove(i);
      i--;
    }
  }
  
  //add support for multiple keystorkes
  if (keyPressed) {
    if (key == 'z') {
      sentient.leftWingFlapping = 10;
    }
    
    if (key == 'x') {
      sentient.rightWingFlapping = 10;
    }
    
    if (key == 's') {
      sentient.leftWingFlapping = 10;
      sentient.rightWingFlapping = 10;
    }
  }
  
  sentient.update();
  sentient.draw();
}

//Draw candy
void drawCandy() {
  for (int i = 0; i < candies.size(); i++) {
    Candy candy = (Candy)candies.get(i);
    candy.draw();
  }
}

//Create random new candy
void createCandy() {
  if (candies.size() < MAX_CANDIES && random(1) < CANDY_REFILL_RATE) {
    candies.add(new Candy());
  }
}

float gaussianCalculator(float mean, float standardDeviation) {
  float g = (float) javaRandom.nextGaussian();
  return standardDeviation * g + mean;
}

