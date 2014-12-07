package sentient.body;

import processing.core.PVector;
import sentient.Thing;
import sentient.RandomGenerator;

public class Face {
    public float size;
    public int skinColor;
    public PVector location;
    public Eye leftEye;
    public Eye rightEye;
    public Mouth mouth;
    public float bodyAngle;
    
    /**
     * Constructor.
     */
    public Face(float s, PVector l, int irisColor) {
      size = s;
      location = new PVector(l.x, l.y);
      leftEye = new Eye(irisColor);//make gaussian
      rightEye = new Eye(irisColor);
      mouth = new Mouth(size);
      //int irisColor = color(random(120, 250), 40, 100);
      //leftEye.irisColor = irisColor;
      //rightEye.irisColor = irisColor;
    }
    
    public void update() {
      if (0.01 > Math.random() && leftEye.gazeLerp >= 1) randomGaze();
      if (0.01 > Math.random() && leftEye.dilationLerp >= 1) randomDilation();
      mouth.updateProportions(size);
      leftEye.update();
      rightEye.update();
      leftEye.bodyAngle = bodyAngle;
      rightEye.bodyAngle = bodyAngle;
    }
    
    public void updateProportions(float s) {
      size = s;
      float eyeSize = size / 4;
      float eyeX = size/4;
      float eyeY = size/4;
      leftEye.updateProportions( eyeSize, eyeX, eyeY );
      rightEye.updateProportions( eyeSize, eyeX, -eyeY );
      mouth.updateProportions(size);
    }
    
    private void randomGaze() {
      PVector targetGaze = PVector.random2D();
      float gazeLerpSpeed = RandomGenerator.getRandomInterval(0.00001f, 0.01f);
      float gazeLerp = 0;
      leftEye.targetGaze = targetGaze;
      leftEye.gazeLerpSpeed = gazeLerpSpeed;
      leftEye.gazeLerp = gazeLerp;
      rightEye.targetGaze = targetGaze;
      rightEye.gazeLerpSpeed = gazeLerpSpeed;
      rightEye.gazeLerp = gazeLerp;
    }
    
    private void randomDilation() {
      float targetDilation = RandomGenerator.getRandomInterval(0.3f, 0.7f);
      float dilationLerp = 0;
      float dilationLerpSpeed = RandomGenerator.getRandomInterval(0.00001f, 0.01f);
      leftEye.targetDilation = targetDilation;
      leftEye.dilationLerp = dilationLerp;
      leftEye.dilationLerpSpeed = dilationLerpSpeed;
      rightEye.targetDilation = targetDilation;
      rightEye.dilationLerp = dilationLerp;
      rightEye.dilationLerpSpeed = dilationLerpSpeed;
    }
    
    public PVector percieve(Thing thing) {
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
      
      if (left != null)  {
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
