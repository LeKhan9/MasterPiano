/*---------------------------------------------------------------------------------------------------
Mohammad Khan

White Key class makes the White Keys in the application and allows user interaction.

Refer to Black Key class for further details on methods and variables
---------------------------------------------------------------------------------------------------*/

class WhiteKey {
      
      int x1,x2,x3,x4,x5;
      public boolean pressed = false;
      
      WhiteKey(int x1, int x2, int x3, int x4, int x5){
          this.x1 = x1;
          this.x2 = x2;
          this.x3 = x3;
          this.x4 = x4;
          this.x5 = x5;
      }
      
      boolean isClicked(){
         if(mouseX> (x1) && mouseX<(x1+x3) && mouseY<(x2+x4) && mouseY>(x2+(x4/3)*2)&& (mousePressed == true)){
            return true;
         }
         else{
            return false;
         }
      }
      
      // if the rightmost white key is clicked, bigger range
      boolean isClicked2(){
         if(mouseX> (x1) && mouseX<(x1+x3) && mouseY<(x2+x4) && mouseY>(x2) && (mousePressed == true)){
            return true;
         }
         else{
            return false;
         }
      }
      
      void changeColor()
      {
        fill(70);
        display();
      }
      
      void display(){
        strokeWeight(1.3);
        rect(x1,x2, x3, x4, x5);
      }
}
