class Paddle extends Shape {
  
  float posX = 0;
  color paddleColor;
  
  Paddle(color paddleColor) {
    this.paddleColor = paddleColor;
    this.y = 470;
    this.w = 50;
    this.h = 10;
  }
  
  Paddle() {
    this(#FF0000);
  }
  
  void setPosition() {
    if(keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT) {
          posX+=3;
        } else if (keyCode == LEFT) {
          posX-=3;
        }
        this.x = constrain(posX, 0, width-this.w);
      }
    }
  }

  void draw() {
    fill(paddleColor);
    rect(this.x, this.y, this.w , this.h);
  }
  
}
