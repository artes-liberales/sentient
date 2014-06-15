package sentient;

import java.util.List;

import processing.core.PVector;
import sentient.body.Face;
import sentient.brain.Brain;
import sentient.food.Candy;

public class Organism extends Thing {
    public static final float MAX_SIZE = 150;
    public static final float VISION = 120;
    public static final float EYE_ANGLE = Sentient.pi / 2;
    
    public String name;
    
    public float size;
    public float fat;
    public float hunger;
    public boolean hungry;
    
    public float wingLength;
    public float leftWingAngle;
    public float rightWingAngle;
    public float leftWingFlapping = 0;
    public float rightWingFlapping = 0;
    public float wingStrength;
    public float wingSinR, wingSinL;
    
    public int skinColor;
    
    public Brain brain;
    public Face face;
    
    /**
     * Constructor.
     */
    public Organism(Brain brain, float wingStrength2, int skinColor2, int irisColor) {
        super();
        randomName();
        size = RandomGenerator.gaussianCalculator(MAX_SIZE / 2, MAX_SIZE / 10);
        fat = 10000;
        hunger = 0;
        wingStrength = wingStrength2;
        skinColor = skinColor2;
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
        size = original.size;
        fat = size;
        hungry = false;
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
    
    public void randomName() {
        name = "KLAS";
    }
    
    // Update size of body parts
    public void updateBodyProportions() {
        face.updateProportions(size);
        mass = size * 0.1f;
        radius = size / 2;
        wingLength = radius * wingStrength * 2;
    }
    
    // Update it
    public void update(List<Candy> candies) {
        face.leftEye.locationT = new PVector(location.x, location.y);
        face.rightEye.locationT = new PVector(location.x, location.y);
        face.bodyAngle = angle;
        face.update();
        
        percieve();
        moveBodyParts(candies);
        // eat();
        burnFat();
        super.update();
    }
    
    public void percieve() {
        // float[] inputSignal = face.percieve();
        // float[] outputSignal = brain.think(inputSignal);
    }
    
    // Move body parts
    public void moveBodyParts(List<Candy> candies) {
        // Percieve, could theese be ivars instead?
        // pushMatrix();
        
        // translate(location.x, location.y);
        // rotate(angle);
        // float[] inputSignal = lookForFood();
        // popMatrix();
        float[] inputSignal = lookFoorFood(candies);
        float[] outputSignal = brain.think(inputSignal);
        
        if (0 <= leftWingFlapping && 1 <= outputSignal[0]) {
            //leftWingFlapping = (int) random(5, 60);
            leftWingFlapping = 30;
        }
        
        if (0 <= rightWingFlapping && 1 <= outputSignal[1]) {
            //rightWingFlapping = (int) random(5, 60);
            rightWingFlapping = 30;
        }
        
        if (0 < leftWingFlapping) {
            flapLeftWing();
        }
        
        if (0 < rightWingFlapping) {
            flapRightWing();
        }
    }
    
    // See if there is food in front of the organism
    // inputSignal[0] == 1 means that there is food to the left
    // inputSignal[1] == 1 means that there is food to the right
    // There can be food both to the left and to the right
    public float[] lookFoorFood(List<Candy> candies) {
        // Signal that is to be sent as input to the brain
        float[] inputSignal = new float[3];
        
        // The angles that the eyes are looking in
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
            if (distanceToCandy < VISION) {
                PVector foodDirection = new PVector(candyX - location.x, candyY - location.y);
                
                // Angles between eye looking directions and food direction
                float leftTheta = (float) Math.acos(leftEyeLookingDirection.dot(foodDirection)
                        / (leftEyeLookingDirection.mag() * foodDirection.mag()));
                float rightTheta = (float) Math.acos(rightEyeLookingDirection.dot(foodDirection)
                        / (rightEyeLookingDirection.mag() * foodDirection.mag()));
                
                // Determine if food is in left or right field of vision
                
                if (Math.abs(leftTheta) < EYE_ANGLE) {
                    inputSignal[0] = 1;
                    // candy.spotted = true;
                } else if (Math.abs(rightTheta) < EYE_ANGLE) {
                    inputSignal[1] = 1;
                    // candy.spotted = true;
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
    
    public float[] lookForFood(List<Candy> candies) {
        // Signal that is to be sent as input to the brain
        float[] inputSignal = new float[3];
        
        for (int i = 0; i < candies.size(); i++) {
            Candy candy = (Candy) candies.get(i);
            
            PVector candySeen = face.percieve(candy);
            if (candySeen != null) {// deterimine angle in relation to body to
                                    // send input
                // angle -
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
    
    // Flap left wing
    public void flapLeftWing() {
        leftWingAngle = Sentient.getSin(wingSinL * wingStrength * 0.12f);
        float flapStrengthL = wingStrength * leftWingFlapping / 40f + leftWingAngle * 0.05f;
        applyAngularForce(flapStrengthL / 50);
        PVector vector = PVector.fromAngle(angle);
        vector.mult(flapStrengthL);
        applyForce(vector);
        leftWingFlapping--;
        wingSinL += leftWingFlapping;
    }
    
    // Flap right wing
    public void flapRightWing() {
        rightWingAngle = Sentient.getSin(wingSinR * wingStrength * 0.12f);
        float flapStrengthR = wingStrength * rightWingFlapping / 40 + rightWingAngle * 0.05f;
        applyAngularForce(-flapStrengthR / 50);
        PVector vector = PVector.fromAngle(angle);
        vector.mult(flapStrengthR);
        applyForce(vector);
        rightWingFlapping--;
        wingSinR += rightWingFlapping;
    }
    
    // Eat food that is inside body radius
    public boolean eat() {
        for (int i = 0; i < Sentient.candies.size(); i++) {
            Candy candy = (Candy) Sentient.candies.get(i);
            
            if (Sentient.dist(location.x, location.y, candy.location.x, candy.location.y) < radius) {
                fat += 10;
                
                // Grow and divide
                if (size < fat) {
                    size += 10;
                    divide();
                    updateBodyProportions();
                }
                
                Sentient.candies.remove(i);
                return true;
            }
        }
        
        return false;
    }
    
    public void eat2() {
        fat += 10;
        
        // Grow and divide
        if (size < fat) {
            size += 10;
            divide();
            updateBodyProportions();
        }
    }
    
    // Burn fat
    public void burnFat() {
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
        } else {
            hungry = false;
        }
    }
    
    // Divide into two organisms
    public void divide() {
        if (MAX_SIZE <= size) {
            size = MAX_SIZE / 2;
            fat = size;
            Sentient.organisms.add(new Organism(this));
        }
    }
}
