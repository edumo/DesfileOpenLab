class Coral extends AbstractScene implements Scene {

  ArrayList<PImage> imgs = new ArrayList(); 

  RShape grp;

  ArrayList<RShape> shapes = new ArrayList();

  int first = 0;
  int current = 0;
  float state = 0;

  public void load() {

    super.load();
    loadMyShape("bot5.svg");
    loadMyShape("shopping-girls.svg");
    loadMyShape("legosmile.svg");
    loadMyShape("Andy_Warhol.svg");
    loadMyShape("princestyle.svg");
    loadMyShape("cookiemouth.svg");
    loadMyShape("bot2.svg");
  }


  void loadMyShape(String path) {
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
    //canvas.text("Coral", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }
  void mousePressed() {

    super.mousePressed();

    if (state < 2) {
      Ani.to(this, 3.5, "state", width);
      grp = shapes.get(current);
      current++;
      if (current >= shapes.size()) {
        current = 0;
      }
    } else {
      Ani.to(this, 1.5, "state", 0);
    }
  }
  void keyPressed(int key) {
  }
}