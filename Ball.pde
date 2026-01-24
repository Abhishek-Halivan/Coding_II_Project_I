class Ball {
  float x;
  float y;
  float d = 25;
  float r;
  float speedx;
  float speedy;
  color ballColor;
  
  Ball(float d) {
    this.x = random(width);
    this.y = 20;
    this.speedx = random(-2, 2);
    this.speedy = random(1, 3);
    this.ballColor = 
      color(random(255), random(255), random(255));
    this.d = d;
    this.r = d/2;
  }
  
  Ball() {
    this(25);
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
    if (this.intersects(topWall)) {
      speedy = speedy*-1;
    } else if (this.intersects(bottomWall)) {
      ballCount--;
    } else if (this.intersects(rightWall) || 
                      this.intersects(leftWall)) {
      speedx = speedx*-1;
    } else if (this.intersects(paddle)) {
      speedy = speedy*-1;
    }
    
    this.x = this.x + 1*speedx;
    this.y = this.y + 1*speedy;
  }

  void draw() {
    fill(this.ballColor);
    ellipse(x, y, d, d);
  }
}
