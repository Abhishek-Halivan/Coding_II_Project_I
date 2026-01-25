Meteor[] meteors;
Spaceship spaceship;
ArrayList<Bullet> bullets;
int meteorCount = 0;
int maxMeteors = 10; // Increase max meteors
float lastSpawnTime = 0;
float spawnInterval = 2000; // Initial interval in milliseconds
float lastShotTime = 0;
float shootCooldown = 200; // Milliseconds between shots
boolean gameStarted = false;
Wall leftWall;
Wall rightWall;
Wall topWall;
Wall bottomWall;

void setup(){
  size(500, 500);
  meteors = new Meteor[maxMeteors]; 
  bullets = new ArrayList<Bullet>();
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
    fill(200);
    textSize(16);
    text("Arrow Keys: Move | SPACE: Shoot", width/2, height - 30);
    
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
  
  // Update and draw bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    if (b.active) {
      b.update();
      b.draw();
      
      // Check collision with meteors
      for (int j = 0; j < meteorCount; j++) {
        if (meteors[j] != null && meteors[j].active && b.hitsMeteor(meteors[j])) {
          meteors[j].active = false; // Destroy meteor
          b.active = false; // Destroy bullet
          break;
        }
      }
    } else {
      bullets.remove(i); // Remove inactive bullets
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
  } else if (gameStarted && key == ' ') {
    // Shoot bullet with cooldown
    if (millis() - lastShotTime > shootCooldown) {
      float bulletX = spaceship.x + spaceship.w/2;
      float bulletY = spaceship.y;
      bullets.add(new Bullet(bulletX, bulletY));
      lastShotTime = millis();
    }
  }
}
