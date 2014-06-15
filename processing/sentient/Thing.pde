class Thing {
  float MAX_SPEED = 50;
  float DAMPING = 0.98;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float angle;
  float angularVel;
  float angularAcc;
  boolean existence = true;
  float size;
  float radius;
  float mass;
  boolean spotted = false;
  Thing() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = random(TWO_PI);
    mass = 1;
    MAX_SPEED = 50;
    DAMPING = 0.98;
  }
  void update() {
    eulerIntegration();
    wrapEdges();
  }
  void draw() {
  }
  //Update location, velocity, angle etc.
  void eulerIntegration() {
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
  }
  void applyForce(PVector force) {

    PVector f = PVector.div(force, mass);
    acceleration.add(f);
    
  }

  void applyAngularForce(float af) {
    angularAcc += af / mass;
  }

  void displayData(String data) {
    fill(0, 0, 100);
    text(data, 0, 0);
  }
  
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
}

