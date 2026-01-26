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
boolean gameOver = false;
boolean spaceshipDestroyed = false;
float gameOverTime = 0;

int score = 0;
int difficulty = 1; // 1=Easy, 2=Medium, 3=Hard
float minMeteorSpeed = 2;
float maxMeteorSpeed = 5;
boolean isPaused = false;
PFont font;

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
  
  // Check for game over screen
  if (gameOver) {
    // Draw game over screen
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(72);
    text("GAME OVER", width/2, height/2 - 40);
    
    fill(255);
    textSize(24);
    text("Meteor destroyed your spaceship!", width/2, height/2 + 20);
    text("Final Score: " + score, width/2, height/2 + 60);
    
    // Manual reset
    fill(255, 255, 0); 
    if (frameCount % 60 < 40) {
      textSize(24);
      text("Press 'R' to Restart Level", width/2, height/2 + 110);
      text("Press 'Q' to Quit to Menu", width/2, height/2 + 145);
    }
    return;
  }
  
  if (!gameStarted) {
    // Title screen
    fill(255, 140, 0);
    textAlign(CENTER, CENTER);
    textSize(64);
    text("METEOR BLASTER", width/2, height/2 - 40);
    textSize(32);
    text("Team Fraxinus", width/2, height/2 + 20);
    // Difficulty Instructions
    textSize(24);
    fill(100, 255, 100);
    text("Select Difficulty:", width/2, height/2 + 80);
    
    textSize(20);
    fill(255);
    text("1. Easy (Slow, 5 Hearts)", width/2, height/2 + 120);
    text("2. Medium (Normal, 4 Hearts)", width/2, height/2 + 150);
    text("3. Hard (Fast, 3 Hearts)", width/2, height/2 + 180);

    fill(200);
    textSize(16);
    text("Arrow Keys: Move | SPACE: Shoot", width/2, height - 30);
    
    // Draw spaceship on title screen
    spaceship.draw();
    return;
  }
  
  // Game logic - only runs when game started
  if (isPaused) {
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("PAUSED", width/2, height/2 - 20);
    textSize(20);
    fill(200);
    text("Press 'P' to Resume", width/2, height/2 + 30);
    text("Press 'Q' to Quit to Menu", width/2, height/2 + 60);
    return;
  }
  
  // HUD (Heads Up Display)
  fill(255);
  textAlign(LEFT, TOP);
  textSize(20);
  text("Score: " + score, 10, 10);
  
  // Hearts
  for (int i = 0; i < spaceship.health; i++) {
    fill(255, 0, 0);
    noStroke();
    ellipse(width - 30 - (i * 25), 20, 15, 15);
  }

  // Automatically spawn meteors at random intervals
  // Count active meteors
  int activeMeteors = 0;
  for (int i = 0; i < meteorCount; i++) {
    if (meteors[i] != null && meteors[i].active) {
      activeMeteors++;
    }
  }
  
  // Spawn new meteors if under limit
  if (millis() - lastSpawnTime > spawnInterval && activeMeteors < maxMeteors) {
    // Find an empty or inactive slot
    int slot = -1;
    for (int i = 0; i < meteors.length; i++) {
      if (meteors[i] == null || !meteors[i].active) {
        slot = i;
        break;
      }
    }
    
    if (slot != -1) {
      meteors[slot] = new Meteor(minMeteorSpeed, maxMeteorSpeed);
      if (slot >= meteorCount) {
        meteorCount = slot + 1;
      }
      lastSpawnTime = millis();
      spawnInterval = random(800, 2500); // Random interval between 0.8 to 2.5 seconds
    }
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
          score += 10;
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
  if (!spaceshipDestroyed) {
    spaceship.draw();
  }
}

void keyPressed() {
  if (!gameStarted) {
    int startHealth = 5;
    boolean start = false;
    
    if (key == '1') {
      difficulty = 1;
      minMeteorSpeed = 2;
      maxMeteorSpeed = 4;
      spawnInterval = 2000;
      startHealth = 5;
      start = true;
    } else if (key == '2') {
      difficulty = 2;
      minMeteorSpeed = 3;
      maxMeteorSpeed = 6;
      spawnInterval = 1500;
      startHealth = 4;
      start = true;
    } else if (key == '3') {
      difficulty = 3;
      minMeteorSpeed = 5;
      maxMeteorSpeed = 8;
      spawnInterval = 1000;
      startHealth = 3;
      start = true;
    }
    
    if (start) {
      startGame(difficulty);
    }
  } else if (gameOver) {
    if (key == 'r' || key == 'R') {
      startGame(difficulty);
    } else if (key == 'q' || key == 'Q') {
      resetGame();
    }
  } else {
    // In game controls
    if (key == 'p' || key == 'P') {
      isPaused = !isPaused;
    } else if (isPaused && (key == 'q' || key == 'Q')) {
      resetGame();
    } else if (!isPaused && key == ' ') {
      // Shoot bullet with cooldown
      if (millis() - lastShotTime > shootCooldown) {
        float bulletX = spaceship.x + spaceship.w/2;
        float bulletY = spaceship.y;
        bullets.add(new Bullet(bulletX, bulletY));
        lastShotTime = millis();
      }
    }
  }
}

void resetGame() {
  // Reset all game variables
  gameStarted = false;
  gameOver = false;
  spaceshipDestroyed = false;
  meteorCount = 0;
  meteors = new Meteor[maxMeteors];
  bullets.clear();
  spaceship = new Spaceship();
  lastSpawnTime = 0;
  spawnInterval = 2000;
  score = 0;
  isPaused = false;
}

void startGame(int diff) {
  difficulty = diff;
  int startHealth = 5;
  
  if (difficulty == 1) {
    minMeteorSpeed = 2;
    maxMeteorSpeed = 4;
    spawnInterval = 2000;
    startHealth = 5;
  } else if (difficulty == 2) {
    minMeteorSpeed = 3;
    maxMeteorSpeed = 6;
    spawnInterval = 1500;
    startHealth = 4;
  } else if (difficulty == 3) {
    minMeteorSpeed = 5;
    maxMeteorSpeed = 8;
    spawnInterval = 1000;
    startHealth = 3;
  }
  
  gameStarted = true;
  gameOver = false;
  spaceshipDestroyed = false;
  score = 0;
  isPaused = false;
  
  spaceship = new Spaceship();
  spaceship.setHealth(startHealth);
  bullets.clear();
  meteors = new Meteor[maxMeteors];
  meteorCount = 0;
  
  // Initialize first meteor
  meteors[0] = new Meteor(minMeteorSpeed, maxMeteorSpeed);
  meteorCount++;
  lastSpawnTime = millis();
}
