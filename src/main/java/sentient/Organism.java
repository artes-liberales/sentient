package sentient;

import java.util.List;

import processing.core.PVector;
import sentient.body.Face;
import sentient.brain.Brain;
import sentient.food.Candy;

public class Organism extends Thing {
    public static final float MAX_SIZE = 100;
    public static final float VISION = 120;
    public static final float EYE_ANGLE = Sentient.pi / 2;
    
    public String name;
    public float size;
    public float fat;
    public int skinColor;
    
    public float wingLength;
    public float leftWingAngle;
    public float rightWingAngle;
    private float leftWingFlapping;
    private float rightWingFlapping;
    private float wingStrength;
    private float wingSinR;
    private float wingSinL;
    
    private Brain brain;
    public Face face;
    
    /**
     * Constructor.
     */
    public Organism(Brain brain, float wingStrength, int skinColor, int irisColor) {
        super();
        randomName();
        size = RandomGenerator.gaussianCalculator(MAX_SIZE / 2, MAX_SIZE / 10);
        fat = size;
        this.wingStrength = wingStrength;
        this.skinColor = skinColor;
        face = new Face(size, location, irisColor);
        face.skinColor = skinColor;
        
        this.brain = brain;
        updateBodyProportions();
    }
    
    /**
     * Copy constructor.
     */
    private Organism(Organism original) {
        super();
        randomName();
        location = new PVector(original.location.x, original.location.y);
        size = original.size / 4;
        fat = size;
        skinColor = original.skinColor;
        wingStrength = original.wingStrength;
        face = new Face(size, location, original.face.leftEye.irisColor);
        face.skinColor = original.skinColor;
        brain = original.getBrain().clone();
        updateBodyProportions();
    }
    
    public Brain getBrain() {
        return brain;
    }
    
    public float getHunger() {
        return 1 - fat / size;
    }
    
    public void randomName() {
        name = "KLAS";
    }
    
    /**
     * Update size of body parts.
     */
    private void updateBodyProportions() {
        face.updateProportions(size, getHunger());
        mass = size * 0.1f;
        radius = size / 2;
        wingLength = radius * wingStrength * 2;
    }
    
    /**
     * Encompasses everything the organism does.
     */
    public void update(List<Candy> candies) {
        face.leftEye.locationT = new PVector(location.x, location.y);
        face.rightEye.locationT = new PVector(location.x, location.y);
        face.update(angle, getHunger());
        
        float[] inputSignal = lookForFood(candies);
        float[] outputSignal = brain.think(inputSignal);
        moveBodyParts(outputSignal);
        eat();
        burnFat();
        super.update();
    }
    
    /**
     * Move body parts.
     */
    private void moveBodyParts(float[] outputSignal) {
        if (1 <= outputSignal[0]) {
            leftWingFlapping = 30;
        }
        
        if (1 <= outputSignal[1]) {
            rightWingFlapping = 30;
        }
        
        if (0 < leftWingFlapping) {
            flapLeftWing();
        }
        
        if (0 < rightWingFlapping) {
            flapRightWing();
        }
    }
    
    /**
     * Look for food in front of the organism
     * to create the input signal to the brain.
     * inputSignal[0] == 1 means that there is food to the left
     * inputSignal[1] == 1 means that there is food to the right
     * There can be food both to the left and to the right
     */
    private float[] lookForFood(List<Candy> candies) {
        // Signal that is to be sent as input to the brain
        float[] inputSignal = new float[3];
        
        // Angles that the eyes are looking in
        float leftEyeAngle = angle - EYE_ANGLE;
        float rightEyeAngle = angle + EYE_ANGLE;
        
        // Directions that the eyes are looking in
        PVector leftEyeLookingDirection = new PVector(VISION * Sentient.getCos(leftEyeAngle), VISION * Sentient.getCos(leftEyeAngle));
        PVector rightEyeLookingDirection = new PVector(VISION * Sentient.getCos(rightEyeAngle), VISION * Sentient.getSin(rightEyeAngle));
        
        for (int i = 0; i < candies.size(); i++) {
            Candy candy = (Candy) candies.get(i);
            float candyX = candy.location.x;
            float candyY = candy.location.y;
            
            // Consider wrapping of screen edges
            if (Sentient.MAP_WIDTH / 2 < location.x - candyX) {
                candyX += Sentient.MAP_WIDTH;
            } else if (Sentient.MAP_WIDTH / 2 < candyX - location.x) {
                candyX -= Sentient.MAP_WIDTH;
            }
            
            if (Sentient.MAP_HEIGHT / 2 < location.y - candyY) {
                candyY += Sentient.MAP_HEIGHT;
            } else if (Sentient.MAP_HEIGHT / 2 < candyY - location.y) {
                candyY -= Sentient.MAP_HEIGHT;
            }
            
            // Check if food is in field of vision
            float distanceToCandy = Sentient.dist(location.x, location.y, candyX, candyY);
            if (radius <= distanceToCandy && distanceToCandy < VISION) {
                PVector foodDirection = new PVector(candyX - location.x, candyY - location.y);
                
                // Angles between eye looking directions and food direction
                float leftTheta = (float) Math.acos(leftEyeLookingDirection.dot(foodDirection)
                        / (leftEyeLookingDirection.mag() * foodDirection.mag()));
                float rightTheta = (float) Math.acos(rightEyeLookingDirection.dot(foodDirection)
                        / (rightEyeLookingDirection.mag() * foodDirection.mag()));
                
                // Determine if food is in left or right field of vision
                if (Math.abs(leftTheta) < EYE_ANGLE) {
                    inputSignal[0] = 1;
                } else if (Math.abs(rightTheta) < EYE_ANGLE) {
                    inputSignal[1] = 1;
                }
            }
        }
        
        inputSignal[2] = getHunger();
        
        return inputSignal;
    }
    
    /**
     * Flap left wing.
     */
    private void flapLeftWing() {
        leftWingAngle = Sentient.getSin(wingSinL * wingStrength * 0.12f);
        float flapStrengthL = wingStrength * leftWingFlapping / 40f + leftWingAngle * 0.05f;
        applyAngularForce(flapStrengthL / 50);
        PVector vector = PVector.fromAngle(angle);
        vector.mult(flapStrengthL);
        applyForce(vector);
        leftWingFlapping--;
        wingSinL += leftWingFlapping;
    }
    
    /**
     * Flap right wing.
     */
    private void flapRightWing() {
        rightWingAngle = Sentient.getSin(wingSinR * wingStrength * 0.12f);
        float flapStrengthR = wingStrength * rightWingFlapping / 40 + rightWingAngle * 0.05f;
        applyAngularForce(-flapStrengthR / 50);
        PVector vector = PVector.fromAngle(angle);
        vector.mult(flapStrengthR);
        applyForce(vector);
        rightWingFlapping--;
        wingSinR += rightWingFlapping;
    }
    
    public PVector getMouthLocation() {
        PVector mouthLocation = new PVector(face.mouth.location.x, face.mouth.location.y);
        mouthLocation.rotate(angle);
        PVector result = PVector.add(location, mouthLocation);
        return result;
    }
    
    /**
     * Eat food that is inside body radius.
     */
    private boolean eat() {
        PVector mouthLocation = getMouthLocation();
        
        for (int i = 0; i < Sentient.candies.size(); i++) {
            Candy candy = (Candy) Sentient.candies.get(i);
            
            float distanceToCandy = Sentient.dist(mouthLocation.x, mouthLocation.y, candy.location.x, candy.location.y);
            if (distanceToCandy < MAX_SIZE / 6) {
                digestFood();
                Sentient.candies.remove(i);
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Digest food.
     */
    private void digestFood() {
        fat += 10;
        
        // Grow and divide
        if (size < fat) {
            grow();
            divide();
            updateBodyProportions();
        }
    }
    
    /**
     * Increase size of organism.
     */
    private void grow() {
        size += 10;
        
        if (MAX_SIZE < size) {
            size = MAX_SIZE;
        }
    }
    
    /**
     * Burn fat.
     */
    private void burnFat() {
        fat -= size * 0.0002;
        
        if (0 < leftWingFlapping) {
            fat -= size * 0.0001;
        }
        
        if (0 < rightWingFlapping) {
            fat -= size * 0.0001;
        }
    }
    
    /**
     * Create offspring.
     */
    private void divide() {
        if (MAX_SIZE <= fat) {
            Sentient.organisms.add(new Organism(this));
            fat = MAX_SIZE / 2;
        }
    }
}
