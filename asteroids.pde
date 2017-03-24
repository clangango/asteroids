/**
 * COSC101 Software Development Studio
 * Assignment 1
 *
 * Group 20
 *
 * @author Peter Stacey, Tim Pereira, T McCormack
 * @version 0.1
**/

import processing.sound.*;

final int[] asteroidScores = { 100, 50, 20 };  // array to store points values for asteroids
final int[] ufoScores = { 1000 };

// variables to store keyboard input
boolean rightKey;
boolean leftKey;
boolean upKey;
boolean fire;
int weapon;
boolean paused;

int score = 0;                         // Current game score

Player player;
Level level;

ArrayList<Bullet> bullets;             // Arraylist to track bullets fired by the player
ArrayList<Asteroid> asteroids;         // Arraylist to track current asteroids
ArrayList<Bullet> ufoBullets;          // Arraylist to track UFOs shooting at the player
UFO ufo;

// Sounds
SoundFile thrustSound;
SoundFile fireSound;
SoundFile ufoSound;

// Font
PFont font;

void setup() {
  
  size(1000, 800);
  
  player = new Player();
  bullets = new ArrayList<Bullet>();
  asteroids = new ArrayList<Asteroid>();
  ufoBullets = new ArrayList<Bullet>();
  ufo = null;
  
  // prior to the game starting, the level does not exist. Set to 0
  level = new Level(0, player);                              
  
  font = createFont("Hyperspace.otf", 32);
  
  // set sounds and sampling rate. Game FPS = 60, so the sound plays too high pitch if not slowed down
  thrustSound = new SoundFile(this, "thrust.wav");
  fireSound = new SoundFile(this, "fire.wav");
  ufoSound = new SoundFile(this, "ufo_lowpitch.wav");
  thrustSound.rate(0.8);
  ufoSound.rate(0.25);
  fireSound.rate(0.25);
}

void draw() {
  // clear the canvas each loop
  background(0);
  
  // check if UFO appears
  if(ufo == null && random(1) <= UFO.UFO_CHANCE) { addUfo(); }
  
  // update and draw player, asteroids, bullets and ufos
  tickGameObjects();
  
  // check for bullet->asteroid collisions
  collisionBulletAsteroid();
  
  // check for bullet->UFO collisions
  collisionBulletUfo();
  
  // check for asteroid->player collisions
  collisionAsteroidPlayer();
  
  // check for UFO->player collisions
  collisionUfoPlayer();
  
  // check for UFO Bullet->player collision
  collisionUFOBulletPlayer();
  
  // check if UFO disappears
  checkUfoOffScreen();
  
  displayScore();
  displayPlayerLives();
  
  checkGameOver();
  checkLevelOver();
}

void keyPressed() {
  if(keyCode == UP) upKey = true;
  if(keyCode == LEFT) leftKey = true;
  if(keyCode == RIGHT) rightKey = true;
  if(key == ' ') fire = true;
  if(key == '1') weapon = 1;
  
  // pause for the game
  if(key == 'p' || key == 'P') {
    if(looping) noLoop();
    else loop();
  }
}

void keyReleased() {
  if(keyCode == UP) upKey = false;
  if(keyCode == LEFT) leftKey = false;
  if(keyCode == RIGHT) rightKey = false;
  if(key == ' ') fire = false;
  if(key == 'z' || key == 'Z') player.warp();
}

void displayScore() {
  textFont(font);
  textAlign(LEFT);
  text(score, 30, 50);
}

void displayPlayerLives() {
  stroke(255);
  for(int i = 0; i < player.getLives(); i++) {
    pushMatrix();
    strokeWeight(1);
    translate(30 + i * 30, 90);
    line(-10, 15, 0, -15);
    line(0, -15, 10, 15);
    line(10, 15, 0, 10);
    line(0, 10, -10, 15); 
    popMatrix();
  }
}

void checkLevelOver() {
  if(level.shouldLevel(asteroids, ufo)) {
    level.setLevel(level.getLevel() + 1);
    level.start();
  }
}

void breakAsteroid(int size, PVector position) {  
  if(size - 1 > 0) {
    asteroids.add(new Asteroid(position.x, position.y, size - 1));
    asteroids.add(new Asteroid(position.x, position.y, size - 1));
  }
}

void checkGameOver() {
  if(player.getLives() <= 0) {
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    noLoop();
  }
}

void addUfo() {
  float startX = 1;  // default to start on the left side of the canvas
  float startY = random(150, height - 150);    
  if(random(1) >= 0.5) startX = width - 1;  // if should start on the right, set startX to the right side
  ufo = new UFO(startX, startY);
}

void asteroidHit(Asteroid asteroid, Bullet bullet) {
  // collision occured. Add score, split the asteroid and remove the bullet and old asteroid
  addScore(asteroidScores[asteroid.getSize() - 1]);
  breakAsteroid(asteroid.getSize(), asteroid.getPosition());
  bullets.remove(bullet);
  asteroids.remove(asteroid);
}

void tickGameObjects() {
  player.draw(); 
  player.update();
  for(Asteroid asteroid: asteroids) { asteroid.draw(); asteroid.update(); }
  for(Bullet bullet: bullets) { bullet.draw(); bullet.update(); }
  if(ufo != null) {ufo.draw(); ufo.update(); }
  for(Bullet bullet: ufoBullets) { bullet.draw(); bullet.update(); }
}

void collisionBulletAsteroid() {
  // bullet->asteroid collisions
  for(int i = bullets.size(); i > 0; i--) {
    Bullet bullet = (Bullet)bullets.get(i-1);
    // check for collision between bullet and asteroid
    for(int j = asteroids.size(); j > 0; j--) {
      Asteroid asteroid = (Asteroid)asteroids.get(j-1);
      if(asteroid.checkCollision(bullet)) {
        asteroidHit(asteroid, bullet);
      }
    }
    // remove bullets that have reached their lifetime limit
    if(bullet.shouldEnd()) bullets.remove(bullet);
  }
}

void collisionUFOBulletPlayer() {
  for(int i =  ufoBullets.size(); i > 0; i--) {
    Bullet bullet = (Bullet)ufoBullets.get(i-1);
    if(player.checkCollision(bullet)) {
      player.loseLife();
      ufoBullets.remove(bullet);
    }
    if(bullet.shouldEnd()) ufoBullets.remove(bullet);
  }
}

void collisionAsteroidPlayer() {
  for(int i = asteroids.size(); i > 0; i--) {
    Asteroid asteroid = (Asteroid)asteroids.get(i-1);
    if(asteroid.checkCollision(player)) {
      player.loseLife();
      asteroids.remove(asteroid);
    }
  }
}

void collisionUfoPlayer() {
  if(ufo != null) {
    if(ufo.checkCollision(player)) {
      player.loseLife();
      ufo = null;
      ufoSound.stop();
    }
  }
}

void collisionBulletUfo() {
  if(ufo != null) {
    for(int i = bullets.size(); i > 0; i--) {
      Bullet bullet = (Bullet)bullets.get(i-1);
      if(ufo.checkCollision(bullet)) {
        addScore(ufoScores[0]);
        ufo = null;
        ufoSound.stop();
        bullets.remove(bullet);
        return;
      }
    }
  }
}

void checkUfoOffScreen() {
  if(ufo != null && ufo.isOffScreen()) {
      ufo = null;
      ufoSound.stop();
  }
}

void addScore(int amount) {
  if((score + amount) / 10000 != score / 10000) player.addLife();
  score += amount;
}