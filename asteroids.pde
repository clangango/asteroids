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

// variables to store keyboard input state
boolean rightKey;
boolean leftKey;
boolean upKey;
boolean fire;
int weapon;

int level = 1;                         // Current game level
int score = 0;                         // Current game score
int[] asteroidScores = {20, 50, 100};  // array to store score values for asteroids and UFOs

Player player;

ArrayList<Bullet> bullets;             // Arraylist to track bullets fired by the player
ArrayList<Asteroid> asteroids;         // Arraylist to track current asteroids
ArrayList<UFO> ufos;


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
  ufos = new ArrayList<UFO>();
  thrustSound = new SoundFile(this, "thrust.wav");
  fireSound = new SoundFile(this, "fire.wav");
  ufoSound = new SoundFile(this, "ufo_lowpitch.wav");
  thrustSound.rate(0.75);
  ufoSound.rate(0.25);
  fireSound.rate(0.25);
  font = createFont("Hyperspace.otf", 32);
  startLevel(level);
}

void draw() {
  background(0);
  
  //update and draw player and asteroids
  player.draw();
  player.update();
  
  for(Asteroid asteroid: asteroids) { asteroid.draw(); asteroid.update();}
  
  // update bullets and check for collision with asteroids
  for(int i = bullets.size(); i > 0; i--) {
    Bullet bullet = (Bullet)bullets.get(i-1);
    if(millis() - bullet.getTime() > bullet.getFlightTime()) {
      bullets.remove(i-1);
    }
    bullet.draw();
    bullet.update();
    for(int j = asteroids.size(); j > 0; j--) {
      Asteroid asteroid = (Asteroid)asteroids.get(j-1);
      if(asteroid.checkCollision(bullet)) {
        bullets.remove(bullet);
        int newSize = asteroid.getSize() - 1;
        score += asteroidScores[newSize];
        println(score);
        if(newSize > 0) {
          asteroids.add(new Asteroid(asteroid.getPosition().x, asteroid.getPosition().y, newSize));
          asteroids.add(new Asteroid(asteroid.getPosition().x, asteroid.getPosition().y, newSize));
        }
        asteroids.remove(asteroid);
      }
    }
  }
  
  for(int i = asteroids.size(); i > 0; i--) {
    Asteroid asteroid = (Asteroid)asteroids.get(i-1);
    if(asteroid.checkCollision(player)) {
      player.loseLife();
      asteroids.remove(asteroid);
    }
    if(player.getLives() <= 0) {
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
      noLoop();
    }
  }
  
  float addUfo = random(1);
  
  if(ufos.size() < 1 && addUfo <= UFO.UFO_CHANCE) {
    float startX = 1;
    float startY = random(100, height - 100);
    float horizontal = random(1);    
    if(horizontal >= 0.5) startX = width - 1;
    println(startX + ", " + startY);
    ufos.add(new UFO(startX, startY));  
  }
  
  for(int i = ufos.size(); i > 0; i--) {
    UFO ufo = (UFO)ufos.get(i-1);
    if(ufo.getPosition().x <= 0 || ufo.getPosition().x >= width ||
       ufo.getPosition().y <= 0 || ufo.getPosition().y >= height) {
      ufos.remove(i-1);
      ufoSound.stop();
    } else {
      ufo.update(); 
      ufo.draw();
      if(ufo.checkCollision(player)) {
        player.loseLife();
        ufos.remove(i-1);
        ufoSound.stop();
      }
    }
    for(int j = bullets.size(); j > 0; j--) {
      Bullet bullet = (Bullet)bullets.get(j-1);
      if(ufo.checkCollision(bullet)) {
        score += 1000;
        ufos.remove(ufo);
        ufoSound.stop();
        bullets.remove(bullet);
      }
    } 
  }
  
  textFont(font);
  textAlign(LEFT);
  text(score, 30, 50);
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
  
  if(asteroids.size() == 0) {
    level++;
    asteroids.clear();
    bullets.clear();
    player.reset();
    startLevel(level);
  }
}

void keyPressed() {
  if(keyCode == UP) upKey = true;
  if(keyCode == LEFT) leftKey = true;
  if(keyCode == RIGHT) rightKey = true;
  if(key == ' ') fire = true;
  if(key == '1') weapon = 1;
}

void keyReleased() {
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
    asteroids.add(new Asteroid(startX, startY, 3));
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