int numClouds= 6;
float cloudMin = 0.5;
float cloudMax = 1.2;

class Cloud {
  
  PImage imgCloud;
  float x, y, w, h;
  float windSpeed;
  
  Cloud(PImage img_, float x_, float y_, float scale_) {
    imgCloud = img_;
    x = x_;
    y = y_;
    w = imgCloud.width * scale_;
    h = imgCloud.height * scale_;
    windSpeed = map(scale_, cloudMin, cloudMax, 0.7, 0.05);
  }
  
  void update() {
    x -= windSpeed;  
  }
  
  void display() {
    if(x < -w) {
      x = width + w;
    }  
    pushMatrix();
    translate(x,y);
    image(imgCloud,0,0,w,h);
    popMatrix();
  }
}
