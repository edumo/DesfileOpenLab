import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import toxi.color.*; 
import toxi.color.theory.*; 
import toxi.util.datatypes.*; 
import java.util.*; 
import de.looksgood.ani.*; 
import de.looksgood.ani.easing.*; 
import geomerative.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DesfileOpenLab extends PApplet {

/**
 * oscP5multicast by andreas schlegel
 * example shows how to send osc via a multicast socket.
 * what is a multicast? http://en.wikipedia.org/wiki/Multicast
 * ip multicast ranges and uses:
 * 224.0.0.0 - 224.0.0.255 Reserved for special \ufffdwell-known\ufffd multicast addresses.
 * 224.0.1.0 - 238.255.255.255 Globally-scoped (Internet-wide) multicast addresses.
 * 239.0.0.0 - 239.255.255.255 Administratively-scoped (local) multicast addresses.
 * oscP5 website at http://www.sojamo.de/oscP5
 */














boolean bg = true;

OscP5 oscP5;

Scene cosiendoTetuan;
Scene clother;
Scene vidaCoral;

Scene currentScene = null;
Scene currentOverlay = null;

Scene arcos = null;
Scene particulas = null;




public void setup() {
  
  frameRate(24);
  /* create a new instance of oscP5 using a multicast socket. */
  oscP5 = new OscP5(this, "192.168.1.255", 7777);

 RG.init(this);
 
   
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
}


public void draw() {

  if (bg)
    background(100);

  currentScene.myDraw(g);

  if (currentOverlay != null)
    currentOverlay.myDraw(g);
}

public void mousePressed() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/mousePressed");
  myOscMessage.add(100);
  oscP5.send(myOscMessage);
}

public void mouseMoved() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/mouseMoved");
  myOscMessage.add(mouseX/(float)width);
  myOscMessage.add(mouseY/(float)height);
  oscP5.send(myOscMessage);
}

public void keyPressedScene(char c) {
  OscMessage myOscMessage = new OscMessage("/keyPressed");
  myOscMessage.add(c);
  oscP5.send(myOscMessage);
}

public void keyPressed() {
  keyPressedScene(key);
}

/*void changeScene(int scene) {
 OscMessage myOscMessage = new OscMessage("/scene");
 myOscMessage.add(scene);
 oscP5.send(myOscMessage);
 }*/


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
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
  }

  println(" typetag: "+theOscMessage.typetag());
}
class AbstractScene implements Scene {

  ArrayList<PImage> imgs = new ArrayList(); 

  ColorList colors = null;

  TColor selectedColor = null;
  public void load() {

    for (int i = 0; i<4; i++) {
      PImage img = loadImage("cosiendo-tetuan-1.jpg");
      imgs.add(img);
    }

    TColor col = ColorRange.DARK.getColor();
    col.setRGB(4/255f, 190/255f, 189/255f);
    background(col.toARGB());
    int yoff = 130;

    ColorTheoryStrategy strategy = ColorTheoryRegistry.COMPLEMENTARY;
    colors = ColorList.createUsingStrategy(strategy, col);
    strategy = ColorTheoryRegistry.SPLIT_COMPLEMENTARY;
    ColorList colors2 = ColorList.createUsingStrategy(strategy, col);
    for (Iterator i = colors2.iterator(); i.hasNext(); ) {
      TColor c = (TColor) i.next();
      colors.add(c);
      selectedColor = c;
    }
  }

  public void myDraw(PGraphics canvas) {

     fill(selectedColor.toARGB(),40);
     rect(0,0,width,height);
  }

  public void action(OscMessage theOscMessage) {
  }

  public void mousePressed() {
      selectedColor = colors.getRandom();
  }

  public void keyPressed(int key) {
  }
}

class Arcos implements Scene {

  ArrayList<Arc> arcs;
  ArrayList<Arc> arcs2;
  int mode;
  boolean deux;
  boolean rnd;
  boolean musicLoaded=false;
  int fadeTimer;
boolean myMousePressed2 = false;
  ArrayList<PImage> imgs = new ArrayList(); 

  public void load() {
    
    for (int i = 0; i<4; i++) {
      PImage img = loadImage("cosiendo-tetuan-1.jpg");
      imgs.add(img);
    }
  }

  public void myDraw(PGraphics canvas) {

    canvas.fill(255);


    if (myMousePressed2) {
      generateArcs();
      myMousePressed2 = false;
    }

    //if(musicLoaded){
    if (arcs != null) {
      for (int i=0; i<arcs.size(); i++) {
        Arc a = (Arc) arcs.get(i);
        canvas.pushMatrix();
        if (deux) {
          canvas.translate(3*canvas.width/4, canvas.height/2);
          canvas.scale(.9f);
        } else {
          canvas.translate(canvas.width/2, canvas.height/2);
          canvas.scale(1.2f);
        }
        switch(mode) {
        case 0:
          a.draw(canvas);
          break;
        case 1:
          a.anime1(canvas);
          break;
        case 2:
          a.anime2(canvas);
          break;
        case 3:
          a.anime3(canvas);
          break;
        case 4:
          a.anime4(canvas);
          break;
        case 5:
          a.anime5(canvas);
          break;
        }
        canvas.popMatrix();
        if (deux) {
          Arc b = (Arc) arcs2.get(i);
          canvas.pushMatrix();
          canvas.translate(width/4, height/2);
          canvas.scale(.7f);
          switch(mode) {
          case 0:
            b.draw(canvas);
            break;
          case 1:
            b.anime1(canvas);
            break;
          case 2:
            b.anime2(canvas);
            break;
          case 3:
            b.anime3(canvas);
            break;
          case 4:
            b.anime4(canvas);
            break;
          case 5:
            b.anime5(canvas);
            break;
          }
          canvas.popMatrix();
        }
      }

      fadeTimer++;
      if (fadeTimer>300) {
        fadeOut(canvas);
      }
    } else {
      canvas.fill(255);
      canvas.textAlign(CENTER);
    }
  }

  int al=0, al2=255;
  public void fadeOut(PGraphics canvas) {
    canvas.fill(0, al);
    canvas.noStroke();
    canvas.rect(0, 0, canvas.width, canvas.height);
    if (al<255) al++;
    if (al>=255) {
      // if(logo.width>1) image(logo,width/2,height/2);
      if (al2>0) {
        al2--;
        canvas.fill(0, al2);
        canvas.rect((canvas.width-800)/2, (canvas.height-600)/2, 800, 600);
      }
    }
  }

  public void generateArcs() {
    fadeTimer=0;
    al=0;
    if (rnd) deux=random(1)>.3f ? deux : random(1)>.5f;
    mode=(int) random(1, 6);
    arcs = new ArrayList<Arc>();
    arcs2 = new ArrayList<Arc>();

    int nbEllipses;
    for (int k=0; k<2; k++) {
      nbEllipses = (int) random(3, 9);
      for (int j=0; j<nbEllipses; j++) {
        arcs.add(new Arc(j));
        arcs2.add(new Arc(j));
      }
    }
  }

  public void setRandom() {
    rnd=!rnd;
  }

  public float ease(float variable, float target, float easingVal) {
    float d = target - variable;
    if (abs(d)>1) variable+= d*easingVal;
    return variable ;
  }

  // float maxA=0;
  float vol, pvol;
  public void analyzeVolume(float a) {
    // test to get max value
    /*
    if(a>maxA){
     maxA=a;
     println("maxA: "+maxA);
     }
     */
    if (!musicLoaded && a>0) {
      generateArcs();
      musicLoaded = true;
    }

    // fake beat listener
    vol=a;
    //if(vol-pvol>25) generateArcs();
   
    pvol=vol;
  }

  public void action(OscMessage theOscMessage) {
  }


  class Arc {
    int nbEllipses, nbTraits, longueurTrait, rang, sw;
    float depart, espaceTraits;
    int c;
    Trait[] traits;
    float[] pos;
    float[] posTarget;

    Arc(int _rang) {
      nbTraits = (int) random(10, 100);
      espaceTraits = (int) random(2, 5);
      depart = random(360);
      longueurTrait = (int) random(1, 10)*10;
      sw=(int)random(1, 12);
      c=random(1)<.2f?color(255, 0, 0):color(255);//black Version
      //c=random(1)<.2?color(255, 0, 0):color(0);//white Version
      rang=_rang;

      traits = new Trait[nbTraits];
      for (int i=0; i<nbTraits; i++) {
        traits[i]=new Trait(i, sw, longueurTrait, c);
      }
      pos= new float[nbTraits];
      //Arrays.fill(pos,0);
      posTarget= new float[nbTraits];
      for (int i=0; i<nbTraits; i++) {
        pos[i]=0;
        posTarget[i]=depart+i*espaceTraits;
      }
    }

    public void draw(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].draw(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    public void anime1(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].anime1(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    public void anime2(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].anime2(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    public void anime3(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        pushMatrix();
        rotate(radians(depart+i*espaceTraits));
        translate(250-rang*30, 0);
        traits[i].anime3(canvas);
        popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    public void anime4(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        pushMatrix();
        rotate(radians(pos[i]));
        translate(250-rang*30, 0);
        traits[i].anime1(canvas);
        popMatrix();

        pos[i]=ease(pos[i], posTarget[i], 0.05f);

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    public void anime5(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(pos[i]));
        canvas.translate(250-rang*30, 0);
        traits[i].anime2(canvas);
        canvas.popMatrix();

        pos[i]=ease(pos[i], posTarget[i], 0.05f);

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }
  }



  class Trait {
    int id, swTarget, longueurTraitTarget, transpTarget;
    float sw, longueurTrait, transp;
    int c;

    Trait(int _id, int _sw, int _longueurTrait, int _c) {
      id=_id;
      swTarget=_sw;
      c=_c;
      longueurTraitTarget=_longueurTrait;
      transpTarget=255;
    }

    public void draw(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transpTarget);
      canvas.noStroke();
      canvas.line(0, 0, longueurTraitTarget, 0);
    }

    public void anime1(PGraphics canvas) {
      canvas.strokeWeight(sw);
      canvas.stroke(c, transpTarget);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1f);
      sw=ease(sw, swTarget, 0.1f);
    }

    public void anime2(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transp);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1f);
      transp=ease(transp, transpTarget, 0.1f);
    }

    public void anime3(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transpTarget);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1f);
    }
  }
  public void mousePressed() {
    myMousePressed2 = true;
  }

  public void keyPressed(int key) {
  }
}
class Clother extends AbstractScene implements Scene {

  ArrayList<PImage> imgs = new ArrayList(); 

  public void load() {

    for (int i = 0; i<4; i++) {
      PImage img = loadImage("cosiendo-tetuan-1.jpg");
      imgs.add(img);
    }
  }

  public void myDraw(PGraphics canvas) {

    
    canvas.fill(255);
    canvas.textAlign(CENTER);
    canvas.textSize(48);
    canvas.text("Clother", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }

  public void mousePressed() {
  }

  public void keyPressed(int key) {
  }
}
class Coral extends AbstractScene implements Scene {

  ArrayList<PImage> imgs = new ArrayList(); 

  RShape grp;

  ArrayList<RShape> shapes = new ArrayList();

  int first = 0;
  int current = 0;
  float state = 0;

  public void load() {

    super.load();

    loadMyShape("legosmile.svg");
    loadMyShape("cookiemouth.svg");
    loadMyShape("princestyle.svg");
    loadMyShape("bot2.svg");
    loadMyShape("bot5.svg");
    loadMyShape("shopping-girls.svg");
    loadMyShape("Andy_Warhol.svg");
  }


  public void loadMyShape(String path) {
    grp = RG.loadShape(path);
    grp = RG.centerIn(grp, g);
    shapes.add(grp);
  }
  public void myDraw(PGraphics canvas) {

    super.myDraw(canvas);

    canvas.pushMatrix();
    canvas.translate(width/2, height/2);
    //canvas.background(#2D4D83);

    float t = map(state, 0, width, 0, 1);
    RShape[] splittedGroups = grp.splitPaths(t);

    RG.shape(splittedGroups[first]);
    canvas.popMatrix();
    canvas.text("Coral", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }
  public void mousePressed() {

    super.mousePressed();
    
    if (state < 2) {
      Ani.to(this, 1.5f, "state", width);
      grp = shapes.get(current);
      current++;
      if (current >= shapes.size()) {
        current = 0;
      }
    } else {
      Ani.to(this, 1.5f, "state", 0);
    }
  }
  public void keyPressed(int key) {
  }
}


class CosiendoTetuan extends AbstractScene implements Scene {

  // Substrate Watercolor
  // j.tarbell   June, 2004
  // Albuquerque, New Mexico
  // complexification.net

  // Processing 0085 Beta syntax update
  // j.tarbell   April, 2005

  int dimx = 250;
  int dimy = 250;
  int num = 0;
  int maxnum = 100;

  // grid of cracks
  int[] cgrid;
  Crack[] cracks;

  // color parameters
  int maxpal = 512;
  int numpal = 0;
  int[] goodcolor = new int[maxpal];

  // sand painters
  SandPainter[] sands;

  boolean beginis = false;

  public void load() {
    super.load();
    dimx = width;
    dimy = height;
    background(255);
    takecolor("cosiendo-tetuan-3.jpg");

    cgrid = new int[dimx*dimy];
    cracks = new Crack[maxnum];
  }

  public void myDraw(PGraphics canvas) {
    // crack all cracks
    if (beginis) {
      begin(canvas);
      beginis = false;
    }

    for (int n=0; n<num; n++) { //<>//
      cracks[n].move(canvas);
    }

    canvas.fill(255);
   // canvas.rect(0, 0, 150, 20);
    canvas.fill(0);
    canvas.text(frameRate, 10, 10);
    canvas.text("Cosiendo tetuan", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }

  public void mousePressed() {
    super.mousePressed();
    beginis = true;
  }
  public void keyPressed(int key) {
  }

  public void makeCrack() {
    if (num<maxnum) {
      // make a new crack instance
      cracks[num] = new Crack();
      num++;
    }
  }


  public void begin(PGraphics canvas) {
    // erase crack grid
    for (int y=0; y<dimy; y++) {
      for (int x=0; x<dimx; x++) {
        cgrid[y*dimx+x] = 10001;
      }
    }
    // make random crack seeds
    for (int k=0; k<16; k++) {
      int i = PApplet.parseInt(random(dimx*dimy-1));
      cgrid[i]=PApplet.parseInt(random(360));
    }

    // make just three cracks
    num=0;
    for (int k=0; k<3; k++) {
      makeCrack();
    }
    canvas.background(255);
  }



  // COLOR METHODS ----------------------------------------------------------------

  public int somecolor() {
    // pick some random good color
    return goodcolor[PApplet.parseInt(random(numpal))];
  }

  public void takecolor(String fn) {
    PImage b;
    b = loadImage(fn);
    image(b, 0, 0);

    for (int x=0; x<b.width; x++) {
      for (int y=0; y<b.height; y++) {
        int c = get(x, y);
        boolean exists = false;
        for (int n=0; n<numpal; n++) {
          if (c==goodcolor[n]) {
            exists = true;
            break;
          }
        }
        if (!exists) {
          // add color to pal
          if (numpal<maxpal) {
            goodcolor[numpal] = c;
            numpal++;
          }
        }
      }
    }
  }




  // OBJECTS -------------------------------------------------------

  class Crack {
    float x, y;
    float t;    // direction of travel in degrees

    // sand painter
    SandPainter sp;

    Crack() {
      // find placement along existing crack
      findStart();
      sp = new SandPainter();
    }

    public void findStart() {
      // pick random point
      int px=0;
      int py=0;

      // shift until crack is found
      boolean found=false;
      int timeout = 0;
      while ((!found) || (timeout++>1000)) {
        px = PApplet.parseInt(random(dimx));
        py = PApplet.parseInt(random(dimy));
        if (cgrid[py*dimx+px]<10000) {
          found=true;
        }
      }

      if (found) {
        // start crack
        int a = cgrid[py*dimx+px];
        if (random(100)<50) {
          a-=90+PApplet.parseInt(random(-2, 2.1f));
        } else {
          a+=90+PApplet.parseInt(random(-2, 2.1f));
        }
        startCrack(px, py, a);
      } else {
        //println("timeout: "+timeout);
      }
    }

    public void startCrack(int X, int Y, int T) {
      x=X;
      y=Y;
      t=T;//%360;
      x+=0.61f*cos(t*PI/180);
      y+=0.61f*sin(t*PI/180);
    }

    public void move(PGraphics canvas) {
      // continue cracking
      x+=0.42f*cos(t*PI/180);
      y+=0.42f*sin(t*PI/180); 

      // bound check
      float z = 0.33f;
      int cx = PApplet.parseInt(x+random(-z, z));  // add fuzz
      int cy = PApplet.parseInt(y+random(-z, z));

      // draw sand painter
      regionColor();

      // draw black crack
      canvas.stroke(0, 85);
      canvas.point(x+random(-z, z), y+random(-z, z));


      if ((cx>=0) && (cx<dimx) && (cy>=0) && (cy<dimy)) {
        // safe to check
        if ((cgrid[cy*dimx+cx]>10000) || (abs(cgrid[cy*dimx+cx]-t)<5)) {
          // continue cracking
          cgrid[cy*dimx+cx]=PApplet.parseInt(t);
        } else if (abs(cgrid[cy*dimx+cx]-t)>2) {
          // crack encountered (not self), stop cracking
          findStart();
          makeCrack();
        }
      } else {
        // out of bounds, stop cracking
        findStart();
        makeCrack();
      }
    }

    public void regionColor() {
      // start checking one step away
      float rx=x;
      float ry=y;
      boolean openspace=true;

      // find extents of open space
      while (openspace) {
        // move perpendicular to crack
        rx+=0.81f*sin(t*PI/180);
        ry-=0.81f*cos(t*PI/180);
        int cx = PApplet.parseInt(rx);
        int cy = PApplet.parseInt(ry);
        if ((cx>=0) && (cx<dimx) && (cy>=0) && (cy<dimy)) {
          // safe to check
          if (cgrid[cy*dimx+cx]>10000) {
            // space is open
          } else {
            openspace=false;
          }
        } else {
          openspace=false;
        }
      }
      // draw sand painter
      //  sp.render(rx,ry,x,y);
    }
  }


  class SandPainter {

    int c;
    float g;

    SandPainter() {

      c = somecolor();
      g = random(0.01f, 0.1f);
    }
    public void render(float x, float y, float ox, float oy) {
      // modulate gain
      g+=random(-0.050f, 0.050f);
      float maxg = 1.0f;
      if (g<0) g=0;
      if (g>maxg) g=maxg;

      // calculate grains by distance
      //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));
      int grains = 64;

      // lay down grains of sand (transparent pixels)
      float w = g/(grains-1);
      for (int i=0; i<grains; i++) {
        float a = 0.1f-i/(grains*10.0f);
        stroke(red(c), green(c), blue(c), a*256);
        point(ox+(x-ox)*sin(sin(i*w)), oy+(y-oy)*sin(sin(i*w)));
      }
    }
  }
}

class Particulas1 implements Scene {

  // Noise Field
  // Particle trails via Perlin noise. 
  // Move mouse to change particle motion. 
  // Click to randomize parameters.
  // Built with Processing.js (processingjs.org)
  // by Felix Turner (airtightinteractive.com)

  int numParticles = 50;
  float fadeAmount;
  float maxLen = 100;
  float strokeAmount;

  Particle[] particles = new Particle[numParticles];
  int FIELDWIDTH = 400;
  int FIELDHEIGHT = 440;

  int UP = 1;
  int DOWN = 2;
  int NONE = 0;
  int LEFT = 1;
  int RIGHT = 2;

  int stateV =  UP;
  int stateH =  LEFT;

  public void load() {

    randomize();
  }

  public void myDraw(PGraphics canvas) {

    noStroke();
    fill(0, fadeAmount);
    rect(0, 0, width, height);//fade background

    translate((width- FIELDWIDTH)/2, (height- FIELDHEIGHT)/2);
    for (int i=0; i<numParticles; i++) {
      particles[i].update();//render particles
    } 

    fill(255);
    if (frameCount % 50 == 0)
      println(""+frameRate, 100, 100);
  }

  public void randomize() {

    //numParticles =(int) random(50,500);
    fadeAmount = random(.5f, 20);
    maxLen = random(30, 200);
    strokeAmount = random(0.2f, 0.6f);

    for (int i=0; i<numParticles; i++) {
      particles[i]=new Particle(i/5000.0f);
    }
  }

  public void mousePressed() {
    randomize();
  }

  public void keyPressed(int key) {
    if (key == 'q') {
      stateV = UP;
    } else if (key == 'w') {
      stateV = DOWN;
    }
    if (key == 'e') {
      stateH = LEFT;
    } else if (key == 'r') {
      stateH = RIGHT;
    }
  }



  class Particle {
    float id, x, y, xp, yp, s, d, sColor, len, z, zp;

    Particle(float _id) {
      id=_id;
      init();
    }

    public void init() {
      x=xp=random(0, FIELDWIDTH*2) - FIELDWIDTH;
      y=yp=random(0, FIELDHEIGHT*2) - FIELDWIDTH;
      z=zp=0;
      s=random(2, 7);
      sColor = map(x, 0, FIELDWIDTH, 0, 100);
      len = random(1, maxLen-1);
    }

    public void update() {

      id+=0.01f;

      if (mouseY == 0|| mouseX == 0) {
        mouseY = 1;
        mouseX = 1;
      }

       sColor = map(x, 0, FIELDWIDTH, 150, 255);

      d=(noise(id, x/mouseY, y/mouseY)-0.5f)*mouseX;  


      // x-=cos(radians(d))*s;

      if (stateV == UP)
        y+=sin(radians(d))*s*2;
      if (stateV == DOWN)
        y-=sin(radians(d))*s*2;

      if (stateH == LEFT)
        x-=cos(radians(d))*s*2;
      if (stateH == RIGHT)
        x+=cos(radians(d))*s*2;

      // strokeWeight((maxLen - len)*strokeAmount);
      fill(sColor, 200, 90);
      stroke(26, 0, 100);
      strokeWeight(0);
      rect(xp, yp, (maxLen - len)*strokeAmount, (maxLen - len)*strokeAmount);
      xp=x;
      yp=y;
      len++;
      if (len >= maxLen) init();
    }
  }

  public void action(OscMessage theOscMessage) {
  }
  
  
}
public interface Scene{
 
  public void myDraw(PGraphics canvas);
  
   public void load();
   
   public void action(OscMessage theOscMessage);
   
   public void mousePressed() ;
   
   public void keyPressed(int key);
}
  public void settings() {  size(1024, 768); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DesfileOpenLab" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
