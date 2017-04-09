class GameObject {
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  float   angle;
  float   speed;          // Different to velocity. This is the magnitude of the position
  float   max_speed;      // Limit the top speed of game objects so the game isn't too difficult
  float   size;           // Defines how big the object is for collision detection
  
  GameObject(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = 0;
    speed = 0;
    max_speed = 0;
    size = 0;
  }
  
  GameObject(float x, float y, float angle, float speed, float max_speed, float size) {
    this(x, y);
    this.angle = angle;
    this.speed = speed;
    this.max_speed = max_speed;
    this.size = size;
  }
  
  void update() {
    /**
     * Each cycle, increase the velocity by the acceleration, then add the velocity
     * vector to the current position.
    **/
    velocity.add(acceleration);
    velocity.limit(max_speed);
    position.add(velocity);
    
    // Ensure wrap around of the screen when an object reaches the boundary of the canvas
    if(position.x < 0) position.x = width;
    if(position.x > width) position.x = 0;
    if(position.y < 0) position.y = height;
    if(position.y > height) position.y = 0;
  }
  
  PVector getPosition() { return position; }
  
  float getSize() { return size; }
  
  /**
   * Measure the distance between the objects and return true if the distance is less than
   * the sum of their sizes
  **/
  boolean checkCollision(GameObject object) {
    return position.dist(object.getPosition()) < this.size + object.getSize();
  }
}