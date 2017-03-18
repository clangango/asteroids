class Asteroid extends GameObject {
  
  int radius;
  int size;
  float scale;
  PShape aShape;

  Asteroid(float x, float y, int size) {
    super(x, y);
    angle = random(360);
    this.size = size;
    velocity.x = (1 + 1/size + level * 0.2) * sin(radians(angle));
    velocity.y = (1 + 1/size + level * 0.2) * -cos(radians(angle));
    if(size == 3) { radius = 50; scale=1; }
    if(size == 2) { radius = 25; scale=0.5; }
    if(size == 1) { radius = 12; scale = 0.25; }

    aShape = createShape();
    aShape.beginShape();
    aShape.noFill();
    aShape.stroke(255);
    aShape.vertex(0, -30);
    aShape.vertex(25,-10);
    aShape.vertex(27, 5);
    aShape.vertex(20, 30);
    aShape.vertex(-5, 30);
    aShape.vertex(-10, 20);
    aShape.vertex(-25, 25);
    aShape.vertex(-30, 5);
    aShape.vertex(-30, 0);
    aShape.vertex(-20, -10);
    aShape.vertex(-25, -25);
    aShape.endShape(CLOSE);
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    scale(scale);
    strokeWeight(1.0/scale);
    shape(aShape, 0, 0);
    popMatrix();
  }
  
  int getSize() {
    return size;
  }
  
  int getRadius() {
    return radius;
  }
  
  boolean checkCollision(GameObject object) {
    if(position.dist(object.getPosition()) < radius) return true;
    return false;
  }
}