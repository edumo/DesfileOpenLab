
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
  color[] goodcolor = new color[maxpal];

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
   // canvas.text("Cosiendo tetuan", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }

  void mousePressed() {
    super.mousePressed();
    beginis = true;
  }
  void keyPressed(int key) {
  }

  void makeCrack() {
    if (num<maxnum) {
      // make a new crack instance
      cracks[num] = new Crack();
      num++;
    }
  }


  void begin(PGraphics canvas) {
    // erase crack grid
    for (int y=0; y<dimy; y++) {
      for (int x=0; x<dimx; x++) {
        cgrid[y*dimx+x] = 10001;
      }
    }
    // make random crack seeds
    for (int k=0; k<16; k++) {
      int i = int(random(dimx*dimy-1));
      cgrid[i]=int(random(360));
    }

    // make just three cracks
    num=0;
    for (int k=0; k<3; k++) {
      makeCrack();
    }
    canvas.background(0);
  }



  // COLOR METHODS ----------------------------------------------------------------

  color somecolor() {
    // pick some random good color
    return goodcolor[int(random(numpal))];
  }

  void takecolor(String fn) {
    PImage b;
    b = loadImage(fn);
    image(b, 0, 0);

    for (int x=0; x<b.width; x++) {
      for (int y=0; y<b.height; y++) {
        color c = get(x, y);
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

    void findStart() {
      // pick random point
      int px=0;
      int py=0;

      // shift until crack is found
      boolean found=false;
      int timeout = 0;
      while ((!found) || (timeout++>1000)) {
        px = int(random(dimx));
        py = int(random(dimy));
        if (cgrid[py*dimx+px]<10000) {
          found=true;
        }
      }

      if (found) {
        // start crack
        int a = cgrid[py*dimx+px];
        if (random(100)<50) {
          a-=90+int(random(-2, 2.1));
        } else {
          a+=90+int(random(-2, 2.1));
        }
        startCrack(px, py, a);
      } else {
        //println("timeout: "+timeout);
      }
    }

    void startCrack(int X, int Y, int T) {
      x=X;
      y=Y;
      t=T;//%360;
      x+=0.61*cos(t*PI/180);
      y+=0.61*sin(t*PI/180);
    }

    void move(PGraphics canvas) {
    float size = 0.2f + mouseX/(float)width;
        
        x += (0.82f + size*2) * cos(t * PI / 180);
        y += (0.82f + size*2) * sin(t * PI / 180);

        // bound check
        float z = 0.33f;
        int cx = PApplet.parseInt(x + random(-z, z)); // add fuzz
        int cy = PApplet.parseInt(y + random(-z, z));

        // draw sand painter
        regionColor();

        // draw black crack
          canvas.strokeWeight(0);
        canvas.stroke(255, 185);
        canvas.fill(255,0,0,200);
        //canvas.point(x + random(-z, z), y + random(-z, z));
        canvas.ellipse(x + random(-z, z), y + random(-z, z),size*3,size*3);

        if ((cx >= 0) && (cx < dimx) && (cy >= 0) && (cy < dimy)) {
          // safe to check
          if ((cgrid[cy * dimx + cx] > 10000)
              || (abs(cgrid[cy * dimx + cx] - t) < 5)) {
            // continue cracking
            cgrid[cy * dimx + cx] = PApplet.parseInt(t);
          } else if (abs(cgrid[cy * dimx + cx] - t) > 2) {
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

    void regionColor() {
      // start checking one step away
      float rx=x;
      float ry=y;
      boolean openspace=true;

      // find extents of open space
      while (openspace) {
        // move perpendicular to crack
        rx+=0.81*sin(t*PI/180);
        ry-=0.81*cos(t*PI/180);
        int cx = int(rx);
        int cy = int(ry);
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

    color c;
    float g;

    SandPainter() {

      c = somecolor();
      g = random(0.01, 0.1);
    }
    void render(float x, float y, float ox, float oy) {
      // modulate gain
      g+=random(-0.050, 0.050);
      float maxg = 1.0;
      if (g<0) g=0;
      if (g>maxg) g=maxg;

      // calculate grains by distance
      //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));
      int grains = 64;

      // lay down grains of sand (transparent pixels)
      float w = g/(grains-1);
      for (int i=0; i<grains; i++) {
        float a = 0.1-i/(grains*10.0);
        stroke(red(c), green(c), blue(c), a*256);
        point(ox+(x-ox)*sin(sin(i*w)), oy+(y-oy)*sin(sin(i*w)));
      }
    }
  }
}