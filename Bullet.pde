class Bullet {
  float x;
  float y;
  float w = 4;
  float h = 12;
  float speed = 8;
  boolean active = true;
  color bulletColor;
  
  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
    this.bulletColor = color(0, 255, 255); // Cyan bullet
  }
  
  void update() {
    y -= speed; // Move upward
    
    // Deactivate if bullet goes off screen
    if (y < 0) {
      active = false;
    }
  }
  
  void draw() {
    if (active) {
      // Draw bullet with glow effect
      noStroke();
      
      // Outer glow
      fill(bulletColor, 100);
      ellipse(x, y, w * 2, h * 1.5);
      
      // Main bullet
      fill(bulletColor);
      ellipse(x, y, w, h);
      
      // Bright core
      fill(255, 255, 255, 200);
      ellipse(x, y, w * 0.5, h * 0.6);
    }
  }
  
  boolean hitsMeteor(Meteor m) {
    if (!active || !m.active) return false;
    
    // Simple circle collision detection
    float distance = dist(x, y, m.x, m.y);
    return distance < (w/2 + m.r);
  }
}
