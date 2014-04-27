//Something to eat
class Candy {
  final float CANDY_SIZE = 20;
  
  PVector location;
  float angle;
  
  float mass = 1;
  float size;
  float radius;
  
  color baseColor;
  
  //Constructor
  Candy() {
    location = new PVector(random(width), random(height));
    angle = random(TWO_PI);
    size = CANDY_SIZE;
    
    baseColor = color(random(360), 60, 95);
  }
  
  //Draw it
  void draw() {
    noStroke();
    fill(baseColor);
    pushMatrix();
    
    translate(location.x, location.y);
    rotate(angle);
    ellipse(0, 0, size, size);
    
    popMatrix();
  }
}

