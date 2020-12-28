import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation;

float x, y;

void setup() {
    size(500, 500);
    
    oscP5 = new OscP5(this, 12345);
    myBroadcastLocation = new NetAddress("127.0.0.1", 54321);
}

void draw() {
    background(0);
    fill(255);
    ellipse(mouseX, mouseY, 50, 50);
    fill(255,250,144);
    ellipse(x, y, 50, 50);
}

void mouseMoved() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/test");
  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(float(mouseX));
  myOscMessage.add(float(mouseY));
  /* send the OscMessage to a remote location specified in myNetAddress */
  oscP5.send(myOscMessage, myBroadcastLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();

  ///////
  if(theOscMessage.checkAddrPattern("/test") == true){
      x = theOscMessage.get(0).floatValue();
      y = theOscMessage.get(1).floatValue();
      println(x, y);
  }
}



void keyPressed() {
  OscMessage m;
  switch(key) {
    case('c'):
      /* connect to the broadcaster */
      m = new OscMessage("/server/connect",new Object[0]);
      oscP5.flush(m,myBroadcastLocation);  
      break;
    case('d'):
      /* disconnect from the broadcaster */
      m = new OscMessage("/server/disconnect",new Object[0]);
      oscP5.flush(m,myBroadcastLocation);  
      break;

  }  
}
