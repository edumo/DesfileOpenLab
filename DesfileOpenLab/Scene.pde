public interface Scene{
 
  void myDraw(PGraphics canvas);
  
   void load();
   
   void action(OscMessage theOscMessage);
   
   void mousePressed() ;
   
   void keyPressed(int key);
}