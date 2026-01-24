Ball[] balls;
Paddle paddle;
int ballCount = 0;
Wall leftWall;
Wall rightWall;
Wall topWall;
Wall bottomWall;

void setup(){
  size(500, 500);
  balls = new Ball[4]; 
  balls[0] = new Ball();
  ballCount++;
  paddle = new Paddle();
  leftWall = new Wall(0, 0, 4, height, #FF0000);
  rightWall = new Wall(width-4, 0, 4, height, #00FF00);
  bottomWall = new Wall(0, height-4, width, 4, #FF00FF);
  topWall = new Wall(0, 0, width, 4, #0000FF);
}

void draw(){
  background(0);
  leftWall.draw();
  rightWall.draw();
  topWall.draw();
  bottomWall.draw();
  for (int i = 0; i < ballCount; i++) {    
    balls[i].setPosition(topWall, 
    bottomWall, leftWall, rightWall, 
    paddle);
    balls[i].draw();
  }
  paddle.setPosition();
  paddle.draw();
  if (ballCount == 0){
    println("You lost: " + ballCount);
  }
}


void mousePressed() {
  if (ballCount < balls.length) {
    balls[ballCount] = new Ball();
    ballCount++;
  }
}
