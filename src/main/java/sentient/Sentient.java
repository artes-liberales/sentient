package sentient;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;
import sentient.body.Eye;
import sentient.body.Face;
import sentient.brain.AiHomingIn;
//import processing.core.PFont;
import sentient.brain.AiNetwork;
import sentient.brain.AiSeeker;
import sentient.food.Candy;

public class Sentient extends PApplet {
    private static final long serialVersionUID = 5036190333019003029L;
    
    public static final int INIT_ORGANISMS = 30;
    public static final int INIT_CANDIES = 20;
    public static final int MAX_CANDIES = 100;
    public static final float CANDY_REFILL_RATE = 0.03f;
    
    public static final int MAP_WIDTH = 800;
    public static final int MAP_HEIGHT = 800;
    public static final float pi = PI;
    public static final float twoPi = TWO_PI;
    
    public static List<Organism> organisms;
    // Organism sentient;
    public static List<Candy> candies;
    
    //public PFont dataFont;
    
    // add guassian
    // evolution, vary behaviour, properties
    // Ecosystem of people ansikten som komponenet
    // ögon som rör sig
    // miner
    // kollision detection then opengl supported drawing
    // fix timestep & tweak anmation values
    // visualize brain & signals
    // eating some things needs time to stop and mouth animation
    // if large enough you can become carnivore
    // check distandce between every object against every other object save it
    // and check bounderies
    // collision detection and working vision
    // bump into each other and start looking at each other while going away!
    // if see another keep distance
    public int oncePerFrame;
    
    // === VISUAL SETUP ===
    public void setup() {
        // size(displayWidth, displayHeight, JAVA2D);
        // size(displayWidth, displayHeight, OPENGL);
        size(MAP_WIDTH, MAP_HEIGHT, JAVA2D);
        // size(600, 600, OPENGL);
        frameRate(60);
        // smooth();
        colorMode(HSB, 360, 100, 100);
        background(198, 30, 100);
        ellipseMode(CENTER);
        //dataFont = loadFont("LetterGothicMTStd-Bold-10.vlw");
        textAlign(CENTER, CENTER);
        
        organisms = new ArrayList<Organism>();
        for (int i = 0; i < INIT_ORGANISMS; i++) {
            float wingStrength = random(0.08f, 0.2f);
            int skinColor = color(random(360), Sentient.getMap(wingStrength, 0.08f, 0.2f, 40f, 70f), 95);
            int irisColor = color((int)RandomGenerator.getRandomInterval(120, 250), 40, 100);
            Organism org = new Organism(new AiNetwork(), wingStrength, skinColor, irisColor);
            organisms.add(org);
            // organisms.add(new Organism(new AiRandomFlapping()));
        }
        
        // sentient = new Organism(new AiNetwork());
        
        candies = new ArrayList<Candy>();
        for (int i = 0; i < INIT_CANDIES; i++) {
            int baseColor = color(random(360), 60, 95);
            candies.add(new Candy(baseColor));
        }
    }
    
    // Main loop
    public void draw() {
        background(198, 30, 100);
        oncePerFrame = frameCount;
        drawCandy();
        createCandy();
        drawOrganisms();
        // drawSentient();
    }
    
    // Update and draw organisms
    private void drawOrganisms() {
        for (int i = 0; i < organisms.size(); i++) {
            Organism organism = (Organism) organisms.get(i);
            organism.update(candies);
            drawOraganism(organism);
            
            // Check if it starves to death
            if (organism.fat <= 0) {
                organisms.remove(i);
                i--;
            }
        }
    }
    
    private void drawOraganism(Organism organism) {
        pushMatrix();
        
        translate(organism.location.x, organism.location.y);
        rotate(organism.angle);
        
        //Vision
        fill(255, 0, 100, 50);
        //ellipse(0, 0, organism.size + Organism.VISION, organism.size + Organism.VISION);
        arc(0, 0, 2 * Organism.VISION, 2 * Organism.VISION, -2f * Organism.EYE_ANGLE, 2f * Organism.EYE_ANGLE, PIE);
        
        //Wings
        stroke(organism.skinColor);
        strokeWeight(organism.size/4);
        //rotate(HALF_PI);
        
        //Left wing
        line(
        0, -organism.radius, //Wing starting point    
        organism.wingLength * sin(organism.leftWingAngle ), // Y for wing end point
        -organism.radius - organism.wingLength * cos(organism.leftWingAngle ) // X for wing end point
        ); 
        
        //Right wing
        line(
        0, organism.radius, //Wing starting point
        organism.wingLength * sin(organism.rightWingAngle), 
        organism.radius + organism.wingLength * cos(organism.rightWingAngle) // X for wing end point
        );
        
        drawFace(organism.face);
        popMatrix();
    }
    
    private void drawFace(Face face) {
        //Body
        noStroke();
        fill(face.skinColor);
        ellipse(0, 0, face.size, face.size);
        
        //Mouth
        strokeWeight(face.size / 50);
        stroke(0, 100, 100);
        fill(0, 100, 50);
        ellipse(face.mouth.location.x, face.mouth.location.y,
                face.mouth.width, face.mouth.height);
        
        //Eyes
        drawEye(face.leftEye);
        drawEye(face.rightEye);
    }
    
    private void drawEye(Eye eye) {
        int whiteColor = color(0, 0, 100);
        int pupilColor = color(0, 0, 20);
        
        noStroke();
        
        // White of the eye
        fill(whiteColor);
        ellipse(eye.location.x, eye.location.y, eye.eyeSize, eye.eyeSize);
        
        // Iris
        pushMatrix();
        translate(eye.location.x + eye.gaze.x * eye.eyeSize / 6, eye.location.y + eye.gaze.y * eye.eyeSize / 6);
        
        // drawVisionArea();
        noStroke();
        fill(eye.irisColor);
        ellipse(0, 0, eye.irisSize, eye.irisSize);
        
        // Pupil
        fill(pupilColor);
        ellipse(0, 0, eye.pupilSize, eye.pupilSize);
        popMatrix();
    }
    
    /*public void drawMouth() {
    //Mouth
      //strokeWeight(size/50);
      stroke(0, 100, 100);
      fill(0, 100, 50);
      //ellipse(size/2.5,0,size/10, size/4);
      //ellipse(size/2.5, 0, size/30, size/10);
    }*/
    
    // Draw candy
    private void drawCandy() {
        for (int i = 0; i < candies.size(); i++) {
            Candy candy = (Candy) candies.get(i);
            
            noStroke();
            fill(candy.baseColor);
            pushMatrix();
            
            translate(candy.location.x, candy.location.y);
            rotate(candy.angle);
            ellipse(0, 0, candy.size, candy.size/2);
            
            /*if(candy.spotted) {
                strokeWeight(1);
                stroke(#ff0000); //#ff0000
                noFill();
                ellipse(0, 0, candy.size*2, candy.size*2);
                candy.spotted = false;
            }*/
            
            popMatrix();
        }
    }
    
    // Create random new candy
    private void createCandy() {
        if (candies.size() < MAX_CANDIES && random(1) < CANDY_REFILL_RATE) {
            int baseColor = color(random(360), 60, 95);
            candies.add(new Candy(baseColor));
        }
    }
    
    /*
     * void drawSentient() { //add support for multiple keystorkes if
     * (keyPressed) { if (key == 'z') { sentient.leftWingFlapping = 10; }
     * 
     * if (key == 'x') { sentient.rightWingFlapping = 10; }
     * 
     * if (key == 's') { sentient.leftWingFlapping = 10;
     * sentient.rightWingFlapping = 10; } }
     * 
     * sentient.update(); sentient.draw(); }
     */
    
    public static float getCos(float x) {
        return cos(x);
    }
    
    public static float getSin(float x) {
        return sin(x);
    }
    
    public static float getDist(float x, float y, float z, float q) {
        return dist(x, y, z, q);
    }
    
    public static float getAbs(float angleToThing) {
        return abs(angleToThing);
    }
    
    public static float getMap(float a, float b, float c, float d, float e) {
        return map(a, b, c, d, e);
    }
    
    public static float getLerp(float dilation, float targetDilation, float dilationLerp) {
        return lerp(dilation, targetDilation, dilationLerp);
    }
}
