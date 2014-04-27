////IMPORTS
import java.util.Random;
Random javaRandom;
PFont dataFont;

ArrayList organisms;
Organism sentient;
ArrayList candies;

final int INIT_ORGANISMS = 30;
final int INIT_CANDIES = 20;
final int MAX_CANDIES = 100;
// sinus independent, add guassian, brain, evolution, vary behaviour, properties

// Ecosystem of people ansikten som komponenet
// styr en
//ögon som rör sig
// miner
//kollision detection

// === VISUAL SETUP ===
void setup() {
  size(displayWidth, displayHeight, JAVA2D);
  //size(600  , 600, JAVA2D);
  frameRate(60);
  smooth();
  colorMode(HSB, 360, 100, 100);
  background(198, 30, 100);
  //background(255);
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
  //dataFont = loadFont("LetterGothicMTStd-Bold-10.vlw");
  
  javaRandom = new Random();
  
  organisms = new ArrayList();
  for (int i = 0; i < INIT_ORGANISMS; i++) {
    organisms.add(new Organism());
  }
  
  sentient = new Organism();
  
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
      //organisms.remove(i);
      //i--;
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
  if (candies.size() < MAX_CANDIES && random(1) < 0.05) {
    candies.add(new Candy());
  }
}



class Eye {
  PVector location;
  float irisSize;
  float pupilSize;
  float gazeAngle;//or vector
  
  Eye(PVector loc) {
    location = loc;
  }
  
  void update() {
  }
  
  void update(float targetGazeAngle) {
  }
  
  void draw() {
  }
}



//Cute little creatures
class Organism {
  final float MAX_SIZE = 100;
  final float MAX_SPEED = 50;
  final float DAMPING = 0.99;
  
  String name;
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float angle;
  float angularVel;
  float angularAcc;
  
  float fat;
  boolean hungry;
  
  float mass = 1;
  float size;
  float radius;
  float wingLength;
  
  float leftWingAngle;
  float rightWingAngle;
  float leftWingFlapping = 0;
  float rightWingFlapping = 0;
  float flapLikelihood;
  
  color baseColor;
  float eyeSizeL, eyeSizeR;
  
  float wingStrength;
  float wingSinR,wingSinL;
  float targetGazeAngle; //or maybe Vector
  
  //Constructor
  Organism() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);
    flapLikelihood = random(0.005, 0.05);
    
    mass = size/20;
    size = random(MAX_SIZE / 4, MAX_SIZE);
    fat = 10000;
    hungry = false;
    
    baseColor = color(random(360), map(wingStrength,0.08,0.2, 40, 70), 95);
    
    wingStrength = random(0.08,0.2);
    
    updateBodyProportions();
    
    randomName();
  }
  
  //Copy constructor
  Organism(Organism original) {
    location = new PVector(original.location.x, original.location.y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);
    flapLikelihood = random(0.005, 0.02);
    
    mass = 1;
    size = original.size;
    fat = size;
    hungry = false;
    
    baseColor = original.baseColor;
    
    wingStrength = original.wingStrength;
    
    updateBodyProportions();
    
    randomName();
  }
  
  void randomName() {
    name = "KLAS";
  }
  
  //Update size of body parts
  void updateBodyProportions() {
      radius = size / 2;
      //wingLength = radius * 0.2;
      wingLength = radius * wingStrength * 2;
      eyeSizeL = size / 6;
      eyeSizeR = eyeSizeL;
  }
  
  //Draw it
  void draw() {
    noStroke();
    color c = baseColor;
    
    //Another color if hungry
    if (hungry) {
      c = #FF0000;
    }
    
    fill(c);
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);
    
    //Body
    ellipse(0, 0, size, size);
    
    //Wings
    stroke(c);
    strokeWeight(size/4);
    rotate(HALF_PI);
    
    //Left wing
    line(
      -radius, 0, //Wing starting point
      -radius - wingLength - 10*cos(leftWingAngle) , // X for wing end point
      10*sin(leftWingAngle)); // Y for wing end point
    
    //Right wing
    line(
      radius, 0, //Wing starting point
      radius + wingLength + 10*cos(rightWingAngle) , // X for wing end point
      10*sin(rightWingAngle));
    
    //Rotate back
    rotate(-HALF_PI);
    
    //White of the eye
    fill(0,0,0);
    strokeWeight(size/15);
    stroke(0,0,100);
    ellipse(size/4,-size/4,eyeSizeL ,eyeSizeL);
    ellipse(size/4, size/4, eyeSizeR,eyeSizeR);
    
    //Pupil
    strokeWeight(size/50);
    stroke(0,100,100);
    fill(0,100,50);
    ellipse(size/2.5,0,size/10, size/4);
    
    popMatrix();
  }
  
  //Update it
  void update() {
    moveBodyParts();
    updatePosition();
    eat();
    burnFat();
  }
  
  //Move body parts
  void moveBodyParts() {
    if (0 <= leftWingFlapping && random(1) < flapLikelihood) {
      leftWingFlapping = (int) random(20, 40);
    }
    
    if (0 <= rightWingFlapping && random(1) < flapLikelihood) {
      rightWingFlapping = (int) random(20, 40);
    }
    
    if (0 < leftWingFlapping) {
      flapLeftWing();
    }
    
    if (0 < rightWingFlapping) {
      flapRightWing();
    }
  }
  
  //Update location, velocity, angle etc.
  void updatePosition() {
    velocity.add(acceleration);
    velocity.mult(DAMPING);
    velocity.limit(MAX_SPEED);
    location.add(velocity);
    acceleration.mult(0);
    
    angularVel += angularAcc;
    angularVel *= DAMPING;
    angle += angularVel;
    angularAcc = 0;
    wrapEdges();
    
    float velMag = velocity.mag();
     // Convert polar to cartesian
    velocity.x = velMag * cos(angle);
    velocity.y = velMag * sin(angle);
  }
  
  //Flap left wing
  void flapLeftWing() {
      //leftWingAngle = sin(frameCount*size*0.01);
      leftWingAngle = sin(wingSinL*wingStrength*0.12);
      applyAngularForce(0.0002);
      PVector vector = PVector.fromAngle(angle);
      vector.mult(0.01);
      applyForce(vector);
      leftWingFlapping--;
  }
  
  //Flap right wing
  void flapRightWing() {
    rightWingAngle = sin(frameCount*size*0.01);
    applyAngularForce(-0.0002);
    PVector vector = PVector.fromAngle(angle);
    vector.mult(0.01);
    applyForce(vector);
    rightWingFlapping--;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void applyAngularForce(float af) {
    angularAcc = af / mass;
  }

  //WRAP EDGES
  void wrapEdges() {
    float margin = 0;
    // RIGHT EDGE
    if (location.x >= width + radius - margin) location.x = - radius + margin;// TO LEFT EDGE
    // DOWN EDGE
    else if (location.y >= height + radius - margin) location.y = - radius + margin;// TO TOP EDGE
    // LEFT EDGE
    else if (location.x <= - radius + margin ) location.x = width  + radius - margin;// TO RIGHT EDGE
    // TOP EDGE
    else if (location.y <= - radius + margin) location.y = height + radius - margin;// TO DOWN EDGE
  }//END WRAP EDGES
  
  //Try to find something to eat
  boolean eat() {
    for (int i = 0; i < candies.size(); i++) {
        Candy candy = (Candy)candies.get(i);
      if (dist(location.x, location.y, candy.location.x, candy.location.y) < radius) {
        fat += 10;
        if (size < fat) {
          size += 10;
          divide();
          updateBodyProportions();
        }
        candies.remove(i);
        return true;
      }
    }
    
    return false;
  }
  
  //Burn fat
  void burnFat() {
    fat -= size * 0.0000001;
    
    if (fat < size / 5) {
      hungry = true;
    } else {
      hungry = false;
    }
  }
  
  //Divide into two organisms
  void divide() {
    if (MAX_SIZE <= size) {
      size = MAX_SIZE / 4;
      fat = size;
      organisms.add(new Organism(this));
    }
  }
}



//Something to eat
class Candy {
  final float CANDY_SIZE = 20;
  
  PVector location;
  float angle;
  
  float mass = 1;
  float size;
  float radius;
  
  color baseColor;
  
  //Constructor
  Candy() {
    location = new PVector(random(width), random(height));
    angle = random(TWO_PI);
    size = CANDY_SIZE;
    
    baseColor = color(random(360), 60, 95);
  }
  
  //Draw it
  void draw() {
    noStroke();
    fill(baseColor);
    pushMatrix();
    
    translate(location.x, location.y);
    rotate(angle);
    ellipse(0, 0, size, size);
    
    popMatrix();
  }
}

float gaussianCalculator(float mean, float standardDeviation) {
  float g = (float) javaRandom.nextGaussian();
  return standardDeviation * g + mean;
}

