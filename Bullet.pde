class Bullet extends GameObject {
  
  final float SPEED = 10.0;          // how fast the x and y velocity vectors should change
  final int FLIGHTTIME = 800;        // millisecond flight time for bullets before they expire
  color bulletColor;                 // color of the bullet in RGB format

  int startTime;  
  
  Bullet(float x, float y, float angle, color col) {
    super(x, y);
    velocity.x = SPEED * sin(radians(angle));
    velocity.y = -SPEED * cos(radians(angle));
    bulletColor = col;
    startTime = millis();
  }
  
  void draw() {
    pushMatrix();
    stroke(bulletColor);
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