class Level {
  
  int level;

  Level(int level) {
    this.level = level;
  }
  
  void start() {
    /**
     * Formula for the number of asteroids is:
     * 2 asteroids + 2 * level
     * At level 1: 2 + 2 * 1 = 4
     * At level 2: 2 + 2 * 2 = 6
     * At level 3: 2 + 2 * 3 = 8
     * Starts game with 4 Asteroids and increases by 2 per level
    **/
    for(int i = 0; i < (2 + level * 2); i++) {
      
      float startX, startY;
      
      // determine of the asteroid should be on the left or right of the canvas
      // <0.5 = left
      // >= 0.5 = right
      float leftRight = random(0, 1);
      
      // determine if the asteroid should be on the top or bottom of the canvas
      // <0.5 = top
      // >=0.5 = bottom
      float topBottom = random(0, 1);
      
      // pick x and y values so that asteroids cannot begin the game on top of the ship.
      // if left, start x within 200 pixels of 0, otherwise within 200 pixels of the width
      if(leftRight < 0.5) { startX = random(0, 200); }
      else { startX = random(width - 200, width);}
      if(topBottom < 0.5) { startY = random(0, height/2 - 200);}
      else { startY = random(height/2 + 200, height);}
      
      // create asteroid at the random position near the edge of the screen
      game.asteroids.add(new Asteroid(startX, startY, ASTEROID_LG_SIZE));
    }
    // reset the player back to start position
    game.player.reset();
  }
  
  int getLevel() {
    return level;
  }
  
  void setLevel(int level) {
    this.level = level;
  }
  
  boolean shouldEnd() {
    // End the level if all asteroids are destroyed and no UFO on screen
    return game.asteroids.size() == 0 && game.ufo == null;
  }
}