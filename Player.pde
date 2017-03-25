/**
 *
**/
class Player extends GameObject {

  final float THRUST = 0.2;       // constant modifier of acceleration
  final float DECELERATE = 0.985; // amount to reduce velocity when not accelerating
  final int FIREDELAY = 250;      // milliseconds to delay between firing
  final int STARTLIVES = 3;

  int lives;
  int timeLastFired;
  PShape shipShape;
  
  int missileCount = 1;

  Player() {
    super(width/2, height/2);     // start player in centre of the screen
    lives = STARTLIVES;
    timeLastFired = 0;
    weapon = 1;                   // starting weapon is the bullet
    
    shipShape = createShape();
    shipShape.beginShape();
    shipShape.noFill();
    shipShape.stroke(255);
    shipShape.vertex(-10, 15);
    shipShape.vertex(0, -15);
    shipShape.vertex(10, 15);
    shipShape.vertex(0, 10);
    shipShape.endShape(CLOSE);
    
    missileCount = 1;
  }

  void update() {
    super.update();

    if(leftKey) rotateLeft();
    if(rightKey) rotateRight();
    if(upKey) {
      thrust();
    } else {
      acceleration.x = 0;
      acceleration.y = 0;
      velocity.mult(DECELERATE);  // if not applying thrust, slow down a little bit each loop
    }
    if(fire) {
      if(millis() - timeLastFired > FIREDELAY) {
        fire();
        timeLastFired = millis();
      }
    }
    // Fire a missile
    if (weapon == 2) {
        fire();
    }
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    strokeWeight(1);
    shape(shipShape, 0, 0);
    
    if(upKey) {
      // add a small red flame out the back when applying thrust
      stroke(255,0,0);
      noFill();
      triangle(-2, 15, 0, 25, 2, 15);
    }
    popMatrix();
  }

  void thrust() {
    acceleration.x = THRUST * sin(radians(angle));
    acceleration.y = -THRUST * cos(radians(angle));
    thrustSound.play();
  }

  void rotateLeft() {
    angle -= 10;
  }

  void rotateRight() {
    angle += 10;
  }

  // pick a random location on the screen and move the player
  void warp() {
    position.x = random(0, width);
    position.y = random(0, height);
  }

  void fire() {
    switch(weapon) {
      // Fire a missile
      case 2:
        if (missiles.size()<missileCount) {
          missiles.add(new Missile(player.position.x, player.position.y));
          break;
        }
        break;
      // default weapon is the bullet
      default:  
        bullets.add(new Bullet(position.x + 15  * sin(radians(angle)), position.y - 15 * cos(radians(angle)), angle, color(255)));
        fireSound.play();
        break;
    }

  }

  int getLives() {
    return lives;
  }

  void loseLife() {
    lives--;
  }

  void addLife() {
    lives++;
  }
  
  void explode() {
    
  }

  void addMissile() {
    missileCount++;
  }

  void removeMissile() {
    missileCount--;
  }

  // set the player ship values back to the starting position
  // called at the start of each level to rest the player for the next level
  void reset() {
    // return position to centre of the screen
    position.x = width/2;
    position.y = height/2;

    // set angle back to 0
    angle = 0;

    // set velocity to 0
    velocity.x = 0;
    velocity.y = 0;

    // set acceleration to 0
    acceleration.x = 0;
    acceleration.y = 0;

    // set the record of time last fired back to 0
    timeLastFired = 0;
  }
}