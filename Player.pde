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
  int currentWeapon;
  PShape pShape;
  
  Player() {
    super(width/2, height/2);
    lives = STARTLIVES;
    timeLastFired = 0;
    weapon = 1;
    
    pShape = createShape();
    pShape.beginShape();
    pShape.noFill();
    pShape.stroke(255);
    pShape.vertex(-10, 15);
    pShape.vertex(0, -15);
    pShape.vertex(10, 15);
    pShape.vertex(0, 10);
    pShape.endShape(CLOSE);
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
      velocity.mult(DECELERATE);
    }
    if(fire) {
      if(millis() - timeLastFired > FIREDELAY) {
        fire();
        timeLastFired = millis();
      }
    }
    currentWeapon = weapon;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    strokeWeight(1);
    shape(pShape, 0, 0);;
    
    if(upKey) {
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
  
  void warp() {
    position.x = random(0, width);
    position.y = random(0, height);
  }
  
  void fire() {
    switch(weapon) {
      case 1:  
        float bulletX = position.x + 15  * sin(radians(angle));
        float bulletY = position.y - 15 * cos(radians(angle));
        bullets.add(new Bullet(bulletX, bulletY, angle));
        fireSound.play();
        break;
    }
  }
  
  void switchWeapon() {}
  
  int getLives() {
    return lives;
  }
  
  void loseLife() {
    lives--;
  }
  
  void addLife() {
    lives++;
  }
  
  void reset() {
    position.x = width/2;
    position.y = height/2;
    velocity.x = 0;
    velocity.y = 0;
    acceleration.x = 0;
    acceleration.y = 0;
    timeLastFired = 0;
  }
}