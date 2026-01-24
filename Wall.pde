class Wall extends Shape {
  color c;
  
  Wall(float x, float y, float w, 
                float h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
  }
  
  void draw() {
      fill(c);
      rect(this.x, this.y, this.w, this.h);
  }
}
