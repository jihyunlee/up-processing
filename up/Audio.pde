
import ddf.minim.*;

AudioPlayer inflatingPlayer;
AudioPlayer deflatingPlayer;
AudioPlayer poppingPlayer;
AudioPlayer stretchingPlayer;

Minim minim;

void audioSetup()
{
  minim = new Minim(this);
  inflatingPlayer = minim.loadFile("inflating.wav", 2048);
  if(inflatingPlayer == null) println("inflating.wav not found");
  deflatingPlayer = minim.loadFile("deflating.wav", 2048);
  if(deflatingPlayer == null) println("deflating.wav not found");
  poppingPlayer = minim.loadFile("popping.wav", 2048);
  if(poppingPlayer == null) println("popping.wav not found");
  stretchingPlayer = minim.loadFile("stretching2.wav", 2048);
  if(stretchingPlayer == null) println("stretching2.wav not found");  
}

void audioStop()
{
  // always close Minim audio classes when you are done with them
  inflatingPlayer.close();
  deflatingPlayer.close();
  poppingPlayer.close();
  stretchingPlayer.close();
  minim.stop();  
  super.stop();
}
