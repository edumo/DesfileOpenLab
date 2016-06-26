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

  void mousePressed() {
  }

  void keyPressed(int key) {
  }
}