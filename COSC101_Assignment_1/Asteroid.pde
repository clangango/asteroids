class Asteroid extends GameObject {
  
  int points;
  
  PShape asteroidShape;

  Asteroid(float x, float y, float size) {
    super(x, y, ASTEROID_ANGLE, ASTEROID_SPEED, ASTEROID_MAX_SPEED, size);
    // Change the angle of movement to a random value 0 - 360 degrees
    angle = random(360);
    // Set velocity to change based on asteroid size and game level. 
    // Asteroids will move faster as they get smaller and faster as the
    // player advances more levels.
    velocity.x = (ASTEROID_BASE_VELOCITY + 1.0/(size/10) + game.level.getLevel() * this.speed) * sin(radians(angle));
    velocity.y = (ASTEROID_BASE_VELOCITY + 1.0/(size/10) + game.level.getLevel() * this.speed) * -cos(radians(angle));
    
    // get the correct set of vertices based on the size of the asteroid
    float[][] vertices = getVertices(size);
    
    asteroidShape = createShape();
    asteroidShape.beginShape();
    asteroidShape.noFill();
    asteroidShape.stroke(ASTEROID_COLOR);
    asteroidShape.strokeWeight(STROKE_WEIGHT);
    for(float[] points: vertices) {
      asteroidShape.vertex(points[0], points[1]);
    }
    asteroidShape.endShape(CLOSE);
    
    if(size == ASTEROID_LG_SIZE) { points = ASTEROID_LG_POINTS; }
    if(size == ASTEROID_MD_SIZE) { points = ASTEROID_MD_POINTS; }
    if(size == ASTEROID_SM_SIZE) { points = ASTEROID_SM_POINTS; }
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    shape(asteroidShape, ORIGIN_X, ORIGIN_Y);
    popMatrix();
  }
  
  int getPoints() { return points; }
  
  float[][] getVertices(float size) {
    // return the correct array of vertices for the size of the asteroid
    if(size == ASTEROID_SM_SIZE) { return ASTEROID_SM; }
    if(size == ASTEROID_MD_SIZE) { return ASTEROID_MD; }
    return ASTEROID_LG;
  }
  
  void breakAsteroid(int size, PVector position) {
    // If the asteroid is not the small size, break it into two smaller asteroids
    // If the asteroid is the smallest asteroid, do nothing further
    if(size - 10 > 0) {
      game.asteroids.add(new Asteroid(position.x, position.y, (size - 10)));
      game.asteroids.add(new Asteroid(position.x, position.y, (size - 10)));
    }
  }
}