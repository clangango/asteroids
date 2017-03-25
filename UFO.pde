class UFO extends GameObject {
  
  static final float UFO_CHANCE = 0.001;                     // chance each loop that a UFO will appear
  final int FIREDELAY = 1000;                                // milliseconds to delay between firing
  final float UFOSIZE = 30;
  final float SPEED = 4;
  final color GREEN = color(0, 255, 0);
  
  int timeLastFired;
  
  UFO(float x, float y) {    
    super(x, y);
    
    // set angle of travel to ensure the UFO goes across the screen
    if(position.x == 1) angle = random(60, 120);
    if(position.x == width - 1) angle = random(240, 300);
    
    velocity.x = SPEED * sin(radians(angle));
    velocity.y = SPEED * -cos(radians(angle));

    ufoSound.play();
  }
  
  void update() {
    super.update();
    fire();
  }
  
  void draw() {
    noFill();
    stroke(GREEN);
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
    return super.checkCollision(object, UFOSIZE);
  }
  
  boolean isOffScreen() {
    if(position.x <= 0 || position.x >= width || position.y <= 0 || position.y >= height) return true;
    return false;
  }
  
  void fire() {
    if(millis() - timeLastFired >= FIREDELAY) {
      PVector pPosition = player.getPosition();
      float angle = degrees(PVector.angleBetween(player.getPosition(), position));
      if(pPosition.x - position.x >= 0 && pPosition.y - position.y >= 0) angle += degrees(PI/2);
      if(pPosition.x - position.x <= 0 && pPosition.y - position.y >= 0) angle += degrees(PI);
      if(pPosition.x - position.x <= 0 && pPosition.y - position.y <= 0) angle += degrees(3*PI/2);
      ufoBullets.add(new Bullet(position.x, position.y, angle, color(GREEN)));
      println("Bullet FIRED!!! (" + angle + ")");
      timeLastFired = millis();
    }
  }
}