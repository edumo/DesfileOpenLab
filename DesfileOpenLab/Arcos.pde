
class Arcos implements Scene {

  ArrayList<Arc> arcs;
  ArrayList<Arc> arcs2;
  int mode;
  boolean deux;
  boolean rnd;
  boolean musicLoaded=false;
  int fadeTimer;

  ArrayList<PImage> imgs = new ArrayList(); 

  public void load() {

    for (int i = 0; i<4; i++) {
      PImage img = loadImage("cosiendo-tetuan-1.jpg");
      imgs.add(img);
    }
  }

  public void myDraw(PGraphics canvas) {

    canvas.fill(255);


    if (myMousePressed) {
      generateArcs();
      myMousePressed = false;
    }

    //if(musicLoaded){
    if (arcs != null) {
      for (int i=0; i<arcs.size(); i++) {
        Arc a = (Arc) arcs.get(i);
        canvas.pushMatrix();
        if (deux) {
          canvas.translate(3*canvas.width/4, canvas.height/2);
          canvas.scale(.9);
        } else {
          canvas.translate(canvas.width/2, canvas.height/2);
          canvas.scale(1.2);
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
          canvas.scale(.7);
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
  void fadeOut(PGraphics canvas) {
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

  void generateArcs() {
    fadeTimer=0;
    al=0;
    if (rnd) deux=random(1)>.3 ? deux : random(1)>.5;
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

  void setRandom() {
    rnd=!rnd;
  }

  float ease(float variable, float target, float easingVal) {
    float d = target - variable;
    if (abs(d)>1) variable+= d*easingVal;
    return variable ;
  }

  // float maxA=0;
  float vol, pvol;
  void analyzeVolume(float a) {
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
    if (myMousePressed) {
      generateArcs();
      myMousePressed = false;
    }
    pvol=vol;
  }

  public void action(OscMessage theOscMessage) {
  }


  class Arc {
    int nbEllipses, nbTraits, longueurTrait, rang, sw;
    float depart, espaceTraits;
    color c;
    Trait[] traits;
    float[] pos;
    float[] posTarget;

    Arc(int _rang) {
      nbTraits = (int) random(10, 100);
      espaceTraits = (int) random(2, 5);
      depart = random(360);
      longueurTrait = (int) random(1, 10)*10;
      sw=(int)random(1, 12);
      c=random(1)<.2?color(255, 0, 0):color(255);//black Version
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

    void draw(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].draw(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    void anime1(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].anime1(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    void anime2(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(depart+i*espaceTraits));
        canvas.translate(250-rang*30, 0);
        traits[i].anime2(canvas);
        canvas.popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    void anime3(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        pushMatrix();
        rotate(radians(depart+i*espaceTraits));
        translate(250-rang*30, 0);
        traits[i].anime3(canvas);
        popMatrix();

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    void anime4(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        pushMatrix();
        rotate(radians(pos[i]));
        translate(250-rang*30, 0);
        traits[i].anime1(canvas);
        popMatrix();

        pos[i]=ease(pos[i], posTarget[i], 0.05);

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }

    void anime5(PGraphics canvas) {
      for (int i=0; i<nbTraits; i++) {
        canvas.pushMatrix();
        canvas.rotate(radians(pos[i]));
        canvas.translate(250-rang*30, 0);
        traits[i].anime2(canvas);
        canvas.popMatrix();

        pos[i]=ease(pos[i], posTarget[i], 0.05);

        if ((i+1)*espaceTraits>335) i=nbTraits;
      }
    }
  }



  class Trait {
    int id, swTarget, longueurTraitTarget, transpTarget;
    float sw, longueurTrait, transp;
    color c;

    Trait(int _id, int _sw, int _longueurTrait, color _c) {
      id=_id;
      swTarget=_sw;
      c=_c;
      longueurTraitTarget=_longueurTrait;
      transpTarget=255;
    }

    void draw(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transpTarget);
      canvas.noStroke();
      canvas.line(0, 0, longueurTraitTarget, 0);
    }

    void anime1(PGraphics canvas) {
      canvas.strokeWeight(sw);
      canvas.stroke(c, transpTarget);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1);
      sw=ease(sw, swTarget, 0.1);
    }

    void anime2(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transp);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1);
      transp=ease(transp, transpTarget, 0.1);
    }

    void anime3(PGraphics canvas) {
      canvas.strokeWeight(swTarget);
      canvas.stroke(c, transpTarget);
      canvas.line(0, 0, longueurTrait, 0);
      longueurTrait=ease(longueurTrait, longueurTraitTarget, 0.1);
    }
  }
  void mousePressed() {
  }

  void keyPressed(int key) {
  }
}