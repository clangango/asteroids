class Missile extends GameObject {

  PVector target;

  float max_acceleration; //

  int startTime;

  Missile(float x, float y) {
    super(x, y, MISSILE_ANGLE, MISSILE_SPEED, MISSILE_MAX_SPEED, MISSILE_SIZE);
    acceleration.x = MISSILE_ACCELERATION;
    acceleration.y = MISSILE_ACCELERATION;
    max_acceleration = MISSILE_MAX_ACCELERATION;
    startTime = millis();
    missileLaunchSound.play();
  }

  void update() {
    PVector force = new PVector(MISSILE_DIRECTION_CHANGE_FORCE, MISSILE_DIRECTION_CHANGE_FORCE); // force to apply to direction change
    if(game.ufo != null) {
      target = game.ufo.getPosition();  // If a UFO is on screen, set it as the target
    } else {
      this.targetNearestAsteroid();  // Otherwise, target an asteroid
    }
    this.homing(target);  // set new direction to the target
    this.applyForce(force);  // change direction towards the target
    super.update();
  }

  void draw() {
    float theta = velocity.heading() + PI/2;
    noFill();
    stroke(WHITE);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(-5.0, -5.0);
    vertex(0.0, -15.0);
    vertex(5.0, -5.0);
    endShape(CLOSE);
    quad(-5.0, -5.0, 5.0, -5.0, 2.0, 10.0, -2.0, 10.0);
    beginShape();
    stroke(RED);
    vertex(-2.0, 12.0);
    vertex(2.0, 12.0);
    vertex(0.0, 15.0);
    endShape(CLOSE);
    popMatrix();
  }

  void applyForce(PVector force) { acceleration.add(force); }

  // Set the direction towards the current target
  void homing(PVector target) {
    PVector desiredDirection = PVector.sub(target, position);
    desiredDirection.normalize();
    desiredDirection.mult(max_speed);
    PVector steer = PVector.sub(desiredDirection, velocity);
    steer.limit(max_acceleration);
    applyForce(steer);
  }

  // Pick a target among the asteroids
  void targetNearestAsteroid() {
    PVector playerPosition = game.player.getPosition();
    float nearestTarget;
    if (game.asteroids.size() == 1) {
      nearestTarget = PVector.dist(playerPosition, game.asteroids.get(0).getPosition());
      target = game.asteroids.get(0).getPosition();
    } else if (game.asteroids.size() > 1) {
      nearestTarget = PVector.dist(playerPosition, game.asteroids.get(0).getPosition());
      target = game.asteroids.get(0).getPosition();
      for (int i = game.asteroids.size() - 1; i > 0; i--) {
        if (nearestTarget < PVector.dist(playerPosition, game.asteroids.get(i - 1).getPosition())) {
          continue;
        } else {
          target = game.asteroids.get(i - 1).getPosition();
          nearestTarget = PVector.dist(playerPosition, game.asteroids.get(i - 1).getPosition());
        }
      }
    }
  }

  PVector getTarget() { return target; }

  int getTime() { return startTime; }

  int getFlightTime() { return MISSILE_FLIGHT_TIME; }

  boolean shouldEnd() {
    return millis() - startTime >= MISSILE_FLIGHT_TIME;
  }
}
