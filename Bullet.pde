class Bullet extends GameObject {
  
  final float SPEED = 10.0;          // how fast the x and y velocity vectors should change
  final int FLIGHTTIME = 800;        // millisecond flight time for bullets before they expire

  int startTime;
  
  
  Bullet(float x, float y, float angle) {
    super(x, y);
    velocity.x = SPEED * sin(radians(angle));
    velocity.y = -SPEED * cos(radians(angle));
    startTime = millis();
  }
  
  void draw() {
    pushMatrix();
    stroke(255);
    strokeWeight(2);
    translate(position.x, position.y);
    point(0, 0);
    popMatrix();
  }
  
  int getTime() {
    return startTime;
  }
  
  int getFlightTime() {
    return FLIGHTTIME;
  }
  
  boolean shouldEnd() {
    if(millis() - startTime >= FLIGHTTIME) return true;
    return false;
  }
}