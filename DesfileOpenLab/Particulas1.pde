
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

  void randomize() {

    //numParticles =(int) random(50,500);
    fadeAmount = random(.5, 20);
    maxLen = random(30, 200);
    strokeAmount = random(0.2, 0.6);

    for (int i=0; i<numParticles; i++) {
      particles[i]=new Particle(i/5000.0);
    }
  }

  void mousePressed() {
    randomize();
  }

  void keyPressed(int key) {
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

    void init() {
      x=xp=random(0, FIELDWIDTH*2) - FIELDWIDTH;
      y=yp=random(0, FIELDHEIGHT*2) - FIELDWIDTH;
      z=zp=0;
      s=random(2, 7);
      sColor = map(x, 0, FIELDWIDTH, 0, 100);
      len = random(1, maxLen-1);
    }

    void update() {

      id+=0.01;

      if (mouseY == 0|| mouseX == 0) {
        mouseY = 1;
        mouseX = 1;
      }

      d=(noise(id, x/mouseY, y/mouseY)-0.5)*mouseX;  


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
      fill(sColor, 80, 90);
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