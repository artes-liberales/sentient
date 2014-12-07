package sentient.body;

import processing.core.PVector;
import sentient.Sentient;
import sentient.RandomGenerator;

public class Eye {
    public PVector location;
    public PVector locationT;
    public float eyeSize;
    public float irisSize;
    public float inherentPupilSize;
    public float pupilSize;
    public float dilation;
    public float targetDilation;
    public float dilationLerp;
    public float dilationLerpSpeed;
    public PVector gaze;
    public float inherentVisionLength;
    public float inherentVisionBreadth; // an angle
    public float visionLength; // could get modified by gaze
    public float visionBreadth;
    public PVector targetGaze; // or maybe Vector
    public int irisColor;
    public float gazeLerp;
    public float gazeLerpSpeed;
    public float visionStartAngle;
    public float visionStopAngle;
    public float visionScope;
    public float visionBreadthA;
    public float bodyAngle;
    public boolean inMouth = false;
    
    /**
     * Constructor.
     */
    public Eye(int irisColor) {
        location = new PVector(0, 0);
        locationT = new PVector(0, 0);
        gaze = new PVector(0f, 0.5f);
        //whiteColor = color(0, 0, 100);
        //pupilColor = color(0, 0, 20);
        dilation = 0.6f;
        // update();
        gazeLerp = 1;
        dilationLerp = 1;
        targetGaze = gaze;
        visionBreadth = Sentient.pi / 1.3f;
        this.irisColor = irisColor;
    }
    
    public void update(float bodyAngle) {
        this.bodyAngle = bodyAngle;
        if (0.01 > Math.random() && gazeLerp >= 1)
            randomGaze();
        if (gazeLerp < 1)
            lerpGaze();
        // if( 0.01 > random(1) && dilationLerp >= 1) randomDilation();
        if (dilationLerp < 1)
            lerpDilation();
        calculateVisionScope();
    }
    
    public void updateProportions(float s, float x, float y) {
        eyeSize = s;
        location.x = x;
        location.y = y;
        irisSize = eyeSize / 1.3f;
        pupilSize = irisSize * dilation;
        visionLength = eyeSize * 10;
    }
    
    private void calculateVisionScope() {
        float eyeAngle = gaze.heading();
        float eyeZ = gaze.mag();
        visionBreadthA = visionBreadth / (eyeZ * 3);
        visionStartAngle = eyeAngle - visionBreadthA; // start
        visionStopAngle = eyeAngle + visionBreadthA;// stop
        visionScope = eyeSize + visionLength * gaze.mag();// length
    }
    
    public PVector thingInVisionScope(float x, float y) {
      float distanceToThing = Sentient.getDist(locationT.x+location.x, locationT.y+location.x, x, y);
      //loat distanceToThing = dist(0, 0, x, y);
      
      //pupilColor = #000000;
      if (distanceToThing < visionScope/2) {
        PVector thingDirection = new PVector(x - locationT.x+location.x, y - locationT.y+location.x);
        //PVector thingDirection = new PVector(x - 0, y - 0);
        float  gazeAngle = gaze.heading() + bodyAngle;
        PVector trueGazeVector = PVector.fromAngle(gazeAngle);
        
        float angleToThing = PVector.angleBetween(thingDirection, trueGazeVector);
        //line(0,0, x, y);
        //line(locationT.x+location.x, locationT.y+location.x, x, y);
        //pupilColor = #000000;
        if (Sentient.abs(angleToThing) < visionBreadthA  ) {
          //pupilColor = #FF0000;
          //println(bodyAngle);
          return thingDirection;
        }
      }
      
      return null;
    }
    
    /*public void drawVisionArea() {
        // float eyeAngle = gaze.heading();
        // float eyeZ = gaze.mag();
        // float[] visionArea = getVisionScope();
        fill(255, 0, 100, dilation * 100);
        // strokeWeight(0.5);
        // noFill();
        // stroke(255, 0, 100);
        // arc(0, 0, size+visionLength*eyeZ, size+visionLength*eyeZ,
        // eyeAngle-visionBreadth/2, eyeAngle+visionBreadth/2, PIE);
        arc(0, 0, visionScope, visionScope, visionStartAngle, visionStopAngle, PIE);
    }*/
    
    private void randomGaze() {
        targetGaze = PVector.random2D();
        gazeLerpSpeed = RandomGenerator.getRandomInterval(0.001f, 0.01f);
        gazeLerp = 0;
    }
    
    private void fixGaze() {
    }
    
    private void lerpGaze() {
        gaze.lerp(targetGaze, gazeLerp);
        gazeLerp += gazeLerpSpeed;
    }
    
    private void randomDilation() {
        targetDilation = RandomGenerator.getRandomInterval(0.3f, 0.7f);
        dilationLerp = 0;
        dilationLerpSpeed = RandomGenerator.getRandomInterval(0.001f, 0.01f);
    }
    
    private void lerpDilation() {
        dilation = Sentient.getLerp(dilation, targetDilation, dilationLerp);
        dilationLerp += dilationLerpSpeed;
        pupilSize = irisSize * dilation;
    }
}
