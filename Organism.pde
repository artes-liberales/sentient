//Cute little creatures
class Organism {
  final float MAX_SIZE = 100;
  final float MAX_SPEED = 50;
  final float DAMPING = 0.98;
  final float VISION = 120;
  final float EYE_ANGLE = PI / 8;
  
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
  
  color baseColor;
  float eyeSizeL, eyeSizeR;
  
  float wingStrength;
  float wingSinR,wingSinL;
  float targetGazeAngle; //or maybe Vector
  
  Brain brain;
  
  //Constructor
  Organism(Brain brain) {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);
    
    mass = 1;
    size = random(MAX_SIZE / 3, MAX_SIZE);
    fat = 10000;
    hungry = false;
    
    baseColor = color(random(360), map(wingStrength,0.08,0.2, 40, 70), 95);
    
    wingStrength = random(0.08,0.2);
    
    updateBodyProportions();
    
    randomName();
    
    this.brain = brain;
  }
  
  //Copy constructor
  Organism(Organism original) {
    location = new PVector(original.location.x, original.location.y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);
    
    mass = 1;
    size = original.size;
    fat = size;
    hungry = false;
    
    baseColor = original.baseColor;
    
    wingStrength = original.wingStrength;
    
    updateBodyProportions();
    
    randomName();
    
    brain = original.getBrain().clone();
  }
  
  Brain getBrain() {
    return brain;
  }

  void randomName() {
    name = "KLAS";
  }

  //Update size of body parts
  void updateBodyProportions() {
    mass = size * 0.05;
    radius = size / 2;
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
      -radius - wingLength * cos(leftWingAngle) , // X for wing end point
      wingLength * sin(leftWingAngle)); // Y for wing end point
    
    //Right wing
    line(
      radius, 0, //Wing starting point
      radius + wingLength * cos(rightWingAngle) , // X for wing end point
      wingLength * sin(rightWingAngle));
    
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
    //ellipse(size/2.5,0,size/10, size/4);
    ellipse(size/2.5,0,size/30+velocity.mag()*2, size/10+velocity.mag()*3);
    
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
    float[] inputSignal = lookFoorFood();
    float[] outputSignal = brain.think(inputSignal);
    
    if (0 <= leftWingFlapping && 1 == outputSignal[0]) {
      leftWingFlapping = (int) random(5, 60);
    }
    
    if (0 <= rightWingFlapping && 1 == outputSignal[1]) {
      rightWingFlapping = (int) random(5, 60);
    }
    
    if (0 < leftWingFlapping) {
      flapLeftWing();
    }
    
    if (0 < rightWingFlapping) {
      flapRightWing();
    }
  }
  
  //See if there is food in front of the organism
  //inputSignal[0] == 1 means that there is food to the left
  //inputSignal[1] == 1 means that there is food to the right
  //There can be food both to the left and to the right
  float[] lookFoorFood() {
    //Signal that is to be sent as input to the brain
    float[] inputSignal = new float[2];

    //The angles that the eyes are looking in    
    float leftEyeAngle = angle - EYE_ANGLE;
    float rightEyeAngle = angle + EYE_ANGLE;
    
    //Directions that the eyes are looking in   
    PVector leftEyeLookingDirection = new PVector(VISION * cos(leftEyeAngle), VISION * sin(leftEyeAngle));
    PVector rightEyeLookingDirection = new PVector(VISION * cos(rightEyeAngle), VISION * sin(rightEyeAngle));
    
    for (int i = 0; i < candies.size(); i++) {
      Candy candy = (Candy)candies.get(i);
      float candyX = candy.location.x;
      float candyY = candy.location.y;
      
      //Consider wrapping of screen edges
      if (width / 2 < location.x - candyX) {
        candyX += width;
      } else if (width / 2 < candyX - location.x) {
        candyX -= width;
      }
      
      if (height / 2 < location.y - candyY) {
        candyY += height;
      } else if (height / 2 < candyY - location.y) {
        candyY -= height;
      }
      
      //Check if food is in field of vision
      if (dist(location.x, location.y, candyX, candyY) < VISION) {
        PVector foodDirection = new PVector(candyX - location.x, candyY - location.y);
        
        //Angles between eye looking directions and food direction
        float leftTheta = (float) Math.acos(leftEyeLookingDirection.dot(foodDirection)
            / (leftEyeLookingDirection.mag() * foodDirection.mag()));
        float rightTheta = (float) Math.acos(rightEyeLookingDirection.dot(foodDirection)
            / (rightEyeLookingDirection.mag() * foodDirection.mag()));
        
        //Determine if food is in left or right field of vision
        if (Math.abs(leftTheta) < EYE_ANGLE) {
          inputSignal[0] = 1;
        } else if (Math.abs(rightTheta) < EYE_ANGLE) {
          inputSignal[1] = 1;
        }
      }
    }
    
    return inputSignal;
  }
  
  //Update location, velocity, angle etc.
  void updatePosition() {
    velocity.add(acceleration);
    velocity.mult(DAMPING);
    velocity.limit(MAX_SPEED);
    location.add(velocity);
    acceleration.mult(0);
    
    //Rewind angle so that it is between 0 and 2 * PI
    if (TWO_PI < angle) {
      angle -= TWO_PI;
    } else if (angle < 0) {
      angle += TWO_PI;
    }
    
    angularVel += angularAcc;
    angularVel *= DAMPING;
    angle += angularVel;
    angularAcc = 0;
    wrapEdges();
  }
  
  //Flap left wing
  void flapLeftWing() {
      leftWingAngle = sin(wingSinL * wingStrength * 0.12);
      float flapStrengthL = wingStrength * leftWingFlapping / 40 + leftWingAngle * 0.05;
      applyAngularForce(flapStrengthL / 50);
      PVector vector = PVector.fromAngle(angle);
      vector.mult(flapStrengthL);
      applyForce(vector);
      leftWingFlapping--;
      wingSinL += leftWingFlapping;
  }
  
  //Flap right wing
  void flapRightWing() {
    rightWingAngle = sin(wingSinR * wingStrength * 0.12);
    float flapStrengthR = wingStrength * rightWingFlapping / 40 + rightWingAngle * 0.05;
    applyAngularForce(-flapStrengthR / 50);
    PVector vector = PVector.fromAngle(angle);
    vector.mult(flapStrengthR);
    applyForce(vector);
    rightWingFlapping--;
    wingSinR += rightWingFlapping;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void applyAngularForce(float af) {
    angularAcc += af / mass;
  }

  //WRAP EDGES
  void wrapEdges() {
    float margin = 0;
    // RIGHT EDGE
    if (location.x >= width + radius - margin) {
      location.x = - radius + margin;// TO LEFT EDGE
    }
    // DOWN EDGE
    else if (location.y >= height + radius - margin) {
      location.y = - radius + margin;// TO TOP EDGE
    }
    // LEFT EDGE
    else if (location.x <= - radius + margin) {
      location.x = width  + radius - margin;// TO RIGHT EDGE
    }
    // TOP EDGE
    else if (location.y <= - radius + margin) {
      location.y = height + radius - margin;// TO DOWN EDGE
    }
  }
  
  void displayData(String data) {
    fill(0,0,100);
    text(data, 0, 0);
  }

  //Eat food that is inside body radius
  boolean eat() {
    for (int i = 0; i < candies.size(); i++) {
      Candy candy = (Candy)candies.get(i);
      
      if (dist(location.x, location.y, candy.location.x, candy.location.y) < radius) {
        fat += 10;
        
        //Grow and divide
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
    fat -= size * 0.0001;
    
    if (fat < size / 5) {
      hungry = true;
    } else {
      hungry = false;
    }
  }
  
  //Divide into two organisms
  void divide() {
    if (MAX_SIZE <= size) {
      size = MAX_SIZE / 3;
      fat = size;
      organisms.add(new Organism(this));
    }
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

