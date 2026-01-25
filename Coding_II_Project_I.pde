Meteor[] meteors;
Spaceship spaceship;
int meteorCount = 0;
int maxMeteors = 10; // Increase max meteors
float lastSpawnTime = 0;
float spawnInterval = 2000; // Initial interval in milliseconds
Wall leftWall;
Wall rightWall;
Wall topWall;
Wall bottomWall;

void setup(){
  size(500, 500);
  meteors = new Meteor[maxMeteors]; 
  meteors[0] = new Meteor();
  meteorCount++;
  lastSpawnTime = millis();
  spawnInterval = random(1000, 3000); // Random initial interval
  spaceship = new Spaceship();
  leftWall = new Wall(0, 0, 4, height, #FF0000);
  rightWall = new Wall(width-4, 0, 4, height, #00FF00);
  bottomWall = new Wall(0, height-4, width, 4, #FF00FF);
  topWall = new Wall(0, 0, width, 4, #0000FF);
}

void draw(){
  background(0);
  
  // Automatically spawn meteors at random intervals
  if (millis() - lastSpawnTime > spawnInterval && meteorCount < meteors.length) {
    meteors[meteorCount] = new Meteor();
    meteorCount++;
    lastSpawnTime = millis();
    spawnInterval = random(800, 2500); // Random interval between 0.8 to 2.5 seconds
  }
  
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
