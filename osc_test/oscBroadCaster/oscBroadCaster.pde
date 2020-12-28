/**
 * oscP5broadcaster by andreas schlegel
 * an osc broadcast server.
 * osc clients can connect to the server by sending a connect and
 * disconnect osc message as defined below to the server.
 * incoming messages at the server will then be broadcasted to
 * all connected clients. 
 * an example for a client is located in the oscP5broadcastClient exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
NetAddress myBroadcastLocation;
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 54321;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12345;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

float value;
float x, y;


void setup() {
    size(500, 500);
    oscP5 = new OscP5(this, myListeningPort);
    //frameRate(25);
    myBroadcastLocation = new NetAddress("127.0.0.1", myBroadcastPort);
}

void draw() {
  background(255);
  //println(value);
    ellipse(mouseX, mouseY, 20, 20);
    ellipse(x, y, 50,50);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else {
    oscP5.send(theOscMessage, myNetAddressList);
  }
  
  ///////
  if(theOscMessage.checkAddrPattern("/test") == true){
      x = theOscMessage.get(0).floatValue();
      y = theOscMessage.get(1).floatValue();
      println(x, y);
  }
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


private void connect(String theIPaddress) {
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }



private void disconnect(String theIPaddress) {
    if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
        myNetAddressList.remove(theIPaddress, myBroadcastPort);
       println("### removing "+theIPaddress+" from the list.");
     } else {
       println("### "+theIPaddress+" is not connected.");
     }
       println("### currently there are "+myNetAddressList.list().size());
 }
