/*---------------------------------------------------------------------------------------------------
Mohammad Khan

Stack class that allows us to push keys, print them, and pop keys when we want to delete them 
from visualization
---------------------------------------------------------------------------------------------------*/

class Stack{
  String[] numStack;
  int size=0;
  
  Stack(){
    numStack= new String[16];
  }
  
  void push(String val){
    numStack[size++]=val;
  }
  
  String pop(){
    return numStack[--size];
  }
  
  String peek(){
    return numStack[size-1];
  }
  
  boolean isEmpty(){
    if(size==0){
      return true;
    }
    else
      return false;
  }
  
  int size(){
    return size;
  }
  
  // returns the array so that our stack is avaiable in another class
  String[] getStack(){
    return numStack;
  }
}
