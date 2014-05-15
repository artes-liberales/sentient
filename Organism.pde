//Cute little creatures
class Organism extends Thing {
  float MAX_SIZE = 150;
  float VISION = 120;
  //final float EYE_ANGLE = PI / 8;
  float EYE_ANGLE = PI / 2;

  String name;

  float fat;
  float hunger;
  boolean hungry;

  float wingLength;

  float leftWingAngle;
  float rightWingAngle;
  float leftWingFlapping = 0;
  float rightWingFlapping = 0;

  color skinColor;

  float wingStrength;
  float wingSinR, wingSinL;

  Brain brain;
  Face face;

  void setup() {
    MAX_SPEED = 50;
    DAMPING = 0.98;
    hungry = false;
    randomName();
  }
  //Constructor
  Organism(Brain brain) {
    super();
    setup(); 
    size = gaussianCalculator(MAX_SIZE / 2, MAX_SIZE / 10);
    fat = 10000;
    hunger = 0;
    skinColor = color(random(360), map(wingStrength, 0.08, 0.2, 40, 70), 95);
    wingStrength = random(0.08, 0.2);
    face = new Face(size, location);
    face.skinColor = skinColor;
    
    this.brain = brain;
    updateBodyProportions();
  }

  //Copy constructor
  private Organism(Organism original) {
    super();
    setup(); 
    location = new PVector(original.location.x, original.location.y);
    size = original.size;
    MAX_SPEED = 50;
    DAMPING = 0.98;
    fat = size;
    hungry = false;
    skinColor = original.skinColor;
    wingStrength = original.wingStrength;
    face = new Face(size, location);
    face.skinColor = original.skinColor;
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
    face.updateProportions(size);
    mass = size * 0.1;
    radius = size / 2;
    wingLength = radius * wingStrength * 2;
  }

  //Draw it
  void draw() {

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



    //Wings
    stroke(c);
    strokeWeight(size/4);
    //rotate(HALF_PI);

    //Left wing
    line(
    0, -radius, //Wing starting point    
    wingLength * sin(leftWingAngle ), // Y for wing end point
    -radius - wingLength * cos(leftWingAngle ) // X for wing end point
    ); 

    //Right wing
    line(
    0, radius, //Wing starting point
    wingLength * sin(rightWingAngle), 
    radius + wingLength * cos(rightWingAngle) // X for wing end point
    );

    face.draw();
    popMatrix();
  }

  //Update it
  void update() {
    
    face.leftEye.locationT = new PVector(location.x, location.y);
    face.rightEye.locationT = new PVector(location.x, location.y);
    face.bodyAngle = angle;
    face.update();
    percieve();
    moveBodyParts();
    //eat();
    burnFat();
    super.update();
  }
  void percieve() {
    //float[] inputSignal = face.percieve();
    //float[] outputSignal = brain.think(inputSignal);
  }
  //Move body parts
  void moveBodyParts() {    
    // Percieve, could theese be ivars instead?
    //pushMatrix();
    
    //translate(location.x, location.y);
    //rotate(angle);
    float[] inputSignal = lookForFood();
    //popMatrix();
    //float[] inputSignal = lookFoorFood();
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
          //candy.spotted = true;
        } 
        else if (Math.abs(rightTheta) < EYE_ANGLE) {
          inputSignal[1] = 1;
          //candy.spotted = true;
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

  float[] lookForFood() {
    //Signal that is to be sent as input to the brain
    float[] inputSignal = new float[3];

    for (int i = 0; i < candies.size(); i++) {
      Candy candy = (Candy)candies.get(i);

      PVector candySeen = face.percieve(candy);
      if (candySeen != null) {//deterimine angle in relation to body to send input
        //angle - 
        inputSignal[0] = 1;
        inputSignal[1] = 1;
        if (face.inMouth) {
          eat2();
          candies.remove(i);
          face.inMouth = false;
        }
      }
    }
    return inputSignal;
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
      size = MAX_SIZE / 2;
      fat = size;
      organisms.add(new Organism(this));
    }
  }
}



class Wing {
}

class BrainVisual {
}

