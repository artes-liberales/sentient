//Cute little creatures
class Organism {
  final float MAX_SIZE = 100;
  final float MAX_SPEED = 50;
  final float DAMPING = 0.98;
  final float VISION = 120;
  //final float EYE_ANGLE = PI / 8;
  final float EYE_ANGLE = PI / 2;

  String name;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float angle;
  float angularVel;
  float angularAcc;

  float fat;
  float hunger;
  boolean hungry;

  float mass = 1;
  float size;
  float radius;
  float wingLength;

  float leftWingAngle;
  float rightWingAngle;
  float leftWingFlapping = 0;
  float rightWingFlapping = 0;

  color skinColor;
  float eyeSizeL, eyeSizeR;

  float wingStrength;
  float wingSinR, wingSinL;

  Brain brain;
  
  Face face;
  
  //Constructor
  Organism(Brain brain) {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);

    mass = 1;
    size = random(MAX_SIZE / 2, MAX_SIZE);
    fat = 10000;
    hunger = 0;
    hungry = false;

    skinColor = color(random(360), map(wingStrength, 0.08, 0.2, 40, 70), 95);

    wingStrength = random(0.08, 0.2);

    face = new Face(size);
    
    randomName();
  
    this.brain = brain;
    updateBodyProportions();
  }

  //Copy constructor
  private Organism(Organism original) {
    location = new PVector(original.location.x, original.location.y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);

    mass = 1;
    size = original.size;
    fat = size;
    hungry = false;

    skinColor = original.skinColor;

    wingStrength = original.wingStrength;

    face = new Face(size);
    randomName();

    brain = original.getBrain().clone();
    updateBodyProportions();
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
    face.updateProportions(size);
    
  }

  //Draw it
  void draw() {
    noStroke();
    color c = skinColor;

    //Another color if hungry
    if (hungry) {
      c = #FF0000;
    }


    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);

    //Vision
    //fill(255, 0, 100, 50);
    //ellipse(0, 0, size+VISION, size+VISION);
    //arc(0, 0, size+VISION, size+VISION, -EYE_ANGLE, EYE_ANGLE, PIE);

    //Body
    fill(c);
    ellipse(0, 0, size, size);

    //Wings
    stroke(c);
    strokeWeight(size/4);
    //rotate(HALF_PI);

    //Left wing
    line(
    0, -radius, //Wing starting point    
    wingLength * sin(leftWingAngle ),// Y for wing end point
    -radius - wingLength * cos(leftWingAngle ) // X for wing end point
    ); 

    //Right wing
    line(
    0, radius, //Wing starting point
    wingLength * sin(rightWingAngle),
    radius + wingLength * cos(rightWingAngle) // X for wing end point
    );

    //Rotate back
    //rotate(-HALF_PI);

    //White of the eye
    //fill(0, 0, 0);
    //strokeWeight(size/15);
    //stroke(0, 0, 100);
    //ellipse(size/4, -size/4, eyeSizeL, eyeSizeL);
    //ellipse(size/4, size/4, eyeSizeR, eyeSizeR);

    //Mouth
    strokeWeight(size/50);
    stroke(0, 100, 100);
    fill(0, 100, 50);
    //ellipse(size/2.5,0,size/10, size/4);
    ellipse(size/2.5, 0, size/30, size/10);
    
    face.draw();
    popMatrix();
    
  }

  //Update it
  void update() {
    face.update();
    percieve();
    moveBodyParts();
    updatePosition();
    //eat();
    burnFat();
    
  }
  void percieve() {
    float[] inputSignal = face.percieve();
    //float[] outputSignal = brain.think(inputSignal);
  }
  //Move body parts
  void moveBodyParts() {    
    // Percieve, could theese be ivars instead?
    float[] inputSignal = lookFoorFood();
    float[] outputSignal = brain.think(inputSignal);
    if (0 <= leftWingFlapping && 1 <= outputSignal[0]) {
      leftWingFlapping = (int) random(5, 60);
      leftWingFlapping = 30;
    }

    if (0 <= rightWingFlapping && 1 <= outputSignal[1]) {
      rightWingFlapping = (int) random(5, 60);
      rightWingFlapping = 30;
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
    float[] inputSignal = new float[3];

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
      } 
      else if (width / 2 < candyX - location.x) {
        candyX -= width;
      }

      if (height / 2 < location.y - candyY) {
        candyY += height;
      } 
      else if (height / 2 < candyY - location.y) {
        candyY -= height;
      }

      //Check if food is in field of vision
      float distanceToCandy = dist(location.x, location.y, candyX, candyY);
      if (distanceToCandy < VISION) {


        PVector foodDirection = new PVector(candyX - location.x, candyY - location.y);

        //Angles between eye looking directions and food direction
        float leftTheta = (float) Math.acos(leftEyeLookingDirection.dot(foodDirection)
          / (leftEyeLookingDirection.mag() * foodDirection.mag()));
        float rightTheta = (float) Math.acos(rightEyeLookingDirection.dot(foodDirection)
          / (rightEyeLookingDirection.mag() * foodDirection.mag()));

        //Determine if food is in left or right field of vision

        if (Math.abs(leftTheta) < EYE_ANGLE) {
          inputSignal[0] = 1;
        } 
        else if (Math.abs(rightTheta) < EYE_ANGLE) {
          inputSignal[1] = 1;
        }
        if (distanceToCandy < radius) {
          eat2();
          candies.remove(i);
        }
      }
    }

    inputSignal[2] = hunger;

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
    } 
    else if (angle < 0) {
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
    fill(0, 0, 100);
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

  void eat2() {

    fat += 10;

    //Grow and divide
    if (size < fat) {
      size += 10;
      divide();
      updateBodyProportions();
    }

  }


//Burn fat
void burnFat() {
  fat -= size * 0.0002;

  if (0 < leftWingFlapping) {
    fat -= size * 0.0001;
  }

  if (0 < rightWingFlapping) {
    fat -= size * 0.0001;
  }

  hunger = 1 - fat / size;

  if (fat < size / 5) {
    hungry = true;
  } 
  else {
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

class Face {
  float size;
  Eye leftEye;
  Eye rightEye;
  Mouth mouth;
  Face(float s) {
    size = s;
    leftEye = new Eye();//make gaussian
    rightEye = new Eye();
    color irisColor = color(random(120,250), 40, 100);
    leftEye.irisColor = irisColor;
    rightEye.irisColor = irisColor;
  }
  void update() {
    if( 0.01 > random(1) && leftEye.gazeLerp >= 1) randomGaze();
    if( 0.01 > random(1) && leftEye.dilationLerp >= 1) randomDilation();
    leftEye.update();
    rightEye.update();
  }
  void updateProportions(float s) {
  size = s;
  float eyeSize = size / 3.5;
  float eyeX = size/4;
  float eyeY = size/4;
  leftEye.updateProportions( eyeSize,eyeX,eyeY );
  rightEye.updateProportions( eyeSize,eyeX,-eyeY );
  }
  void draw() {
    leftEye.draw();
    rightEye.draw();
  }
  void randomGaze() {
    PVector targetGaze = PVector.random2D();
    float gazeLerpSpeed = random(0.01, 0.00001);
    float gazeLerp = 0;
    leftEye.targetGaze = targetGaze;
    leftEye.gazeLerpSpeed = gazeLerpSpeed;
    leftEye.gazeLerp = gazeLerp;
    rightEye.targetGaze = targetGaze;
    rightEye.gazeLerpSpeed = gazeLerpSpeed;
    rightEye.gazeLerp = gazeLerp;
  }
  void randomDilation() {
  float targetDilation = random(0.3,0.7);
  float dilationLerp = 0;
  float dilationLerpSpeed = random(0.01, 0.00001);
  leftEye.targetDilation = targetDilation;
  leftEye.dilationLerp = dilationLerp;
  leftEye.dilationLerpSpeed = dilationLerpSpeed;
  rightEye.targetDilation = targetDilation;
  rightEye.dilationLerp = dilationLerp;
  rightEye.dilationLerpSpeed = dilationLerpSpeed;
  }
  float[] percieve() {
  return  null;
  }
}

class Eye {
  PVector location;
  float size;
  float irisSize;
  float inherentPupilSize;
  float pupilSize;
  float dilation;
  float targetDilation;
  float dilationLerp;
  float dilationLerpSpeed;
  PVector gaze;
  float inherentVisionLength; 
  float inherentVisionBreadth; // an angle 
  float visionLength; //could get modified by gaze
  float visionBreadth; 
  PVector targetGaze; //or maybe Vector
  color irisColor;
  color whiteColor;
  color pupilColor;
  float gazeLerp;
  float gazeLerpSpeed;
   
  
  Eye() {
    location = new PVector(0,0);
    gaze = new PVector(0,0.5);
    whiteColor = color(0,0,100);
    pupilColor = color(0,0,20);
    dilation = 0.6;
    //update();
    gazeLerp = 1;
    dilationLerp = 1;
    targetGaze = gaze;
    
  }

  void update() {
    //if( 0.01 > random(1) && gazeLerp >= 1) randomGaze();
    if(gazeLerp < 1) lerpGaze();
    //if( 0.01 > random(1) && dilationLerp >= 1) randomDilation();
    if(dilationLerp < 1) lerpDilation();
  }
  void updateProportions(float s, float x, float y) {
    size = s;
    location.x = x;
    location.y = y;
    irisSize = size / 1.3;
    pupilSize = irisSize*dilation;
    visionLength = size*10;
    visionBreadth = HALF_PI;
  }
  
  void draw() {
    noStroke();
    
    //White of the eye
    fill(whiteColor);
    ellipse(location.x,location.y,size ,size);  
    //Iris
    pushMatrix();
    translate(location.x+gaze.x*size/6,location.y+gaze.y*size/6);
    drawVisionArea();
    noStroke();
    fill(irisColor);
    ellipse(0,0,irisSize ,irisSize); 
    //Pupil
    fill(pupilColor);
    ellipse(0,0, pupilSize , pupilSize); 
    popMatrix();
  }
  float[] getVisionArea() {
  return null;
  }
  void drawVisionArea() {
    float eyeAngle = gaze.heading();
    float eyeZ = gaze.mag();
    //fill(255, 0, 100, dilation*100);
    strokeWeight(0.5);
    noFill();
    stroke(255, 0, 100);
    arc(0, 0, size+visionLength*eyeZ, size+visionLength*eyeZ, eyeAngle-visionBreadth/2, eyeAngle+visionBreadth/2, PIE);
  }
  void randomGaze() {
    targetGaze = PVector.random2D();
    gazeLerpSpeed = random(0.01, 0.001);
    gazeLerp = 0;
  }
  
  void fixGaze() {
  }
  void lerpGaze() {
    gaze.lerp(targetGaze, gazeLerp);
    gazeLerp += gazeLerpSpeed;
    
  }
  void randomDilation() {
  targetDilation = random(0.3,0.7);
  dilationLerp = 0;
  dilationLerpSpeed = random(0.01, 0.001);
  }
  void lerpDilation() {
  dilation = lerp(dilation, targetDilation, dilationLerp);
  dilationLerp += dilationLerpSpeed;
  pupilSize = irisSize*dilation;
  }
}

class Mouth {
}

class Wing {
  
}

class BrainVisual {
}

