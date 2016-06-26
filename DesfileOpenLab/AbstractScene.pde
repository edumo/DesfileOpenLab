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

     fill(selectedColor.toARGB(),20);
     rect(0,0,width,height);
  }

  public void action(OscMessage theOscMessage) {
  }

  void mousePressed() {
      selectedColor = colors.getRandom();
  }

  void keyPressed(int key) {
  }
}