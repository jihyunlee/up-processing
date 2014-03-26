
class Caller {
  
  String uniqueID;
  String phoneNumber;

  float lastBlowingTime = 0;
  
  Balloon balloon;

  Caller(String id, String number) { 
    
    //start more or less in the middle of the screen
    float x = (width/2)+(int)random(-width/8,width/8);
    float y = height - groundHeight - houseHeight - minStringLen;
    
    balloon = new Balloon(x, y);
    balloon.uniqueID = id;
    balloons.add(balloon);
       
    uniqueID = id;
    phoneNumber = number;
    
    balloon.setColor(phoneNumber);
    balloon.setLabel(phoneNumber); 
  }

  void audioLevelEvent(float audioLevel) {
    if(balloon.bHangup == false)
      balloon.updateAudio(audioLevel);
  }
  
  void keypressEvent(String keypress) {
    char keychar = keypress.charAt(0);
  }

  boolean isCaller(String checkID) {
    return uniqueID.equals(checkID);
  }
}

