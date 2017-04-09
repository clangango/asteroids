class Bullet extends GameObject {
  
  color bulletColor;
  
  int startTime; // time the bullet is fired. Determines when to remove it based on flight time.
  
  Bullet(float x, float y, float angle, color c) {
    super(x, y, angle, BULLET_SPEED, BULLET_MAX_SPEED, BULLET_SIZE);
    velocity.x = this.speed * sin(radians(angle));
    velocity.y = -this.speed * cos(radians(angle));
    bulletColor = c;
    startTime = millis();
    fireSound.play();
  }
  
  void draw() {
    pushMatrix();
    stroke(bulletColor);
    strokeWeight(STROKE_WEIGHT * 2.0); // draw bullets at double weight to make them easy to see
    translate(position.x, position.y);
    point(0, 0);
    popMatrix();
  }
  
  int getTime() {
    return startTime;
  }
  
  int getFlightTime() {
    return BULLET_FLIGHT_TIME;
  }
  
  boolean shouldEnd() {
    return millis() - startTime >= BULLET_FLIGHT_TIME;
  }
}