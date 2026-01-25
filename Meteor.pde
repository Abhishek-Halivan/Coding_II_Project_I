class Meteor {
  float x;
  float y;
  float d; // Random meteorite size
  float r;
  float speedx;
  float speedy;
  color ballColor;
  ArrayList<PVector> fireTail;
  int tailLength = 10;
  float rotation = 0;
  float rotationSpeed;
  float[] rockVertices; // For irregular shape
  boolean active = true; // Track if meteor is still in play
  
  Meteor(float d) {
    this.x = random(width);
    this.y = 20;
    this.speedx = 0; // No horizontal movement
    this.speedy = random(2, 4); // Only downward movement
    // Dark rocky meteorite colors
    float colorType = random(1);
    if (colorType < 0.5) {
      this.ballColor = color(70, 50, 35); // Dark brown
    } else {
      this.ballColor = color(60, 60, 65); // Dark gray
    }
    this.d = d;
    this.r = d/2;
    this.fireTail = new ArrayList<PVector>();
    this.rotationSpeed = random(-0.12, 0.12);
    
    // Create irregular rock vertices
    rockVertices = new float[8];
    for (int i = 0; i < 8; i++) {
      rockVertices[i] = random(0.75, 1.15);
    }
  }
  
  Meteor() {
    this(random(10, 30)); // Random size between 12 and 24 pixels
  }
  
  boolean intersects(Shape s) {
    float distX = 
      abs((this.x + this.r/2) - (s.x + s.w/2));
    float distY = 
      abs((this.y + this.r/2) - (s.y + s.h/2));
    
    println(distX + ":" + distY);
    
    //half widths
    float combinedHW = this.r + s.w/2;
    //half heights
    float combinedHH = this.r + s.h/2;
    if ((distX < combinedHW) && (distY < combinedHH)) {
      return true;
    } else {
      return false;
    }
  }

  void setPosition(Shape topWall, Shape bottomWall, 
    Shape leftWall, Shape rightWall, Shape paddle ) {
    // Meteors only fall down, so only check bottom wall and paddle
    if (this.intersects(bottomWall)) {
      active = false; // Mark this meteor as inactive
    } else if (this.intersects(paddle)) {
      speedy = speedy*-1; // Bounce off spaceship
    }
    
    // Track fire tail positions
    fireTail.add(new PVector(this.x, this.y));
    if (fireTail.size() > tailLength) {
      fireTail.remove(0);
    }
    
    this.x = this.x + 1*speedx;
    this.y = this.y + 1*speedy;
    this.rotation += rotationSpeed;
  }

  void draw() {
    // Draw fire tail (dramatic effect)
    noStroke();
    for (int i = 0; i < fireTail.size(); i++) {
      PVector pos = fireTail.get(i);
      float progress = (float)i / fireTail.size();
      
      // Outer orange flame layer
      float outerAlpha = map(progress, 0, 1, 30, 180);
      float outerSize = map(progress, 0, 1, d * 0.5, d * 1.5);
      fill(255, 100, 0, outerAlpha);
      ellipse(pos.x, pos.y, outerSize, outerSize);
      
      // Middle yellow flame layer
      float midAlpha = map(progress, 0, 1, 50, 200);
      float midSize = map(progress, 0, 1, d * 0.35, d * 1.0);
      fill(255, 180, 30, midAlpha);
      ellipse(pos.x, pos.y, midSize, midSize);
      
      // Inner bright white-yellow core
      float innerAlpha = map(progress, 0, 1, 80, 220);
      float innerSize = map(progress, 0, 1, d * 0.2, d * 0.6);
      fill(255, 240, 150, innerAlpha);
      ellipse(pos.x, pos.y, innerSize, innerSize);
    }
    
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    
    // Draw irregular meteorite rock
    fill(ballColor);
    stroke(35, 25, 20);
    strokeWeight(1.5);
    beginShape();
    for (int i = 0; i < 8; i++) {
      float angle = TWO_PI / 8 * i;
      float radius = r * rockVertices[i];
      vertex(cos(angle) * radius, sin(angle) * radius);
    }
    endShape(CLOSE);
    
    // Add dark craters for texture
    noStroke();
    fill(ballColor - color(25, 25, 25));
    ellipse(-r*0.25, -r*0.2, r*0.4, r*0.4);
    ellipse(r*0.3, r*0.1, r*0.35, r*0.35);
    ellipse(0, -r*0.4, r*0.28, r*0.28);
    ellipse(-r*0.35, r*0.25, r*0.3, r*0.3);
    
    // Glowing hot spots from atmospheric friction
    fill(255, 150, 60, 220);
    ellipse(r*0.35, -r*0.3, r*0.25, r*0.25);
    fill(255, 180, 80, 180);
    ellipse(-r*0.25, r*0.35, r*0.2, r*0.2);
    fill(255, 200, 120, 150);
    ellipse(r*0.1, r*0.15, r*0.18, r*0.18);
    
    popMatrix();
  }
}
