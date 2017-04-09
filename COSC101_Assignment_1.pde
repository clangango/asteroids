/**
 * COSC101 Software Development Studio
 * Assignment 1
 *
 * Group 20
 *
 * @author Peter Stacey & Tim Pereira
 * @version 0.3
**/

import processing.sound.*;

// Setup Colors
final color WHITE = color(255);
final color RED = color(255, 0, 0);
final color GREEN = color(0, 255, 0);
final color ORANGE = color(255, 127, 27);

// Setup constants
final float ORIGIN_X = 0.0;
final float ORIGIN_Y = 0.0;
final float STROKE_WEIGHT = 1.0;
final float HALF_WIDTH = 1000 / 2;
final float HALF_HEIGHT = 800 / 2;

// Define UFO properties
// Change here to change behaviour of the UFO
final float UFO_ANGLE = 0.0;
final float UFO_LG_SIZE = 15.0;
final float UFO_SM_SIZE = 10.0;
final float UFO_LG_SPEED = 3.0;
final float UFO_SM_SPEED = 4.0;
final float UFO_MAX_SPEED = 5.0;
final float UFO_SM_ARRIVAL = 0.33;
final float UFO_ARRIVAL_CHANCE = 0.001;;

final int UFO_LG_POINTS = 200;
final int UFO_SM_POINTS = 1000;
final int UFO_FIRE_DELAY = 1000;

final color UFO_COLOR = GREEN;

// Define Player properties
// Change here to change behaviour of the player
final float PLAYER_ANGLE = 0.0;
final float PLAYER_SIZE = 15.0;
final float PLAYER_SPEED = 0.3;
final float PLAYER_ROTATION = 5.0;
final float PLAYER_MAX_SPEED = 10.0;
final float PLAYER_DECELERATE = 0.985;

final float[][] PLAYER_POINTS = {{-10.0, 15.0}, {0.0, -15.0},
                                 {10.0, 15.0}, {0.0, 10.0}};

final int PLAYER_START_LIVES = 3;
final int PLAYER_FIRE_DELAY = 250;
final int PLAYER_START_MISSILES = 3;
final int PLAYER_GAIN_LIFE_POINTS = 10000;

// Define Bullet properties
// Change here to change behaviour of the bullets
final float BULLET_SIZE = 0.0;
final float BULLET_SPEED = 10.0;
final float BULLET_MAX_SPEED = 10.0;

final int BULLET_FLIGHT_TIME = 800;

final color BULLET_COLOR = WHITE;

// Define Asteroid properties
// Change here to change behaviour of the asteroids
final float ASTEROID_ANGLE = 0.0;
final float ASTEROID_SPEED = 0.2;
final float ASTEROID_LG_SIZE = 30.0;
final float ASTEROID_MD_SIZE = 20.0;
final float ASTEROID_SM_SIZE = 10.0;
final float ASTEROID_MAX_SPEED = 15.0;
final float ASTEROID_BASE_VELOCITY = 1.0;

final float[][] ASTEROID_LG = {{-14.0, -26.0}, {10.0, -28.0}, 
                               {25.0, -16.0}, {27.0, 12.0}, 
                               {14.0, 26.0}, {10.0, 17.0}, 
                               {-3.0, 29.0}, {-28.0, 9.0}, 
                               {-18.0, 0.0}, {-28.0, -8.0}, 
                               {-15.0, -15.0}};
                             
final float[][] ASTEROID_MD = {{-8.0, -17.0}, {0.0, -16.0}, 
                               {7.0, -18.0}, {15.0, -12.0}, 
                               {20.0, 0.0}, {17.0, 8.0}, 
                               {10.0, 17.0}, {-1.0, 15.0}, 
                               {-7.0, 18.0}, {-15.0, 13.0}, 
                               {-20.0, 2.0}, {-17.0, -4.0}, 
                               {-16.0, -12.0}};
                              
final float[][] ASTEROID_SM = {{0.0, -9.0}, {5.0, -8.0}, 
                               {9.0, -2.0}, {5.0, 4.0}, 
                               {7.0, 5.0}, {5.0, 7.0}, 
                               {0.0, 10.0}, {-5.0, 7.0}, 
                               {-10.0, 0.0}, {-6.0, -6.0}, 
                               {-5.0, -9.0}, {-1.0, -9.0}};
                               
final int ASTEROID_LG_POINTS = 20;
final int ASTEROID_MD_POINTS = 50;
final int ASTEROID_SM_POINTS = 100;

final color ASTEROID_COLOR = WHITE;


// Define Missile properties
// Change here to change behaviour of the missile
final float MISSILE_SIZE = 2.0;
final float MISSILE_ANGLE = 0.0;
final float MISSILE_SPEED = 0.5;
final float MISSILE_MAX_SPEED = 7.0;
final float MISSILE_ACCELERATION = 0.5;
final float MISSILE_MAX_ACCELERATION = 0.5;
final float MISSILE_DIRECTION_CHANGE_FORCE = 0.1;

final int MISSILE_FLIGHT_TIME = 1600;

// Define Explosion properties
// Change here to change behaviour of the explosions
final int EXPLOSION_FLIGHT_TIME = 1000;
final int EXPLOSION_PARTICLE_COUNT = 20;

final float PARTICLE_SIZE = 1.0;
final float PARTICLE_ANGLE = 0.0;
final float PARTICLE_MAX_SPEED = 10.0;

final color PARTICLE_COLOR = ORANGE;

// Keyboard input variables
boolean fire;
boolean upKey;
boolean leftKey;
boolean rightKey;

Game game;

SoundFile ufoSound;
SoundFile fireSound;
SoundFile thrustSound;
SoundFile extraLifeSound;
SoundFile backgroundSound;
SoundFile missileLaunchSound;
SoundFile smallExplosionSound;
SoundFile largeExplosionSound;
SoundFile mediumExplosionSound;

PImage bgImage;
PImage instructions;

PFont hyperspace;

void setup() {
  size(1000, 800);
  
  bgImage = loadImage("bg.jpg");
  instructions = loadImage("instructions.png");
  
  hyperspace = createFont("Hyperspace.otf", 32);
  
  // set sounds and sampling rate. Game FPS = 60, so the sound plays too high pitch if not slowed down
  fireSound = new SoundFile(this, "fire.wav");
  thrustSound = new SoundFile(this, "thrust.wav");
  ufoSound = new SoundFile(this, "ufo_lowpitch.wav");
  extraLifeSound = new SoundFile(this, "extraShip.wav");
  smallExplosionSound = new SoundFile(this, "bangSmall.wav");
  largeExplosionSound = new SoundFile(this, "bangLarge.wav");
  mediumExplosionSound = new SoundFile(this, "bangMedium.wav");
  missileLaunchSound = new SoundFile(this, "missileLaunch.wav");
  
  ufoSound.rate(0.25);
  fireSound.rate(0.25);
  thrustSound.rate(0.35);  // 0.35 = the most pleasing ship acceleration sound
  extraLifeSound.rate(0.25);
  missileLaunchSound.rate(0.25);
  smallExplosionSound.rate(0.25);
  largeExplosionSound.rate(0.25);
  mediumExplosionSound.rate(0.25);
  
  game = new Game();
}

void draw() {
  background(0);
  game.update();
}

void keyPressed() {
  if(key == ' ') fire = true;
  if(keyCode == UP) upKey = true;
  if(key == '1') game.setWeapon(1);
  if(key == '2') game.setWeapon(2);
  if(keyCode == LEFT) leftKey = true;
  if(keyCode == RIGHT) rightKey = true;
  if(key == 'p' || key == 'P') pause();
}

void keyReleased() {
  if(key == ' ') fire = false;
  if(keyCode == UP) upKey = false;
  if(key == '2') game.setWeapon(1);
  if(keyCode == LEFT) leftKey = false;
  if(keyCode == RIGHT) rightKey = false;
  if(key == 'z' || key == 'Z') game.player.warp();
}

void mouseClicked() {
  // Cycle through the screens, depending on current screen
  // Screens are:
  // "instructions": pre-game display of the instructions
  // "play": while playing or paused
  // "gameOver": end of the game state
  if(game.getScreen() == "instructions") {
    game.setScreen("play");
  }
  if (game.getScreen() == "gameOver") {
    game.startGame();
    game.setScreen("instructions");
  }
}

void pause() {
  if(looping) {
    textAlign(CENTER);
    text("PAUSED", HALF_WIDTH, HALF_HEIGHT);
    text("Press P to continue", HALF_WIDTH, HALF_HEIGHT + 50);
    noLoop();
  } else loop();
}

/**
 * Function to add additional "0" to the front (left) of the score,
 * to ensure standard width of score on the screen.
**/
String leftPad(String value, String character, int length) {
  int padLength = length - value.length();
  String paddedString = "";
  for(int i = 0; i < padLength; i++) paddedString += character;
  return paddedString + value;
}