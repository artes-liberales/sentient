class Eye {
  PVector location;
  PVector locationT;
  float eyeSize;
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
  float visionStartAngle;
  float visionStopAngle;
  float visionScope;
  float visionBreadthA;
  float bodyAngle;
  boolean inMouth = false;

  Eye() {
    location = new PVector(0, 0);
    locationT = new PVector(0, 0);
    gaze = new PVector(0, 0.5);
    whiteColor = color(0, 0, 100);
    pupilColor = color(0, 0, 20);
    dilation = 0.6;
    //update();
    gazeLerp = 1;
    dilationLerp = 1;
    targetGaze = gaze;
    visionBreadth = PI/1.3;
  }

  void update() {
    if( 0.01 > random(1) && gazeLerp >= 1) randomGaze();
    if (gazeLerp < 1) lerpGaze();
    //if( 0.01 > random(1) && dilationLerp >= 1) randomDilation();
    if (dilationLerp < 1) lerpDilation();
    calculateVisionScope();
  }
  void updateProportions(float s, float x, float y) {
    eyeSize = s;
    location.x = x;
    location.y = y;
    irisSize = eyeSize / 1.3;
    pupilSize = irisSize*dilation;
    visionLength = eyeSize*10;
  }

  void draw() {
    noStroke();

    //White of the eye
    fill(whiteColor);
    ellipse(location.x, location.y, eyeSize, eyeSize);  
    //Iris
    pushMatrix();
    translate(location.x+gaze.x*eyeSize/6, location.y+gaze.y*eyeSize/6);
    drawVisionArea();
    noStroke();
    fill(irisColor);
    ellipse(0, 0, irisSize, irisSize); 
    //Pupil
    fill(pupilColor);
    ellipse(0, 0, pupilSize, pupilSize); 
    popMatrix();
  }
  void calculateVisionScope() {
    float eyeAngle = gaze.heading();
    float eyeZ = gaze.mag();
    visionBreadthA = visionBreadth/(eyeZ*3);
    visionStartAngle = eyeAngle-visionBreadthA; //start
    visionStopAngle = eyeAngle+visionBreadthA;//stop
    visionScope = eyeSize+visionLength*gaze.mag();//length
  }
  PVector thingInVisionScope( float x, float y ) {

    float distanceToThing = dist(locationT.x+location.x, locationT.y+location.x, x, y);
    //loat distanceToThing = dist(0, 0, x, y);


    //pupilColor = #000000;
    if (distanceToThing < visionScope/2) {

      PVector thingDirection = new PVector(x - locationT.x+location.x, y - locationT.y+location.x);
      //PVector thingDirection = new PVector(x - 0, y - 0);
      float  gazeAngle = gaze.heading()+bodyAngle;
      PVector trueGazeVector = PVector.fromAngle(gazeAngle);

      float angleToThing = PVector.angleBetween(thingDirection, trueGazeVector);
      //line(0,0, x, y);
      line(locationT.x+location.x, locationT.y+location.x, x, y);
      pupilColor = #000000;
      if (abs(angleToThing) < visionBreadthA  ) {
        //pupilColor = #FF0000;

        println(bodyAngle);
        return thingDirection;
      }
      
    }

    return null;
  }
  void drawVisionArea() {
    //float eyeAngle = gaze.heading();
    //float eyeZ = gaze.mag();
    //float[] visionArea = getVisionScope();
    fill(255, 0, 100, dilation*100);
    //strokeWeight(0.5);
    //noFill();
    //stroke(255, 0, 100);
    //arc(0, 0, size+visionLength*eyeZ, size+visionLength*eyeZ, eyeAngle-visionBreadth/2, eyeAngle+visionBreadth/2, PIE);
    arc(0, 0, visionScope, visionScope, visionStartAngle, visionStopAngle, PIE);
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
    targetDilation = random(0.3, 0.7);
    dilationLerp = 0;
    dilationLerpSpeed = random(0.01, 0.001);
  }
  void lerpDilation() {
    dilation = lerp(dilation, targetDilation, dilationLerp);
    dilationLerp += dilationLerpSpeed;
    pupilSize = irisSize*dilation;
  }
}
