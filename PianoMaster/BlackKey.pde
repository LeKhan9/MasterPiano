/*---------------------------------------------------------------------------------------------------
Mohammad Khan

Black Key class makes the Black Keys in the application and allows user interaction.
---------------------------------------------------------------------------------------------------*/


class BlackKey {
    
    int x1,x2,x3,x4,x5;
    public boolean pressed = false; // flag to check if this key is pressed
  
    // constructure that takes coordinate values of key
    BlackKey(int x1, int x2, int x3, int x4, int x5){
        this.x1 = x1;
        this.x2 = x2;
        this.x3 = x3;
        this.x4 = x4;
        this.x5 = x5;
    }
    
    // if mouse clicks on key, return true
    boolean isClicked(){
       if(mouseX> (x1) && mouseX<(x1+x3) && mouseY<(x2+x4) && mouseY>(x2)&& (mousePressed == true)){
          return true;
       }
       else{
          return false;
       }
    }
    
    // changing color of key to show interaction
    void changeColor()
    {
      fill(70);
      display();
    }
    
    // makes the actual key rectangle
    void display(){
      rect(x1,x2, x3, x4, x5);
    }
}
