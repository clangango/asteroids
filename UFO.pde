class UFO extends GameObject {
  
  static final float UFO_CHANCE = 0.1;            // chance each loop that a UFO will appear
  final int FIREDELAY = 1000;                                // milliseconds to delay between firing
  float ufoSize;
  
  int timeLastFired;
  
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
  
  void update() {
    super.update();
    fire();
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
  
  void fire() {
    if(millis() - timeLastFired >= FIREDELAY) {
      PVector pPosition = player.getPosition();
      float angle = degrees(PVector.angleBetween(player.getPosition(), position));
      if(pPosition.x - position.x >= 0 && pPosition.y - position.y >= 0) angle += 90;
      if(pPosition.x - position.x <= 0 && pPosition.y - position.y >= 0) angle += 180;
      if(pPosition.x - position.x <= 0 && pPosition.y - position.y <= 0) angle += 270;
      ufoBullets.add(new Bullet(position.x, position.y, angle, color(0, 255, 0)));
      println("Bullet FIRED!!! (" + angle + ")");
      timeLastFired = millis();
    }
  }
}