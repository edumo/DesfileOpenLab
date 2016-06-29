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
import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import java.util.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import geomerative.*;
import ddf.minim.*;

boolean bg = true;

OscP5 oscP5;

Scene cosiendoTetuan;
Scene clother;
Scene vidaCoral;

Scene currentScene = null;
Scene currentOverlay = null;
Scene currentText = null;

Scene arcos = null;
Scene particulas = null;

Minim minim; //CREATE A NEW SOUND OBJECT
AudioInput in;


void setup() {
  size(1024, 768);
  frameRate(24);
  /* create a new instance of oscP5 using a multicast socket. */
  oscP5 = new OscP5(this, "192.168.3.255", 7777);

 RG.init(this);
  minim = new Minim(this);
  in = minim.getLineIn();
   
  Ani.init(this);
  cosiendoTetuan = new CosiendoTetuan();
  cosiendoTetuan.load();

  arcos = new Arcos();
  arcos.load();

  clother = new Clother();
  clother.load();

  vidaCoral = new Coral();
  vidaCoral.load();

  particulas = new Particulas1();
  particulas.load();

  currentScene = cosiendoTetuan;
  currentOverlay = particulas;
  
  currentText = new Texto();
  currentText.load();
}


void draw() {

  if (bg)
    background(100);

  currentScene.myDraw(g);

  if (currentOverlay != null)
    currentOverlay.myDraw(g);
    
  currentText.myDraw(g);
}

void mousePressed() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/mousePressed");
  myOscMessage.add(100);
  oscP5.send(myOscMessage);
}

void mouseMoved() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/mouseMoved");
  myOscMessage.add(mouseX/(float)width);
  myOscMessage.add(mouseY/(float)height);
  oscP5.send(myOscMessage);
}

void keyPressedScene(char c) {
  OscMessage myOscMessage = new OscMessage("/keyPressed");
  myOscMessage.add(c);
  oscP5.send(myOscMessage);
}

void keyPressed() {
  keyPressedScene(key);
}

/*void changeScene(int scene) {
 OscMessage myOscMessage = new OscMessage("/scene");
 myOscMessage.add(scene);
 oscP5.send(myOscMessage);
 }*/


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());

  if (theOscMessage.addrPattern().contains("mousePressed")) {
    currentScene.mousePressed();
    if (currentOverlay != null)
      currentOverlay.mousePressed(  );
  }

  if (theOscMessage.addrPattern().contains("mouseMoved")) {
    //currentScene.mousePressed();

    mouseX = (int)(theOscMessage.get(0).floatValue()*width);
    mouseY = (int)(theOscMessage.get(1).floatValue()*height);
    //if (currentOverlay != null)
    //  currentOverlay.mousePressed(  );
  }

  if (theOscMessage.addrPattern().contains("keyPressed")) {

    int param = theOscMessage.get(0).charValue();

    if (param == '1') {
      currentScene = cosiendoTetuan;
      bg = false;
    } else if (param == '2') {
      currentScene = vidaCoral;
    } else if (param == '3') {
      currentScene = clother;
    } else if (param == '4') {
      // currentScene = clother;
      currentOverlay = particulas;
    } else if (param == '7') {
      currentOverlay = arcos;
      arcos.mousePressed();
    } else if (param == '6') {
      currentOverlay = null;
    } else if (param == 'B') {
      bg = true;
    }else if (param == 'b') {
      bg = false;
    }

    currentScene.keyPressed((char)param);
    if (currentOverlay != null)
      currentOverlay.keyPressed((char)param);
      
    currentText.keyPressed((char)param);
  }

  println(" typetag: "+theOscMessage.typetag());
}