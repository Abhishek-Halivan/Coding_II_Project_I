Meteor[] meteors;
Spaceship spaceship;
int meteorCount = 0;
int maxMeteors = 10; // Increase max meteors
float lastSpawnTime = 0;
float spawnInterval = 2000; // Initial interval in milliseconds
boolean gameStarted = false;
Wall leftWall;
Wall rightWall;
Wall topWall;
Wall bottomWall;

void setup(){
  size(500, 500);
  meteors = new Meteor[maxMeteors]; 
  spaceship = new Spaceship();
  leftWall = new Wall(0, 0, 4, height, #FF0000);
  rightWall = new Wall(width-4, 0, 4, height, #00FF00);
  bottomWall = new Wall(0, height-4, width, 4, #FF00FF);
  topWall = new Wall(0, 0, width, 4, #0000FF);
}

void draw(){
  background(0);
  
  if (!gameStarted) {
    // Title screen
    fill(255, 140, 0);
    textAlign(CENTER, CENTER);
    textSize(64);
    text("METEOR BLASTER", width/2, height/2 - 40);
    textSize(32);
    text("Team Fraxinus", width/2, height/2 + 20);
    // Flashing instruction
    if (frameCount % 60 < 40) {
      fill(255);
      textSize(24);
      text("Press SPACEBAR to start", width/2, height/2 + 100);
    }
    
    // Draw spaceship on title screen
    spaceship.draw();
    return;
  }
  
  // Game logic - only runs when game started
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
  
  // Draw and update only active meteors
  for (int i = 0; i < meteorCount; i++) {
    if (meteors[i] != null && meteors[i].active) {
      meteors[i].setPosition(topWall, 
      bottomWall, leftWall, rightWall, 
      spaceship);
      meteors[i].draw();
    }
  }
  
  if (gameStarted) {
    spaceship.setPosition();
  }
  spaceship.draw();
  if (meteorCount == 0){
    println("You lost: " + meteorCount);
  }
}

void keyPressed() {
  if (!gameStarted && key == ' ') {
    gameStarted = true;
    // Initialize first meteor and timing
    meteors[0] = new Meteor();
    meteorCount++;
    lastSpawnTime = millis();
    spawnInterval = random(1000, 3000);
  }
}
