class Player extends GameObject {
  
  String weapon;
  String currentState; // Whether the player is "active", "exploding" or "dead". Dead is end of the game
  
  PShape ship;
  
  int lives;
  int missiles;       // Current remaining missiles available
  int explodeTime;    // Time the player is hit and starts to explode
  int timeLastFired;  // Used to determine if the player is currently allowed to fire
  
  Player() {
    super(HALF_WIDTH, HALF_HEIGHT, PLAYER_ANGLE, PLAYER_SPEED, PLAYER_MAX_SPEED, PLAYER_SIZE);
    
    timeLastFired = 0;
    weapon = "bullet";  // Default weapon is bullets fired with the spacebar
    currentState = "active";
    lives = PLAYER_START_LIVES;
    missiles = PLAYER_START_MISSILES;
    
    ship = createShape();
    ship.beginShape();
    ship.noFill();
    ship.strokeWeight(STROKE_WEIGHT);
    ship.stroke(WHITE);
    for(float[] points: PLAYER_POINTS) {
      ship.vertex(points[0], points[1]);
    }
    ship.endShape(CLOSE);
  }
  
  void update() {
    if(currentState == "active") {  // If active, update movements and ability to fire
      super.update();
      
      if(leftKey) rotateLeft();
      if(rightKey) rotateRight();
      if(upKey) { 
        thrust();
      } else {
        acceleration.x = 0.0;
        acceleration.y = 0.0;
        velocity.mult(PLAYER_DECELERATE);
      }
      if(fire || weapon == "missile") {
        if(millis() - timeLastFired > PLAYER_FIRE_DELAY) {
          fire();
          timeLastFired = millis();
        }
      }
    } else if(currentState == "exploding") {  // Otherwise explode the player
      if(millis() - explodeTime > EXPLOSION_FLIGHT_TIME) {
        this.reset();
      }
    }
  }
  
  void draw() {
    if(currentState == "active") { // Only draw the active player. Exploding player is drawn as explosion
      pushMatrix();
      translate(position.x, position.y);
      rotate(radians(angle));
      shape(ship, 0, 0);
      // add a small red flame out the back when applying thrust
      if(upKey) {
        stroke(RED);
        noFill();
        triangle(-2.0, 15.0, 0.0, 25.0, 2.0, 15.0);
      }
      popMatrix();
    }
  }
  
  void thrust() {
    acceleration.x = this.speed * sin(radians(angle));
    acceleration.y = -this.speed * cos(radians(angle));
    thrustSound.play();
  }

  void rotateLeft() {
    angle -= PLAYER_ROTATION;
  }

  void rotateRight() {
    angle += PLAYER_ROTATION;
  }
  
  /**
   * Provides the player the ability to ascape a tight situation by moving
   * the ship to a random location on screen.
   *
   * Future development: ensure random location is not occupied.
  **/
  void warp() {
    position.x = random(ORIGIN_X, width);
    position.y = random(ORIGIN_Y, height);
  }
  
  void setWeapon(String weapon) {
    this.weapon = weapon;
  }
  
  void fire() {
    switch(weapon) {
      case "bullet":
        // Fire bullets in the current direction the player is heading and
        // fire from the tip of the ship
        game.bullets.add(new Bullet(position.x + size  * sin(radians(angle)), 
                                    position.y - size * cos(radians(angle)), 
                                    angle, color(WHITE)));
        break;
      case "missile":
        if (game.missile == null && missiles > 0) {
          game.missile = new Missile(position.x, position.y);
          missiles--;
          weapon = "bullet";
          break;
        }
        break;
      // default weapon is the bullet
      default:  
        game.bullets.add(new Bullet(position.x + size  * sin(radians(angle)), 
                                    position.y - size * cos(radians(angle)), 
                                    angle, color(WHITE)));
        break;
    }
  }
  
  void explode() {
    mediumExplosionSound.play();
    game.explosions.add(new Explosion(position, color(WHITE)));
    mediumExplosionSound.play();
    currentState = "exploding";
    explodeTime = millis();
  }
  
  String getState() { return currentState; }
  
  void setState(String state) {
    currentState = state;
  }
  
  boolean isExploding() { return currentState == "exploding"; }

  int getLives() { return lives; }
  
  int getMissiles() { return missiles; }
  
  void setMissiles(int missiles) { this.missiles = missiles; }

  void loseLife() { lives--; }

  void addLife() {
    lives++;
    extraLifeSound.play();
  }
  
  void reset() {
    // Return the player to the centre of the screen and "active"
    position.x = HALF_WIDTH;
    position.y = HALF_HEIGHT;
    angle = 0;
    velocity.x = 0;
    velocity.y = 0;
    acceleration.x = 0;
    acceleration.y = 0;
    timeLastFired = 0;
    currentState = "active";
  }
}