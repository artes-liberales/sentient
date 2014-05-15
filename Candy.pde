//Something to eat
class Candy extends Thing{
  float CANDY_SIZE = 20;
  color baseColor;
  //Constructor
  Candy() {
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
    ellipse(0, 0, size, size/2);
    
    if(spotted) {
      strokeWeight(1);
    stroke(#ff0000);
    noFill();
    ellipse(0, 0, size*2, size*2);
    spotted = false;
  }
    
    popMatrix();
  }
}

