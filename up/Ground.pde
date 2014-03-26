int groundHeight = 15;
  
class Ground {

  float x;
  float y;
  float w;
  float h;
  
  Body body;

  Ground(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.createBody(bd);
    
    // Define the polygon
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    ps.setAsBox(box2dW, box2dH);
    
    // Attached the shape to the body using a Fixture
    body.createFixture(ps,1);
  }

  void display() {
    
    pushMatrix();
      translate(x,y);
      fill(239,232,206);
      rect(0,groundHeight/2,width,groundHeight+groundHeight/2);
    popMatrix();
  }
  
}


