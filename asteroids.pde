/**
 * COSC101 Software Development Studio
 * Assignment 1
 *
 * Group 20
 *
**/

import processing.sound.*;

boolean rightKey;
boolean leftKey;
boolean upKey;
boolean fire;
int level;
int score;
int[] asteroidScores;

Player player;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
int flightTime;

SoundFile thrustSound;
SoundFile fireSound;
PFont font;

void setup() {
  size(1000, 800);
  player = new Player();
  bullets = new ArrayList<Bullet>();
  asteroids = new ArrayList<Asteroid>();
  flightTime = 800;
  thrustSound = new SoundFile(this, "thrust.wav");
  fireSound = new SoundFile(this, "fire.wav");
  font = createFont("Hyperspace.otf", 32);
  level = 1;
  score = 0;
  asteroidScores = new int[]{20, 50, 100};
  startLevel(1);
}

void draw() {
  background(0);
  player.update();
  player.draw();
  for(Asteroid asteroid: asteroids) { asteroid.update(); asteroid.draw();}
  
  for(int i = bullets.size(); i > 0; i--) {
    Bullet bullet = (Bullet)bullets.get(i-1);
    if(millis() - bullet.getTime() > flightTime) {
      bullets.remove(i-1);
    }
    bullet.update();
    bullet.draw();
    for(int j = asteroids.size(); j > 0; j--) {
      Asteroid asteroid = (Asteroid)asteroids.get(j-1);
      if(bullet.getPosition().dist(asteroid.getPosition()) < 40) {
        bullets.remove(bullet);
        int newSize = asteroid.getSize() - 1;
        score += asteroidScores[newSize];
        println(score);
        if(newSize > 0) {
          asteroids.add(new Asteroid(new PVector(asteroid.getPosition().x, asteroid.getPosition().y), newSize));
          asteroids.add(new Asteroid(new PVector(asteroid.getPosition().x, asteroid.getPosition().y), newSize));
        }
        asteroids.remove(asteroid);
      }
    }
  }
  
  for(int i = asteroids.size(); i > 0; i--) {
    Asteroid asteroid = (Asteroid)asteroids.get(i-1);
    if(asteroid.getPosition().dist(player.getPosition()) < 20) {
      player.loseLife();
      asteroids.remove(asteroid);
    }
    if(player.getLives() <= 0) {
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
      noLoop();
    }
  }
  textFont(font);
  text(score, 30, 50);
  for(int i = 0; i < player.getLives(); i++) {
     triangle(30 + i * 30, 90, 40 + i * 30, 60, 50 + i * 30, 90);
  }
  
  if(asteroids.size() == 0) {
    level++;
    asteroids.clear();
    bullets.clear();
    player.reset();
    startLevel(level);
  }
}

void keyPressed() {
  keyboardPressed();
}

void keyReleased() {
  keyboardReleased();
}

void keyboardPressed() {
  if(keyCode == UP) upKey = true;
  if(keyCode == LEFT) leftKey = true;
  if(keyCode == RIGHT) rightKey = true;
  if(key == ' ') fire = true;
}

void keyboardReleased() {
  if(keyCode == UP) upKey = false;
  if(keyCode == LEFT) leftKey = false;
  if(keyCode == RIGHT) rightKey = false;
  if(key == ' ') fire = false;
  if(key == 'z' || key == 'Z') player.warp();
}

void startLevel(int level) {
  for(int i = 0; i < (2 + level * 2); i++) {
    float startX, startY;
    float leftRight = random(0, 1);
    float topBottom = random(0, 1);
    if(leftRight < 0.5) { startX = random(0, width/2 - 200); }
    else { startX = random(width/2 + 200, width);}
    if(topBottom < 0.5) { startY = random(0, height/2 - 200);}
    else { startY = random(height/2 + 200, height);}
    asteroids.add(new Asteroid(new PVector(startX, startY), 3));
  }
}

class Player {
  
  int lives;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float angle;
  float thrust;
  int lastFired;
  
  Player() {
    lives = 3;
    thrust = 0.2;
    reset();
  }
  
  void reset() {
    position = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lastFired = 0;
  }
  
  void update() {
    if(leftKey) rotateLeft();
    if(rightKey) rotateRight();
    if(upKey) {
      thrust();
    } else {
      noThrust();
    }
    if(fire) {
      if(millis() - lastFired > 200) {
        fire();
        lastFired = millis();
      }
    }
    position.add(velocity);
    velocity.mult(0.992);
    velocity.add(acceleration);
    
    if(position.x < 0) position.x = width;
    if(position.x > width) position.x = 0;
    if(position.y < 0) position.y = height;
    if(position.y > height) position.y = 0;
  }
  
  void draw() {
    stroke(255);
    noFill();
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    triangle(-10, 10, 0, -20, 10, 10);
    if(upKey) {
      triangle(-2, 10, 0, 18, 2, 10);
    }
    popMatrix();
  }
  
  void thrust() {
    acceleration = new PVector(thrust * sin(radians(angle)), -thrust * cos(radians(angle)));
    thrustSound.play();
  }
  
  void noThrust() {
    acceleration = new PVector(0, 0);
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
    bullets.add(new Bullet(new PVector(position.x, position.y), angle));
    fireSound.play();
  }
  
  PVector getPosition() {
    return position;
  }
  
  int getLives() {
    return lives;
  }
  
  void loseLife() {
    lives--;
  }
}

class Bullet {
  
  PVector position;
  PVector velocity;
  float angle;
  int time;
  int flightTime;
  
  Bullet(PVector position, float angle) {
    this.position = position;
    this.angle = angle;
    velocity = new PVector(0, 0);
    time = millis();
  }
  
  void update() {
    if(millis() - time > flightTime) {
      
    }
    velocity = new PVector(8 * sin(radians(angle)), -8 * cos(radians(angle)));
    position.add(velocity);
    
    if(position.x < 0) position.x = width;
    if(position.x > width) position.x = 0;
    if(position.y < 0) position.y = height;
    if(position.y > height) position.y = 0;
  }
  
  void draw() {
    stroke(255);
    strokeWeight(2);
    point(position.x, position.y);
  }
  
  int getTime() {
    return time;
  }
  
  PVector getPosition() {
    return position;
  }
}

class Asteroid {
  
  PVector position;
  PVector velocity;
  float angle;
  int radius;
  int size;

  Asteroid(PVector position, int size) {  
    this.position = position;
    velocity = new PVector(0, 0);
    angle = random(0, 360);
    this.size = size;
    if(size == 3) this.radius = 50;
    if(size == 2) this.radius = 25;
    if(size == 1) this.radius = 12;
  }
  
  void update() {
    velocity = new PVector((1 + 2/size + level * 0.1) * sin(radians(angle)), -(1 + 2/size + level * 0.1) * cos(radians(angle)));
    position.add(velocity);
    
    if(position.x < 0) position.x = width;
    if(position.x > width) position.x = 0;
    if(position.y < 0) position.y = height;
    if(position.y > height) position.y = 0;
  }
  
  void draw() {
    noFill();
    //strokeWeight(2);
    stroke(255);
    ellipse(position.x, position.y, radius, radius);
  }
  
  PVector getPosition() {
    return position;
  }
  
  int getSize() {
    return size;
  }
}

class Level {
  int level;

  Level(int level) {
    this.level = level;
  }
  
  void init() {
    asteroids.clear();
    bullets.clear();
    player.reset();
  }
}