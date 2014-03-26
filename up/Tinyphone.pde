
import com.itpredial.tinyphone.client.*;

TinyphoneClient tp;
ArrayList<Caller> callers = new ArrayList<Caller>();
String host = "108.171.183.160"; // TinyPhone's host name or IP address here
int port = 12002; // TinyPhone's port
String phoneNumber = "1(206)-309-2201"; //the phone number

void newTinyphoneClient()
{
  tp = new TinyphoneClient(this, host, port, phoneNumber);
  tp.start();
}

// called by tinyphone client when there's a new caller (required)
public void newCallerEvent(TinyphoneEvent event)
{
  println("ID " + event.getId() + "   caller number " + event.getCallerNumber());
  Caller caller = new Caller(event.getId(), event.getCallerNumber());
  synchronized(callers) {
    callers.add(caller);
  }
}

// called by tinyphone client when a caller hangs up
public void hangupEvent(TinyphoneEvent event)
{
  synchronized(callers) {
    for (int i = 0; i < callers.size(); i++) {
      Caller caller = callers.get(i);
      if (caller.isCaller(event.getId())) {
        for(int j=0; j<balloons.size(); j++) {
          Balloon b = balloons.get(i);
          if(b.uniqueID.equals(event.getId())) {
            if(b.bReachMax == false) {
              // play deflating sound
              b.flyaway();
              deflatingPlayer.play(0);
              println("hangup not max");
              b.setLifetime(millis()+5000);
            b.bHangup = true;  
            }
            else {
              println("hangup with max");
            }            
          }
        }

        callers.remove(i);
        break;
      }
    }
  }
}

// called by tinyphone client when there's an audio level
public void audioLevelEvent(TinyphoneEvent event)
{
  synchronized(callers) {
    Caller caller = getCaller(event.getId());
    if (caller != null) {
      float audioLevel = (Float.parseFloat(event.getValue())/32764);
      caller.audioLevelEvent(audioLevel);
    }
  }
}

// called by tinyphone client when there's a new key press
public void keypressEvent(TinyphoneEvent event)
{
  synchronized(callers) {
    Caller caller = getCaller(event.getId());
    if (caller != null) {
      caller.keypressEvent(event.getValue());
    }
  }
}

Caller getCaller(String id)
{
  for (int i = 0; i < callers.size(); i++) {
    Caller caller = callers.get(i);
    if (caller.isCaller(id))
      return caller;
  }
  return null;
}
