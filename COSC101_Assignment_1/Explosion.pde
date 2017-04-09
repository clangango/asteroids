class Explosion {
  
  int startTime; // time the explosion starts. Determines when to stop it.
  
  ArrayList<Particle> particles;

  Explosion(PVector position, color c) {
    particles = new ArrayList<Particle>();
    startTime = millis();
    for(int i = 0; i < EXPLOSION_PARTICLE_COUNT; i++) {
      particles.add(new Particle(position, c));
    }    
  }
  
  void update() {
    for(Particle particle: particles) {
      particle.update();
      particle.draw();
    }
  }
  
  void draw() {
    for(Particle particle: particles) {
      particle.draw();
    }
  }
  
  boolean shouldEnd() { 
    return millis() - startTime > EXPLOSION_FLIGHT_TIME; 
  }
}

class Particle extends GameObject {

  color particleColor;
  
  Particle(PVector position, color c) {
    super(position.x, position.y, PARTICLE_ANGLE, random(2), PARTICLE_MAX_SPEED, PARTICLE_SIZE);
    angle = random(360); // random angle of travel 0 - 360 degrees for each particle in the explosion
    velocity.x = this.speed * sin(radians(angle));
    velocity.y = -this.speed * cos(radians(angle));
    particleColor = c;
  }
  
  void draw() {
    pushMatrix();
    stroke(particleColor);
    strokeWeight(1);
    translate(position.x, position.y);
    point(0, 0);
    popMatrix();
  }
}