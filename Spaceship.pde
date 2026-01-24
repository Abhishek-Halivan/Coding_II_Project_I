class Spaceship extends Shape {
  
  float posX = 0;
  color spaceshipColor;
  color accentColor;
  float thrusterAnimation = 0;
  
  Spaceship(color spaceshipColor) {
    this.spaceshipColor = spaceshipColor;
    this.accentColor = #00FFFF; // Cyan accent for spaceship
    this.y = 450;
    this.w = 40;
    this.h = 30;
  }
  
  Spaceship() {
    this(#0088FF); // Blue spaceship color
  }
  
  void setPosition() {
    if(keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT) {
          posX+=4; // Slightly faster movement
        } else if (keyCode == LEFT) {
          posX-=4;
        }
        this.x = constrain(posX, 0, width-this.w);
        thrusterAnimation += 0.5; // Animate thrusters when moving
      }
    }
  }

  void draw() {
    pushMatrix();
    translate(this.x + this.w/2, this.y + this.h/2);
    
    // Draw spaceship body (triangle pointing up)
    fill(spaceshipColor);
    stroke(255);
    strokeWeight(2);
    triangle(0, -this.h/2,      // Top point (nose)
             -this.w/2, this.h/2,  // Bottom left
             this.w/2, this.h/2);  // Bottom right
    
    // Drawing cockpit window
    fill(accentColor);
    noStroke();
    ellipse(0, -5, 8, 8);
    
    // Drawing wing accents
    fill(#FF4400);
    triangle(-this.w/2, this.h/2,
             -this.w/2 - 5, this.h/2,
             -this.w/2, this.h/2 - 8);
    triangle(this.w/2, this.h/2,
             this.w/2 + 5, this.h/2,
             this.w/2, this.h/2 - 8);
    
    // Drawing animated thrusters
    if (keyPressed && key == CODED) {
      fill(#FFAA00, 200);
      noStroke();
      float thrustSize = 5 + sin(thrusterAnimation) * 3;
      ellipse(-this.w/4, this.h/2 + thrustSize/2, 6, thrustSize);
      ellipse(this.w/4, this.h/2 + thrustSize/2, 6, thrustSize);
      
      // Inner bright core
      fill(#FFFF00, 250);
      ellipse(-this.w/4, this.h/2 + thrustSize/3, 4, thrustSize*0.6);
      ellipse(this.w/4, this.h/2 + thrustSize/3, 4, thrustSize*0.6);
    }
    
    popMatrix();
  }
  
}
