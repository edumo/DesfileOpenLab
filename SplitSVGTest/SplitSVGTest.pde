import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import geomerative.*;

RShape grp;

ArrayList<RShape> shapes = new ArrayList();

int first = 0;
int current = 0;
float state = 0;

void setup(){
  size(600, 600);
  smooth();

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  
  loadMyShape("legosmile.svg");
  loadMyShape("princestyle.svg");
  loadMyShape("bot2.svg");
  loadMyShape("bot5.svg");
  loadMyShape("shopping-girls.svg");
  loadMyShape("Andy_Warhol.svg");
  
  Ani.init(this);
  
}

void loadMyShape(String path){
 grp = RG.loadShape(path);
  grp = RG.centerIn(grp, g);
  shapes.add(grp); 
}

void draw(){
  translate(width/2, height/2);
  background(#2D4D83);
  
  float t = map(state, 0, width, 0, 1);
  RShape[] splittedGroups = grp.splitPaths(t);
  
  RG.shape(splittedGroups[first]);
}

void mousePressed(){
  //first = (first + 1) % 2;
  
  if(state < 2){
    Ani.to(this, 1.5, "state", width);
    grp = shapes.get(current);
    current++;
    if(current >= shapes.size()){
       current = 0; 
    }
  }else{
    Ani.to(this, 1.5, "state", 0);
  }
}