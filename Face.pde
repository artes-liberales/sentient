class Face {
  float size;
  color skinColor;
  PVector location;
  Eye leftEye;
  Eye rightEye;
  Mouth mouth;
  boolean inMouth;
  float bodyAngle;
  Face(float s, PVector l) {
    size = s;
    location = new PVector(l.x, l.y);
    leftEye = new Eye();//make gaussian
    rightEye = new Eye();
    mouth = new Mouth();
    color irisColor = color(random(120, 250), 40, 100);
    leftEye.irisColor = irisColor;
    rightEye.irisColor = irisColor;
  }
  void update() {
    if ( 0.01 > random(1) && leftEye.gazeLerp >= 1) randomGaze();
    if ( 0.01 > random(1) && leftEye.dilationLerp >= 1) randomDilation();
    leftEye.update();
    rightEye.update();
    leftEye.bodyAngle = bodyAngle;
    rightEye.bodyAngle = bodyAngle;
  }
  void updateProportions(float s) {
    size = s;
    float eyeSize = size / 4;
    float eyeX = size/4;
    float eyeY = size/4;
    leftEye.updateProportions( eyeSize, eyeX, eyeY );
    rightEye.updateProportions( eyeSize, eyeX, -eyeY );
    mouth.updateProportions(size);
  }
  void draw() {

    //Body
    noStroke();
    fill(skinColor);
    ellipse(0, 0, size, size);
    //Mouth
    strokeWeight(size/50);
    stroke(0, 100, 100);
    fill(0, 100, 50);
    //ellipse(size/2.5,0,size/10, size/4);
    ellipse(size/2.5, 0, size/15, size/5);


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
    float targetDilation = random(0.3, 0.7);
    float dilationLerp = 0;
    float dilationLerpSpeed = random(0.01, 0.00001);
    leftEye.targetDilation = targetDilation;
    leftEye.dilationLerp = dilationLerp;
    leftEye.dilationLerpSpeed = dilationLerpSpeed;
    rightEye.targetDilation = targetDilation;
    rightEye.dilationLerp = dilationLerp;
    rightEye.dilationLerpSpeed = dilationLerpSpeed;
  }
  PVector percieve(Thing thing) {
    float thingX = thing.location.x;
    float thingY = thing.location.y;

    //Consider wrapping of screen edges
    /*
    if (width / 2 < location.x - thingX) {
     thingX += width;
     } 
     else if (width / 2 < thingX - location.x) {
     thingX -= width;
     }
     if (height / 2 < location.y - thingY) {
     thingY += height;
     } 
     else if (height / 2 < thingY - location.y) {
     thingY -= height;
     }
     */
    //make into eye code, to check both eyes separately
    //float distanceToThing = dist(location.x, location.y, thingX, thingY);
    //if (oncePerFrame == frameCount) {
    //leftEyeVision = leftEye.getVisionScope();
    //rightEyeVision = rightEye.getVisionScope();
    //oncePerFrame++;
    //}
    //if (distanceToThing < leftEyeVision[2]) {

    //  return new PVector(thingX - location.x, thingY - location.y);

    //}
    
    PVector left = leftEye.thingInVisionScope(thingX, thingY);
    PVector right = rightEye.thingInVisionScope(thingX, thingY);
    if (left != null) 
    {
      thing.spotted = true;
      return left;
    }
    if (right != null) {
      thing.spotted = true;
      return right;
    }
    return null;
  }
}


