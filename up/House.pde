
float houseWidth = 250;
float houseHeight = 230;
float chimneyWidth = 50;
float chimneyHeight = 50;

  
class House {
  
  Body body;
  PImage imgHouse;
  PImage imgChimney;
  
  House(float x, float y) {
    
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);
    
    // Make the body's shape a circle
    PolygonShape psChimney = new PolygonShape();
    float box2dWidth = box2d.scalarPixelsToWorld(chimneyWidth/2);
    float box2dHeight = box2d.scalarPixelsToWorld(chimneyHeight/2);
    psChimney.setAsBox(box2dWidth, box2dHeight);
  
    PolygonShape ps = new PolygonShape();
    box2dWidth = box2d.scalarPixelsToWorld(houseWidth/2);
    box2dHeight = box2d.scalarPixelsToWorld(houseHeight/2);
    Vec2 offset = new Vec2(0,(chimneyHeight+houseHeight)/2);
    offset = box2d.vectorPixelsToWorld(offset);
    ps.setAsBox(box2dWidth, box2dHeight, offset, 0);
  
    FixtureDef fdChimney = new FixtureDef();
    fdChimney.shape = psChimney;
    fdChimney.density = 1;
    fdChimney.friction = 0.01;
    fdChimney.restitution = 0.3;
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1.3;
    fd.friction = 0.01;
    fd.restitution = 0.3;
    
    // Attach fixture to body
    body.createFixture(fdChimney);
    body.createFixture(fd);  
    
    imgHouse = loadImage("house.png");
    imgChimney = loadImage("chimney.png");
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
      translate((int)pos.x,(int)pos.y); 
      rotate(-a); 

      noStroke();    
      imageMode(CENTER);
      image(imgHouse, 0, (houseHeight)/2+1, houseWidth, 284);
      image(imgChimney, 0,0+2, chimneyWidth, chimneyHeight);
    popMatrix();      
  }
  
  boolean update() {
    // check if lifted up or not
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    if(pos.y < - height/2)
      return true;
          
    return false;
  }
  
}
