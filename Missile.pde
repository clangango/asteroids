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
    size = 5;
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
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*5);
    vertex(-size, size*5);
    vertex(size, size*5);
    endShape(CLOSE);
    popMatrix();
  }

  // TODO check parameter input and closest target algorithm
  void targetNearest(ArrayList<UFO> potentialTargetsUfos, ArrayList<Asteroid> potentialTargetsAsteroids, PVector playerPosition){
    float nearestTarget;
      if (ufos.size() > 0) {
        for (int i = ufos.size(); i > 0; i--){
            nearestTarget = dist((ufos.get(i-1)), player);
            if (nearestTarget < dist((ufos.get(i)), player)) {
              target = new PVector(ufos.get(i-1).getPosition());
            }else {
              target =  new PVector(ufos.get(i).getPosition());
            }
          }
      }else {
        for (int i = asteroids.size(); i > 0; i--){
          nearestTarget = dist((asteroids.get(i-1)), player);
          if (nearestTarget < dist((asteroids.get(i)), player)) {
            target = new PVector(asteroids.get(i-1).getPosition());
          }else {
            target =  new PVector(asteroids.get(i).getPosition());
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