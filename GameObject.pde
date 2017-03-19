abstract class GameObject {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float angle;
  
  GameObject(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    angle = 0;
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    
    // ensure wrap around of the canvas
    if(position.x < 0) position.x = width;
    if(position.x > width) position.x = 0;
    if(position.y < 0) position.y = height;
    if(position.y > height) position.y = 0;
  }
  
  PVector getPosition() {
    return position;
  }
}