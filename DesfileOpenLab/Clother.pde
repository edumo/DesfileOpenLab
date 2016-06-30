class Clother extends AbstractScene implements Scene {

  PVector pos = new PVector();
  PVector size = new PVector();

  PVector pos1 = new PVector();
  PVector size1 = new PVector();

  PVector pos2 = new PVector();
  PVector size2 = new PVector();

  PVector pos3 = new PVector();
  PVector size3 = new PVector();

  float rotate = 0;
  float rotate1 = 0;
  float rotate2 = 0;
  float rotate3 = 0;

  public void load() {

    super.load();
  }

  public void myDraw(PGraphics canvas) {

    super.myDraw(canvas);
    canvas.fill(255);
    canvas.textAlign(CENTER);
    canvas.textSize(48);

    canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotate(rotate);
    canvas.fill(0, 255, 0, 150);
    canvas.rect(pos.x, pos.y, size.x, size.y);
    canvas.popMatrix();
    
     canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotate(rotate1);
    canvas.fill(255, 255, 0, 150);
    canvas.rect(pos1.x, pos1.y, size1.x, size1.y);
   
    canvas.popMatrix();
    
     canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotate(rotate2);
    canvas.fill(255, 0, 0, 150);
    canvas.rect(pos2.x, pos2.y, size2.x, size2.y);
  
    canvas.popMatrix();
    
     canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotate(rotate3);
    canvas.fill(255, 0, 255, 150);
    canvas.rect(pos3.x, pos3.y, size3.x, size3.y);
    canvas.popMatrix();
   

    

    //canvas.text("Clother", width/2, height/2);
  }

  public void action(OscMessage theOscMessage) {
  }

  void mousePressed() {
    super.mousePressed();
    rotate = random(0, PI*2);
    rotate1 = random(0, PI*2);
    rotate2 = random(0, PI*2); 
    rotate3 = random(0, PI*2);
    size.x = 0;
    size.y = 0;

    size2.x = 0;
    size2.y = 0;

    Ani.to(size, 1.5, "x", random(width, width));
    Ani.to(size, 2.5, "y", random(height/3, height));
    pos.x = random(-width/2, width/2);
    pos.y = random(-width/2, width/2);

    Ani.to(size1, 4.5, "x", random(width, width));
    Ani.to(size1, 1.5, "y", random(height/7, height/3));
    pos1.x = random(-width/2, width/2);
    pos1.y = random(-width/2, width/2);

    Ani.to(size2, 2.5, "x", random(width, width));
    Ani.to(size2, 3.5, "y", random(height/5, height/2));
    pos2.x = random(-width/2, width/2);
    pos2.y = random(-width/2, width/2);

    Ani.to(size3, 1.5, "x", random(width, width));
    Ani.to(size3, 1.5, "y", random(height/13, height/6));
    pos3.x = random(-width/2, width/2);
    pos3.y = random(-width/2, width/2);
  }

  void keyPressed(int key) {
  }
}

