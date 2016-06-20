/**
 * oscP5multicast by andreas schlegel
 * example shows how to send osc via a multicast socket.
 * what is a multicast? http://en.wikipedia.org/wiki/Multicast
 * ip multicast ranges and uses:
 * 224.0.0.0 - 224.0.0.255 Reserved for special �well-known� multicast addresses.
 * 224.0.1.0 - 238.255.255.255 Globally-scoped (Internet-wide) multicast addresses.
 * 239.0.0.0 - 239.255.255.255 Administratively-scoped (local) multicast addresses.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;

Scene cosiendoTetuan;
Scene clother;
Scene vidaCoral;

Scene currentScene = null;
Scene arcos = null;

void setup() {
  size(1024, 768);
  frameRate(25);
  /* create a new instance of oscP5 using a multicast socket. */
  oscP5 = new OscP5(this, "192.168.1.255", 7777);

  cosiendoTetuan = new CosiendoTetuan();
  cosiendoTetuan.load();

  arcos = new Arcos();
  arcos.load();

  clother = new Clother();
  clother.load();

  vidaCoral = new Coral();
  vidaCoral.load();

  currentScene = cosiendoTetuan;
}


void draw() {
  background(100);

  currentScene.myDraw(g);

  arcos.myDraw(g);
}


void mousePressed() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/test");

  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(100);

  /* send the OscMessage to the multicast group. 
   * the multicast group netAddress is the default netAddress, therefore
   * you dont need to specify a NetAddress to send the osc message.
   */
  oscP5.send(myOscMessage);
}

void changeScene(int scene) {
  OscMessage myOscMessage = new OscMessage("/scene");

  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(scene);

  /* send the OscMessage to the multicast group. 
   * the multicast group netAddress is the default netAddress, therefore
   * you dont need to specify a NetAddress to send the osc message.
   */
  oscP5.send(myOscMessage);
}

void keyPressed() {

  if (key == '1') {
    currentScene = cosiendoTetuan;
    changeScene(1);
  } else if (key == '2') {
    currentScene = vidaCoral;
    changeScene(2);
  } else if (key == '3') {
    currentScene = clother;
    changeScene(3);
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  if (theOscMessage.addrPattern().contains("scene")) {

    if (theOscMessage.get(0).intValue() == 1) {
      currentScene = cosiendoTetuan;
    } else if (theOscMessage.get(0).intValue() == 2) {
      currentScene = vidaCoral;
    } else if (theOscMessage.get(0).intValue() == 3) {
      currentScene = clother;
    }
  }
  println(" typetag: "+theOscMessage.typetag());
}