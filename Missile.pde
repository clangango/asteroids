class Missile {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float max_force;
  float max_speed;
  float size;

  Missile(float shipPositionX, float shipPositionY) {

    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    // initialise Missile object at the ship's current position
    position = new PVector(shipPositionX, shipPositionY);
    max_speed = 5;
    max_force = 0.5;
    size = 10;

  }

  void update() {
    // change in velocity = change in acceleration
    velocity.add(acceleration);
    velocity.limit(max_speed);
    // change in velocity = change in position
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

  void display() {
    float theta = velocity.heading() + PI/2;
    noFill();
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*10);
    vertex(-size, size*10);
    vertex(size, size*10);
    endShape(CLOSE);
    popMatrix();
  }
}