class Texto implements Scene {




  RFont font;
  String myText = "MediaLab \n Prado";
  String myText1 = "MediaLab";
  String myText2 = "Prado";
  //COULD USE A NOISE FUNCTION HERE FOR WIGGLE.
  //float wiggle = 3.7;
  boolean stopAnime = false;
  float soundLevelTarget = 0;
  Minim mySound; //CREATE A NEW SOUND OBJECT
  AudioInput myIn;

  boolean draw = false;

  public void load() {

    font = new RFont("FreeSans.ttf", 200, CENTER);
    mySound = minim;
    myIn = in;
  }

  public void myDraw(PGraphics canvas) {

    if (draw) {
      return;
    }

    canvas.pushMatrix();

    canvas.translate(width/2, height/3);

    float soundLevel = in.mix.level(); //GET OUR AUDIO IN LEVEL
    soundLevelTarget = soundLevelTarget + (soundLevel - soundLevelTarget) * 0.15f;
    RCommand.setSegmentLength(soundLevelTarget*1500);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    canvas.fill(255);
     if (!bg) {
      canvas.strokeWeight(2);
      canvas.stroke(0,150);
      
    }else{
       canvas.noStroke(); 
    }
    drawText(canvas, myText1,QUAD);
   
    canvas.translate(0, height/3.0);
    drawText(canvas, myText2,QUAD);
    if (!bg) {
      canvas.fill(0,100);
      drawText(canvas, myText2,TRIANGLE);
    }
    canvas.popMatrix();
  }

  public void drawText(PGraphics canvas, String texto, int shape) {

    RGroup myGoup = font.toGroup(texto); 
    RPoint[] myPoints = myGoup.getPoints();


    canvas.beginShape(shape);
    for (int i=0; i<myPoints.length; i++) {

      canvas.vertex(myPoints[i].x, myPoints[i].y);
    }
    canvas.endShape();
  }

  public void action(OscMessage theOscMessage) {
  }

  void mousePressed() {
  }

  void keyPressed(int key) {

     if (key == '0') {
      myText1 = "MediaLab";
      myText2 = "Prado";
    }
    
    if (key == '1') {
      myText1 = "Cosiendo";
      myText2 = "Tetuán";
    }

    if (key == '2') {
      myText1 = "Coral";
      myText2 = "Una Vida";
    }

    if (key == '3') {
      myText1 = "Clothes";
      myText2 = "'R' Us";
    }

    if (key == 't') {
      draw = ! draw;
    }
  }
}
