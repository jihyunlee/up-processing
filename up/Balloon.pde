int minRadius = 15;
int maxRadius = 50; 
int numStrings = 25;
int minStringLen = 170;
int maxStringLen = 280;

int maxVolume = 30;
  
class Balloon {
  
  String uniqueID;

  Body body;
  float rad;
  float volume;
  float overVolume =0;
  boolean bReachMax = false;
  boolean bHangup = false;
  float lifetime;

  color balloonColor;
  String label;

  BalloonString balloonString;

  House house;

  Balloon(float x, float y) {
    float distance = random(minStringLen, maxStringLen);

    house = houses.get(houses.size()-1);
    Vec2 posHouse = box2d.getBodyPixelCoord(house.body);

    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.angle = 0;

    body = box2d.world.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(maxRadius/2);   
    rad = cs.m_radius;

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 0.8;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    body.createFixture(fd);

    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = body;
    djd.bodyB = house.body;   
    djd.length = box2d.scalarPixelsToWorld(distance);
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);

    balloonString = new BalloonString(body, house.body, numStrings);

    if (bTest)
      volume = 20;
  }

  void updateAudio(float audioLevel) { 
    if(audioLevel > 0.001) {
      if(overVolume > 20) {
//        println("popping!!!");
        if(poppingPlayer.isPlaying() == false)
          poppingPlayer.play(0);
        setLifetime(millis()+700);
        bHangup = true;  
      }

      volume += audioLevel;
      if(volume > maxVolume) {
        if(bReachMax == false) {
          println("stretching!!!");
          if(stretchingPlayer.isPlaying() == false) {
            println("playing");
            stretchingPlayer.play(0);
          }
        }
        if(bReachMax) {
          overVolume += audioLevel;
        }
        volume = maxVolume;
        bReachMax = true;
      }            
    }
    else {
      if(bReachMax == false) {
        volume -= 0.1;
        if(volume < 0)
          volume = 0;
      }
    }   

    rad = map(volume, 0, maxVolume, minRadius, maxRadius);
  }
  
  void display() {
    balloonString.display();
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    Vec2 posHouse = box2d.getBodyPixelCoord(house.body);

    float dx = pos.x - posHouse.x;
    float dy = sqrt((pos.x-posHouse.x)*(pos.x-posHouse.x) + (pos.y-posHouse.y)*(pos.y-posHouse.y));
    float a = acos(dx/dy);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(PI/2-a);
    
    if(bHangup)
      updateAudio(0);
      
    // balloon
    fill(balloonColor);    
    noStroke();
    if (bTest)
      ellipse(0, 0, maxRadius, maxRadius*1.2);
    else
      ellipse(0, 0, rad, rad*1.2);

    // label: last 4 digits of caller number
    fill(0);
    if (bTest)
      text(label, -textWidth(label)/2, -maxRadius*1.2/2-3);
    else
      text(label, -textWidth(label)/2, -rad*1.2/2-3);

    popMatrix();
  }
  
  void updateString() {
    balloonString.killBody();
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    Vec2 posHouse = box2d.getBodyPixelCoord(house.body);
    float distance = dist(posHouse.x, posHouse.y, pos.x, pos.y);        

    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = body;
    djd.bodyB = house.body;   
    djd.length = box2d.scalarPixelsToWorld(distance);
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
    
    balloonString = new BalloonString(body, house.body, numStrings);
  }
  
  void displayBalloonString() {
    balloonString.killBody();
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    Vec2 posHouse = box2d.getBodyPixelCoord(house.body);
    float distance = dist(posHouse.x, posHouse.y, pos.x, pos.y);        

    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = body;
    djd.bodyB = house.body;   
    djd.length = box2d.scalarPixelsToWorld(distance);
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
    
    balloonString = new BalloonString(body, house.body, numStrings);

    balloonString.display();  
  }

  void killBody() {
    box2d.destroyBody(body);
  }
  
  void flyaway() {
    balloonString.destroyJoint();    
  }
  
  void setLifetime(float t) {
    lifetime = t;
  }

  void applyForce(Vec2 force) {   
    Vec2 pos = body.getWorldCenter();
    Vec2 tempPos = new Vec2(pos.x, pos.y);
    tempPos.y += box2d.scalarPixelsToWorld(maxRadius/2);
    body.applyForce(force, tempPos);
  }

  void setColor(String phoneNumber) {
    float r = map(float(phoneNumber.substring(0, 3)), 100, 999, 0, 255);
    float g = map(float(phoneNumber.substring(3, 6)), 100, 999, 0, 255);
    float b = map(float(phoneNumber.substring(6, 10)), 100, 9999, 0, 255); 
    balloonColor = color(int(r), int(g), int(b));
  }

  void setLabel(String phoneNumber) {
    label = phoneNumber.substring(6, 10);
  }
}

