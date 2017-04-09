class Game {
  
  UFO ufo;
  Level level;
  Player player;          
  Missile missile;
  
  int score;
  int highScore;  // Keep a record of the highest score achieved since the program began
  
  ArrayList<Bullet> bullets;
  ArrayList<Missile> missiles;
  ArrayList<Bullet> ufoBullets;
  ArrayList<Asteroid> asteroids;         
  ArrayList<Explosion> explosions;
  
  String screen;

  Game() {
    score = 0;
    ufo = null;
    highScore = 0;
    missile = null;
    level = new Level(0);  // level is initially 0 before the start of the game. Advances to 1 when the game starts
    player = new Player();
    screen = "instructions";  // Set initial screen to show instructions on click of mouse
    bullets = new ArrayList<Bullet>();
    ufoBullets = new ArrayList<Bullet>();
    asteroids = new ArrayList<Asteroid>();
    explosions = new ArrayList<Explosion>();
  }
  
  void update() {
    if(screen == "instructions") startScreen(); // Show the start screen if instructions are showing
    else playGame(); // Otherwise show the game screen
  }
  
  void setWeapon(int weapon) {
    switch(weapon) {
      case 1:
        player.setWeapon("bullet");
        break;
      case 2:
        player.setWeapon("missile");
        break;
      default: // Default weapon is the bullet
        player.setWeapon("bullet");  
    }
  }
  
  void startScreen() {
    textAlign(CENTER);
    textFont(hyperspace);
    // Display current high score at top centre
    textSize(20);
    text(leftPad(str(highScore), "0", 2), HALF_WIDTH, 50);
    // Display the player score at top left
    textSize(36);
    textAlign(LEFT);
    text(leftPad(str(score), "0", 2), 30, 50);
    textAlign(CENTER);
    // Provide instruction to click mouse to play
    text("Click mouse to start", HALF_WIDTH ,150);
    imageMode(CENTER);
    textSize(18);
    // Show the instructions image
    image(instructions, HALF_WIDTH + 4, 393);
    // Display information about the team at the centre bottom of the canvas
    text("COSC101 - Group 20", HALF_WIDTH, height - 50);
    text("Peter Stacey & Tim Periera", HALF_WIDTH, height - 20);
  }
  
  void startGame() {
    // Set all initial values to their starting values
    ufo = null;
    score = 0;
    missile = null;
    player.reset();
    player.lives = PLAYER_START_LIVES;
    player.setMissiles(PLAYER_START_MISSILES);
    bullets.clear();
    asteroids.clear();
    ufoBullets.clear();
    level = new Level(0);
  }
  
  void playGame() {
    // Show the background image
    imageMode(CORNER);
    image(bgImage, 0, 0);
    
    // Draw and update all game objects in turn
    player.draw();
    player.update();
    if(ufo != null) { ufo.draw(); ufo.update(); }
    if(missile != null) { missile.draw(); missile.update(); }
    for(Bullet bullet: bullets) { bullet.draw(); bullet.update(); }
    for(Bullet bullet: ufoBullets) { bullet.draw(); bullet.update(); }
    for(Asteroid asteroid: asteroids) { asteroid.draw(); asteroid.update(); }
    explosionsUpdate();
    
    // If the player is "active", check for collisions
    if(player.getState() == "active") {
      if(ufo == null && random(1) <= UFO_ARRIVAL_CHANCE) { addUfo(); }
      checkPlayerBulletsHit();
      checkUFOBulletsHit();
      checkMissileHit();
      checkAsteroidPlayerCollision();
      checkUfoPlayerCollision();
    }
    
    // If there is a missile, check to see if it should disappear
    // whether the player is "active", "exploding" or "dead"
    if(missile != null) {
      // remove missiles that have reached their lifetime limit
      if(missile.shouldEnd()) {
        missileLaunchSound.stop();
        missile = null;
      }
    }
    
    displayScore();
    displayPlayerLives();
    displayRemainingMissiles();

    if(player.getLives() <= 0) { gameOver(); }
    
    // If there are no asteroids or UFOs left, advance to the next level
    if(level.shouldEnd()) {
      level.setLevel(level.getLevel() + 1);
      level.start();
    }
    
    // Remove the UFO when it goes off screen
    if(ufo != null && ufo.isOffScreen()) { ufo = null; }
  }
  
  // Update, draw and remove all explosions
  void explosionsUpdate() {
    for(int i = explosions.size(); i > 0; i--) {
      Explosion explosion = (Explosion)explosions.get(i - 1);
      if(!explosion.shouldEnd()) {
        explosion.update();
        explosion.draw();
      } else {
        explosions.remove(explosion);
      }
    }
  }
  
  void addUfo() {
    float startX = 1; // Set default start side to the left, 1 pixel into the canvas
    float startY = random(150, height - 150);  // start the UFO a bit down from the top and up from the bottom of the canvas
    if(random(1) >= 0.5) startX = width - 1;  // If starting on the right, set x position to the right of the screen
    float ufoSize = random(1);  // Generate a random number to determine if a "small" or "large" UFO
    if(ufoSize <= UFO_SM_ARRIVAL) { 
      ufo = new UFO(startX, startY, "small");
    } else { 
      ufo = new UFO(startX, startY, "large"); 
    }
  }
  
  // Collision detection for bullets shot by the player
  // Checks each bullet against the asteroids and UFO
  void checkPlayerBulletsHit() {
    for(int i = bullets.size(); i > 0; i--) {
      Bullet bullet = (Bullet)bullets.get(i-1);
      // check for collision between bullet and asteroid
      for(int j = asteroids.size(); j > 0; j--) {
        Asteroid asteroid = (Asteroid)asteroids.get(j - 1);
        if(asteroid.checkCollision(bullet)) {
          splitAsteroid(asteroid);
          bullets.remove(bullet);
          asteroids.remove(asteroid);
        }
      }
      // check for collision between bullet and UFO
      if(ufo != null) {
        if(ufo.checkCollision(bullet)) {
          ufoSound.stop();
          mediumExplosionSound.play();
          addScore(int(ufo.getPoints()));
          explosions.add(new Explosion(ufo.getPosition(), color(GREEN)));
          ufo = null;
          bullets.remove(bullet);
          return;
        }
      }
      // remove bullets that have reached their lifetime limit
      if(bullet.shouldEnd()) bullets.remove(bullet);
    }
  }
  
  // Check to see if any bullets fired by a UFO have hit the player
  void checkUFOBulletsHit() {
    for(int i =  ufoBullets.size(); i > 0; i--) {
      Bullet bullet = (Bullet)ufoBullets.get(i - 1);
      if(player.checkCollision(bullet)) {
        killPlayer();
        ufoBullets.remove(bullet);
        return;
      }
      if(bullet.shouldEnd()) ufoBullets.remove(bullet);
    }
  }
  
  // Check to see if a missile fired by the player has hit 
  // an asteroid or UFO
  void checkMissileHit() {
    if(missile != null) {
      // missile-> asteroid collision
      for(int j = asteroids.size(); j > 0; j--) {
        Asteroid asteroid = (Asteroid)asteroids.get(j-1);
        if(asteroid.checkCollision(missile)) {
          splitAsteroid(asteroid);
          missile = null;
          missileLaunchSound.stop();
          asteroids.remove(asteroid);
          return;
        } 
      }
      if(ufo != null) {
        if(missile.checkCollision(ufo)) {
          addScore(int(ufo.getPoints()));
          explosions.add(new Explosion(ufo.getPosition(), color(GREEN)));
          missile = null;
          missileLaunchSound.stop();
          mediumExplosionSound.play();
          ufo = null;
          ufoSound.stop();
          return;
        }
      }
    }
  }
  
  // See if the player has run into or been hit by an asteroid
  void checkAsteroidPlayerCollision() {
  for(int i = asteroids.size(); i > 0; i--) {
      Asteroid asteroid = (Asteroid)asteroids.get(i - 1);
      if(asteroid.checkCollision(player)) {
        killPlayer();
        explosions.add(new Explosion(asteroid.getPosition(), color(ORANGE)));
        asteroids.remove(asteroid);
      }
    }
  }
  
  // See if the player and a UFO collide
  void checkUfoPlayerCollision() {
    if(ufo != null) {
      if(ufo.checkCollision(player)) {
        killPlayer();
        explosions.add(new Explosion(player.getPosition(), color(GREEN)));
        ufo = null;
        ufoSound.stop();
      }
    }
  }
  
  // If the asteroid has been hit by a bullet, attempt to split it, explode it and play
  // and explosion sound based on the size
  void splitAsteroid(Asteroid asteroid) {
    addScore(int(asteroid.getPoints()));
    asteroid.breakAsteroid(int(asteroid.getSize()), asteroid.getPosition());
    if(asteroid.getSize() == 30) largeExplosionSound.play();
    if(asteroid.getSize() == 20) mediumExplosionSound.play();
    if(asteroid.getSize() == 10) smallExplosionSound.play();
    explosions.add(new Explosion(asteroid.getPosition(), color(ORANGE)));
  }
  
  // Oops, the player has died. Lose a life, explode the player
  // Destroy any missile on the screen
  void killPlayer() {
    player.loseLife();
    player.explode();
    if(missile != null) destroyMissile();
  }
  
  void destroyMissile() {
    missileLaunchSound.stop();
    explosions.add(new Explosion(missile.getPosition(), color(WHITE)));
    missile = null;
  }
  
  // Check to see if the player should gain a life (each 10000 points)
  // and add the points to the score
  void addScore(int amount) {
    if((score + amount) / PLAYER_GAIN_LIFE_POINTS != score / PLAYER_GAIN_LIFE_POINTS) player.addLife();
    score += amount;
  }
  
  void displayScore() {
    textFont(hyperspace);
    textAlign(LEFT);
    textSize(36);
    text(leftPad(str(score), "0", 2), 30, 50);
  }
  
  void displayPlayerLives() {
    stroke(WHITE);
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
  
  void displayRemainingMissiles() {
    stroke(WHITE);
    noFill();
    for(int i = 0; i < player.getMissiles(); i++) {
      pushMatrix();
      strokeWeight(1);
      translate(30 + i * 15, height - 40);
      beginShape();
      vertex(-5.0, -5.0);
      vertex(0.0, -15.0);
      vertex(5.0, -5.0);
      endShape(CLOSE);
      quad(-5.0, -5.0, 5.0, -5.0, 2.0, 10.0, -2.0, 10.0);
      popMatrix();
    }
  }
  
  // If the game is over, display a message in screen, set the player to "dead" and clear all bullets
  void gameOver() {
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    text("Click mouse to start new game", width/2, height/2 + 50);
    if(score > highScore) highScore = score;
    textSize(20);
    text(leftPad(str(highScore), "0", 2), width/2, 50);
    player.setState("dead");
    screen = "gameOver";
    bullets.clear();
    ufoBullets.clear();
  }
  
  void setScreen(String screen) { this.screen = screen; }
  
  String getScreen() { return screen; }
}