class UFO extends GameObject {
  
  PShape ufoShape;
  
  int points;
  int timeLastFired;  // determines when the UFO can fire again
  
  String type;        // "small" or "large" UFO. Size determines speed, size of shape and points
  
  UFO(float x, float y, String type) {
    super(x, y, UFO_ANGLE, UFO_LG_SPEED, UFO_MAX_SPEED, UFO_LG_SIZE);
    
    if(type == "small") {
      this.type = "small";
      size = UFO_SM_SIZE;
      points = UFO_SM_POINTS;
      speed = UFO_SM_SPEED;
    } else {
      this.type = "large";
      points = UFO_LG_POINTS;
    }
    
    if(position.x == 1) angle = random(60, 120); // If starting on the left side of screen, move towards the right: angle 60 - 120 degrees
    else angle = random(240, 300);  // If starting on the right side of the screen, move towards the left: angle 240 - 300 degrees
    
    velocity.x = this.speed * sin(radians(angle));
    velocity.y = this.speed * -cos(radians(angle));
    
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
    strokeWeight(1);
    beginShape(QUADS);
    if(type == "large") { // If a "large" UFO, draw large shape
      quad(-15.0, 0.0, 15.0, 0.0, 5.0, 5.0, -5.0, 5.0);
      quad(-15.0, 0.0, 15.0, 0.0, 5.0, -5.0, -5.0, -5.0);
      quad(5.0, -5.0, -5.0, -5.0, -3.0, -10.0, 3.0, -10.0);
    } else { // Otherwise draw the small shape
      quad(-10.0, 0.0, 10.0, 0.0, 3.0, 3.0, -3.0, 3.0);
      quad(-10.0, 0.0, 10.0, 0.0, 3.0, -3.0, -3.0, -3.0);
      quad(3.0, -3.0, -3.0, -3.0, -1.0, -7.0, 1.0, -7.0);
    }
    endShape();
    popMatrix();
  }
  
  void fire() {
    if(millis() - timeLastFired > UFO_FIRE_DELAY) {
      Player p = game.player;
      float angle = degrees(PVector.angleBetween(p.getPosition(), position)); // Measure angle from the UFO to player
      // Add 90, 180 or 270 degrees depending on the angle to the player. This will ensure the bullets head in the right
      // general direction, but not straight at the player.
      if(p.position.x - position.x >= 0 && p.position.y - position.y >= 0) angle += degrees(PI/2);
      if(p.position.x - position.x <= 0 && p.position.y - position.y >= 0) angle += degrees(PI);
      if(p.position.x - position.x <= 0 && p.position.y - position.y <= 0) angle += degrees(3*PI/2);
      game.ufoBullets.add(new Bullet(position.x, position.y, angle, color(GREEN)));
      timeLastFired = millis();
    }
  }
  
  boolean isOffScreen() {
    return position.x <= 0 || position.x >= width || position.y <= 0 || position.y >= height;
  }
  
  int getPoints() { return points; }
}