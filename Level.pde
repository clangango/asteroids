class Level {
  
  int level;
  Player player;

  Level(int level, Player player) {
    this.level = level;
    this.player = player;
  }
  
  void start() {
    
    // add asteroids n = 2 + 2 * level (level 1 = 4, level 2 = 6, level 3 = 8, etc.)
    for(int i = 0; i < (2 + level * 2); i++) {
      
      float startX, startY;
      
      // determine of the asteroid should be on the left or right of the canvas
      float leftRight = random(0, 1);
      
      // determin if the asteroid should be on the top or bottom
      float topBottom = random(0, 1);
      
      // pick x and y values so that asteroids cannot begin the game on top of the ship.
      // if left, start x within 200 pixels of 0, otherwise within 200 pixels of the width
      if(leftRight < 0.5) { startX = random(0, 200); }
      else { startX = random(width - 200, width);}
      if(topBottom < 0.5) { startY = random(0, height/2 - 200);}
      else { startY = random(height/2 + 200, height);}
      
      // create asteroid at the random position near the edge of the screen
      asteroids.add(new Asteroid(startX, startY, 3));
    }
    // reset the player back to start position
    player.reset();
  }
  
  int getLevel() {
    return level;
  }
  
  void setLevel(int level) {
    this.level = level;
  }
  
  boolean shouldLevel(ArrayList<Asteroid> asteroids, UFO ufo) {
    if(asteroids.size() == 0 && ufo == null) return true;
    return false;
  }
}