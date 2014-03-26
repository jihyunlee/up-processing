
class Particle {

  Body body;

  Particle(float x, float y, float distance) {  
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(distance/2);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 0.5;
    fd.friction = 0.3;
    fd.restitution = 0.3;
    fd.filter.maskBits = 0;
    
    body.createFixture(fd);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }
  
}


