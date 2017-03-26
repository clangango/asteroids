class Missile extends GameObject {

  PVector velocity;
  PVector acceleration;
  float max_force;
  float max_speed;
  float size;
  final int FLIGHTTIME = 1600;
  PVector target;
  int startTime;



  Missile(float shipPositionX, float shipPositionY) {
    super(shipPositionX, shipPositionY);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    max_speed = 5;
    max_force = 0.5;
    size = 2;
    startTime = millis();
  }

  void update() {
    // Acceleration = change in velocity
    velocity.add(acceleration);
    velocity.limit(max_speed);
    // Velocity = change in position
    position.add(velocity);

  }

  void applyForce(PVector force) {
    // force = mass(1)*acceleration
    acceleration.add(force);
  }

  void homing(PVector target) {
    // desired velocity =  target location - current position
    PVector desired =  PVector.sub(target,position);
    desired.normalize();
    desired.mult(max_speed);
    // steering force =  desired velocity - current velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    applyForce(steer);
  }

  void draw() {
    // Allows rotation of the object
    float theta = velocity.heading() + PI/2;
    noFill();
    stroke(#F50031);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape(CLOSE);
    popMatrix();
  }

  void targetNearestAsteroid(ArrayList<Asteroid> asteroids, PVector playerPosition) {
      float nearestTarget;
      if (asteroids.size() == 1) {
        nearestTarget = PVector.dist(playerPosition, asteroids.get(0).getPosition());
        target = asteroids.get(0).getPosition();
      }
      else if (asteroids.size() > 1) {
        for (int i = asteroids.size()-1; i > 0; i--) {
          nearestTarget = PVector.dist(playerPosition, asteroids.get(i).getPosition());
          if (nearestTarget < PVector.dist(playerPosition, asteroids.get(i-1).getPosition())) {
            target = asteroids.get(i).getPosition();
          }else {
            target = asteroids.get(i-1).getPosition();
          }
        }
      }
    }


  PVector getTarget() {
    return target;
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
