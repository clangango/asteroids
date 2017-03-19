class UFO extends GameObject {
  
  static final float UFO_CHANCE = 0.001;            // chance each loop that a UFO will appear
  float ufoSize;
  
  UFO(float x, float y) {    
    super(x, y);
    
    // set angle of travel to ensure the UFO goes across the screen
    if(position.x == 1) angle = random(60, 120);
    if(position.x == width - 1) angle = random(240, 300);
    
    velocity.x = 4 * sin(radians(angle));
    velocity.y = 4 * -cos(radians(angle));
    
    // size for collision detection **** FIX THIS ****
    ufoSize = 30;
    ufoSound.play();
  }
  
  void draw() {
    noFill();
    stroke(0,255,0);
    pushMatrix();
    translate(position.x, position.y);
    scale(0.3);
    strokeWeight(3);
    beginShape(QUADS);
    quad(-50, 0, 50, 0, 20, 20, -20, 20);
    quad(-50, 0, 50, 0, 20, -20, -20, -20);
    quad(20, -20, -20, -20, -10, -40, 10, -40);
    endShape();
    popMatrix();
  }
  
  boolean checkCollision(GameObject object) {
    if(position.dist(object.getPosition()) < ufoSize) return true;
    return false;
  }
  
  boolean isOffScreen() {
    if(position.x <= 0 || position.x >= width || position.y <= 0 || position.y >= height) return true;
    return false;
  }
}