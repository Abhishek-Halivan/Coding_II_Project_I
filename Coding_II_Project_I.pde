Meteor[] meteors;
Spaceship spaceship;
int meteorCount = 0;
Wall leftWall;
Wall rightWall;
Wall topWall;
Wall bottomWall;

void setup(){
  size(500, 500);
  meteors = new Meteor[4]; 
  meteors[0] = new Meteor();
  meteorCount++;
  spaceship = new Spaceship();
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
  for (int i = 0; i < meteorCount; i++) {    
    meteors[i].setPosition(topWall, 
    bottomWall, leftWall, rightWall, 
    spaceship);
    meteors[i].draw();
  }
  spaceship.setPosition();
  spaceship.draw();
  if (meteorCount == 0){
    println("You lost: " + meteorCount);
  }
}


void mousePressed() {
  if (meteorCount < meteors.length) {
    meteors[meteorCount] = new Meteor();
    meteorCount++;
  }
}
