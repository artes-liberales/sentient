package sentient;

import processing.core.PVector;

public class Thing {
    public static final float MAX_SPEED = 50f;
    public static final float DAMPING = 0.98f;
    
    public PVector location;
    public PVector velocity;
    public PVector acceleration;
    public float angle;
    public float angularVel;
    public float angularAcc;
    public boolean existence = true;
    public float size;
    public float radius;
    public float mass;
    public boolean spotted = false;
    
    /**
     * Constructor.
     */
    public Thing() {
        location = new PVector(RandomGenerator.getRandomInterval(0, Sentient.MAP_WIDTH), RandomGenerator.getRandomInterval(0, Sentient.MAP_HEIGHT));
        velocity = new PVector(0, 0);
        acceleration = new PVector(0, 0);
        angle = RandomGenerator.getRandomInterval(0, Sentient.twoPi);
        mass = 1;
    }
    
    protected void update() {
        eulerIntegration();
        wrapEdges();
    }
    
    public void draw() {
    }
    
    // Update location, velocity, angle etc.
    protected void eulerIntegration() {
        velocity.add(acceleration);
        velocity.mult(DAMPING);
        velocity.limit(MAX_SPEED);
        location.add(velocity);
        acceleration.mult(0);
        // Rewind angle so that it is between 0 and 2 * PI
        if (Sentient.TWO_PI < angle) {
            angle -= Sentient.TWO_PI;
        }
        else if (angle < 0) {
            angle += Sentient.TWO_PI;
        }
        angularVel += angularAcc;
        angularVel *= DAMPING;
        angle += angularVel;
        angularAcc = 0;
    }
    
    protected void applyForce(PVector force) {
        PVector f = PVector.div(force, mass);
        acceleration.add(f);
    }
    
    protected void applyAngularForce(float af) {
        angularAcc += af / mass;
    }
    
    /*void displayData(String data) {
        fill(0, 0, 100);
        text(data, 0, 0);
    }*/
    
    protected void wrapEdges() {
        float margin = 0;
        
        // RIGHT EDGE
        if (location.x >= Sentient.MAP_WIDTH + radius - margin) {
            location.x = -radius + margin;// TO LEFT EDGE
        }
        // DOWN EDGE
        else if (location.y >= Sentient.MAP_HEIGHT + radius - margin) {
            location.y = -radius + margin;// TO TOP EDGE
        }
        // LEFT EDGE
        else if (location.x <= -radius + margin) {
            location.x = Sentient.MAP_WIDTH + radius - margin;// TO RIGHT EDGE
        }
        // TOP EDGE
        else if (location.y <= -radius + margin) {
            location.y = Sentient.MAP_HEIGHT + radius - margin;// TO DOWN EDGE
        }
    }
}
