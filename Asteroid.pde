class Asteroid extends GameObject {
  
  int radius;
  int size;
  float scale;
  
  PShape largeShape;
  PShape mediumShape;
  PShape smallShape;

  Asteroid(float x, float y, int size) {
    super(x, y);
    angle = random(360);
    this.size = size;
    velocity.x = (1 + 1/size + level.getLevel() * 0.2) * sin(radians(angle));
    velocity.y = (1 + 1/size + level.getLevel() * 0.2) * -cos(radians(angle));
    
    // set the radius for collision detection **** FIX THIS ****
    // set the scale for the size to draw     **** FIX THIS - ADD MORE SHAPES ****
    radius = size * 10;

    // create the large asteroid shape
    largeShape = createShape();
    largeShape.beginShape();
    largeShape.noFill();
    largeShape.stroke(255);
    largeShape.vertex(-10, -30);
    largeShape.vertex(14, -30);
    largeShape.vertex(30, -10);
    largeShape.vertex(30, 10);
    largeShape.vertex(16, 30);
    largeShape.vertex(0, 30);
    largeShape.vertex(0, 6);
    largeShape.vertex(-16, 26);
    largeShape.vertex(-30, 8);
    largeShape.vertex(-16, 0);
    largeShape.vertex(-30, -8);
    largeShape.endShape(CLOSE);
    
    // create the medium asteroid shape
    mediumShape = createShape();
    mediumShape.beginShape();
    mediumShape.noFill();
    mediumShape.stroke(255);
    mediumShape.strokeWeight(1);
    mediumShape.vertex(-7, -15);
    mediumShape.vertex(4, -15);
    mediumShape.vertex(15, -6);
    mediumShape.vertex(4, 0);
    mediumShape.vertex(15, 6);
    mediumShape.vertex(7, 15);
    mediumShape.vertex(3, 8);
    mediumShape.vertex(-6, 14);
    mediumShape.vertex(-15, 5);
    mediumShape.vertex(-15, -8);
    mediumShape.vertex(-4, -8);
    mediumShape.endShape(CLOSE);
    
    // create the medium asteroid shape
    smallShape = createShape();
    smallShape.beginShape();
    smallShape.noFill();
    smallShape.stroke(255);
    smallShape.strokeWeight(1);
    smallShape.vertex(-4, -10);
    smallShape.vertex(4, -10);
    smallShape.vertex(10, -3);
    smallShape.vertex(8, -1);
    smallShape.vertex(10, 1);
    smallShape.vertex(4, 10);
    smallShape.vertex(0, 10);
    smallShape.vertex(0, 1);
    smallShape.vertex(-5, 10);
    smallShape.vertex(-10, 2);
    smallShape.vertex(-5, 1);
    smallShape.vertex(-10, -4);
    smallShape.endShape(CLOSE);
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(angle));
    if(size == 3) shape(largeShape, 0, 0);
    if(size == 2) shape(mediumShape, 0, 0);
    if(size == 1) shape(smallShape, 0, 0);
    popMatrix();
  }
  
  int getSize() {
    return size;
  }
  
  int getRadius() {
    return radius;
  }
  
  boolean checkCollision(GameObject object) {
    return super.checkCollision(object, radius);
  }
}