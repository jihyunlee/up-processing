
class BalloonString {

  float totalLength;  // How long
  int numPoints;      // How many points  
  
  ArrayList<Particle> particles;
  ArrayList<DistanceJoint> joints;
  
  BalloonString(Body balloonBody, Body houseBody, int n) {
  
    float x = box2d.getBodyPixelCoord(balloonBody).x;
    float y = box2d.getBodyPixelCoord(balloonBody).y;
    
    particles = new ArrayList<Particle>();
    joints = new ArrayList<DistanceJoint>();

    Vec2 posHouse = box2d.getBodyPixelCoord(houseBody);
    Vec2 posBalloon = box2d.getBodyPixelCoord(balloonBody);
    
    totalLength = dist(posHouse.x, posHouse.y, posBalloon.x, posBalloon.y);
    numPoints = n;
    float len = totalLength / numPoints;
    
    for(int i=0; i < numPoints; i++) {
      Particle p = new Particle(x, y+i*len,len);  
      particles.add(p);   
      if(i>0) {
        Particle previous = particles.get(i-1);
        addJoint(previous.body, p.body, box2d.scalarPixelsToWorld(len));
      } 
    }
    
    addJoint(balloonBody, particles.get(0).body, 0.1);    
    addJoint(particles.get(numPoints-1).body, houseBody, 0.1);
  }
  
  void killBody() {    
    for (DistanceJoint j : joints) {
      box2d.world.destroyJoint(j);
    }
    for (Particle p : particles) {
      p.killBody();
    }
  }
  
  void addJoint(Body b1, Body b2, float len) {
    Vec2 pos1 = box2d.getBodyPixelCoord(b1);
    Vec2 pos2 = box2d.getBodyPixelCoord(b2);
    
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = b1;
    djd.bodyB = b2;
    djd.length = len; 
    djd.frequencyHz = 0;
    djd.dampingRatio = 1;
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
    joints.add(dj);
  }
  
  void destroyJoint() {
    box2d.world.destroyJoint(joints.get(joints.size()-1));
    joints.remove(joints.get(joints.size()-1));
  }

  void applyForce(Vec2 force) {  
    for (Particle p : particles) {
      Vec2 pos = p.body.getWorldCenter();
      Vec2 tempPos = new Vec2(pos.x, pos.y);
      p.body.applyForce(force, tempPos);
    }   
  }
  
  void display() {
    beginShape();
    strokeWeight(1);
    stroke(255);

    for (DistanceJoint j : joints) {
      Body a = j.getBodyA();
      Body b = j.getBodyB();
      Vec2 pos1 = box2d.getBodyPixelCoord(a);
      Vec2 pos2 = box2d.getBodyPixelCoord(b);
      line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
    strokeWeight(1);
    endShape();
  }
}
