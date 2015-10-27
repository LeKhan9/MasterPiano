import ddf.minim.*; // sound library
import java.awt.AWTException; // need exception thrown for robot class
import java.awt.Robot; // automating user action
import java.awt.event.KeyEvent; // simulating action for user
import java.awt.event.InputEvent; // also simulating action, but actions like pressing mouse button and other input events

/*---------------------------------------------------------------------------------------------------
Mohammad Khan

An interactive piano with 3 different modes: training, composition, and example. Piano can be played
with the mouse or the keyboard. The goal of this project is to help individuals upskill piano 
fundamentals in regards to music. The user can save composition pieces that they play themselves. 
The user can also open windows for references of the computer keyboard to piano key mapping and a 
reference to twinkle twinkle little star which is an example played on the piano. 
---------------------------------------------------------------------------------------------------*/

PImage bg, mode1, mode2, mode3, backPiano, backPiano2, backPiano3, badge1, badge2, badge3, badge4, composePic, treble;
PShape can, can2, can3;
PShader texShader;

Minim minim;
AudioPlayer song;
AudioPlayer badgeSong;
AudioPlayer bgSound;

// Robot class used to simulate user movement throughout the program
// : key presses, mouse presses, mouse movement, opening up desktop files
Robot robot; 

// variables to keep track of keys
WhiteKey c1,d,e,f,g,a,b,c2; 
BlackKey cs,ds,fs,gs,as;
 
int increment = 0; // point system for training mode
int displacement = 280; // placement of left side of piano keyboard relative to left side of screen

int play = 0;
float angle; // rotating shader can (from class notes)

// flags logic allows us to alternate between different screens and allow no conflicts between mouse presses so that multiple screen do not load at once
// keyboardFlag starts training mode with ENTER press along with trainFlag, and openFile allows us to open a reference file on our Desktop
boolean flag1,flag2,flag3,flag4,flag5, conflict1, conflict2, conflict3, keyboardFlag, trainflag, openFile, openRef;

// flags allow us to tell if keys have been pressed, in order to automatically play them in example mode
boolean c1_, d_, e_, f_, g_, a_, b_, c2_; 
boolean cs_, ds_, fs_, gs_, as_;
boolean sc1,sd,se,sf,sg,sa,sb,sc2;
boolean scs,sds,sfs,sgs,sas;
boolean deleteFlag, introScreenFlag, takePhoto;

// flags used to play sound of badges earned in training mode upon a certain point level reached
boolean soundControl1, soundControl2, soundControl3, soundControl4;

// Stack for the composition mode which allows us to print to the music sheet and delete by popping elements
Stack st= new Stack();
String[] stack= new String[16]; // stack reference to load notes into

// characters to generate random keys to be played in training mode
char[] whitekeys= {'a','b','c','d','e','f','g','h'};
char[] blackkeys= {'C','D','F','G','A'};

void setup(){
      size(1200, 1000, P3D);
      
      // catching Robot class exception and making object 
      try
      {
        robot = new Robot();
      }
      catch (AWTException e)
      {
        println("Robot class not working");
        exit();
      }
      
      minim = new Minim(this);
      
      // loading images to be used throughout program from data dir
      bg = loadImage("WoodColor.jpg");
      mode1 = loadImage("modePic1.jpg");
      mode2 = loadImage("modePic2.jpg");
      mode3 = loadImage("modePic3.jpg");
      backPiano = loadImage("pianoBack.png");
      backPiano2 = loadImage("pianoBack2.png");
      backPiano3 = loadImage("pianoBack3.png");
      badge1 = loadImage("badge1.png");
      badge2 = loadImage("badge2.png");
      badge3 = loadImage("badge3.png");
      badge4 = loadImage("badge4.PNG");
      composePic = loadImage("compose.png");
      treble = loadImage("treble.png");
      
      // creates our rotating cylinders and provides shader reference
      //: obtained from class notes/Moodle - not our work as we just changes dimensions
      can = createCan(100, 100, 32, mode1);
      can2 = createCan(100, 100, 32, mode2);
      can3 = createCan(100, 100, 32, mode3);
      texShader = loadShader("texfrag.glsl", "texvert.glsl");

      // initially set flags to false in order to load initial intro screen
      flag1 = false;
      flag2 = false;
      flag3 = false; 
      flag4 = false;
      flag5 = false;
      
      // no user interaction yet so flags false, controls certain action see references below in later code
      keyboardFlag = false;
      trainflag = false;
      openFile = false;
      openRef = false;
      deleteFlag= false;
      takePhoto = false;

      // if conflicts true, then any screen will load with click, but once false 
      // random clicks on screen will not load a previous screen
      conflict1 = true;
      conflict2 = true;
      conflict3 = true;
      
      // no buttons have been automatically pressed yet so false
      c1_ = false; 
      d_ = false; 
      e_ = false; 
      f_ = false; 
      g_ = false;
      a_ = false; 
      b_ = false; 
      c2_ = false;
      cs_ = false;
      ds_ = false; 
      fs_ = false; 
      gs_ = false; 
      as_ = false;   
      
      // flags used for composition mode in order to allow pushing into Stack 
      sc1 = false;
      sd = false;
      se = false;
      sf = false;
      sg = false;
      sa = false;
      sb = false;
      sc2 = false; 
      scs = false;
      sds = false;
      sfs = false;
      sgs = false;
      sas = false; 
      
      // controls Fur Elise being played on main screen, stops playing when we go to other screen
      soundControl1 = false; 
      soundControl2 = false;
      soundControl3 = false;
      soundControl4 = false;
      introScreenFlag = true;
}

void draw(){
  
   // these threee if statements track if any of our three modes have been clicked so far, and thus the flags will next be used to load background correspondingly
   if(mousePressed == true && mouseX>85 && mouseX<310 && mouseY>445 && mouseY<556 && conflict1 == true){
     
      flag1 = true;
      conflict2 = false;
      conflict3 = false;
   }
   if(mousePressed == true && mouseX>500 && mouseX<700 && mouseY>445 && mouseY<556 && conflict2 == true){
     
      flag2 = true;
      conflict1 = false;
      conflict3 = false;
   }
   if(mousePressed == true && mouseX>895 && mouseX<1120 && mouseY>445 && mouseY<556 && conflict3 == true){
     
      flag3 = true;
      conflict1 = false;
      conflict2 = false;
   }
  
  // our first mode option, training mode 
  if(flag1 == true ){
    
      bgSound.close(); // stopping background sound in intro  
      introScreenFlag = false;

      // initial text to greet user, and give directions
      background(50,205,50);
      fill(255);
      textSize(44);
      text("  :: TRAINING MODE :: ", 66,50);
      textSize(20);
      fill(0);
      text("Press ENTER to play random key, press the corresponding key on your keyboard after hearing the sound.", 10, 100);   
      text("~ Move the mouse to this black box to start ~", 10, 150);
      rect(350, 160, 40,40,6);
      fill(0,0,255);
      textSize(15);
      text("Click below to go back! ", 1000, 830);
      image(backPiano, 1030, 850, 120, 120);
      fill(255);
      textSize(18);
      text("If unopened, press X to open key guide", 800,20);
      
      // get the coordinates of our application window
      int x = frame.getLocationOnScreen().x; 
      int y = frame.getLocationOnScreen().y;
 
      // moves mouse to file on desktop to open a reference to the keyboard keys, used in each mode
      if(openRef == true){
          robot.mouseMove(x-25, y+550);
          robot.mousePress(InputEvent.BUTTON1_MASK);
          robot.mouseRelease(InputEvent.BUTTON1_MASK);
          robot.mousePress(InputEvent.BUTTON1_MASK);
          robot.mouseRelease(InputEvent.BUTTON1_MASK); 
          openRef =false;
       }

      // printing the current points value that we are at 
      fill(0,0,255);
      textSize(18);
      text("Current Correct Keys Points: ", 800, 230); 
      fill(50,205,50);
      strokeWeight(3);
      rect(1074, 203, 40,40,6);
      fill(0,0,255);
      text(increment, 1088, 230); 
      fill(0, 0, 255);
      textSize(18);
      text("[ HINT: Keep playing to earn bonus points! ]", 800, 295); 


      // this is our back button, and if pressed the flags are directed such to move us back to initial screen
      // see comments below in same reference but other modes for more clarity 
      if(mousePressed == true && mouseX>1030 && mouseX<1150 && mouseY>850 && mouseY<970){
          flag1 = false;
          flag2 = false;
          flag3 = false;
          conflict1 = true; 
          conflict2 = true;
          conflict3 = true;
          play = 0;
      }
     
      // creates standard piano for us
      createKeys();
      initialDisplay();
     
      // point ranges below in the if statements, if we hit a certain range a sound will play and we will get a badge (image)
      if(increment>=5){
          if(increment == 5){
              soundControl1 = true;
          }      
          image(badge1, 30, 250, 250, 120);
      }

      if(soundControl1 == true && increment == 5){
            badgeSong = minim.loadFile("bsound1.mp3");
            badgeSong.play(0);
            increment++;
      }
      
       if(increment>=8){
          if(increment == 8){
              soundControl2 = true;
          }      
          image(badge2, 88, 450, 250, 120);
      }

      if(soundControl2 == true && increment == 8){
            badgeSong = minim.loadFile("bsound2.mp3");
            badgeSong.play(0);
            increment++;
      }
      
      if(increment>=12){
          if(increment == 12){
              soundControl3 = true;
          }      
          image(badge3, 440, 430, 250, 120);
      }

      if(soundControl3 == true && increment == 12){
            badgeSong = minim.loadFile("bsound3.mp3");
            badgeSong.play(0);
            increment++;
      }
      
       if(increment>=15){
          if(increment == 15){
              soundControl4 = true;
          }      
          image(badge4, 500, 284, 250, 120);
      }

      if(soundControl4 == true && increment == 15){
            badgeSong = minim.loadFile("bsound4.mp3");
            badgeSong.play(0);
            increment++;
      }

      // once the mouse is in this area we can begin
      if (mouseX>350 && mouseX<390 && mouseY>160 && mouseY<200){
          trainflag = true;
      }
      
      // if ENTER is pressed and mouse is in area then lets start training!
      if(trainflag==true && keyboardFlag == true){
        
          // reset all keys such that none have been pressed yet      
          c1_ = false; 
          d_ = false; 
          e_ = false; 
          f_ = false; 
          g_ = false;
          a_ = false; 
          b_ = false; 
          c2_ = false;
          cs_ = false;
          ds_ = false; 
          fs_ = false; 
          gs_ = false; 
          as_ = false; 
          
          // choose a random index for random key
          int var = (int)random(0,12);
          
          // if less than 8 then we choose whiteKey
          if(var< 8){
            
              char thekey= whitekeys[var];
              println("KEY: " + thekey); // printing key in serial so that we can check later, and provides extra layer of checking training for user
              
              // each if statement checks if certain key, plays song, and sets the key flag to true
              // if flag is true and user presses key then they get a point
              if(thekey=='a'){
                  song = minim.loadFile("A.wav");
                  song.play(0);
                  a_ = true;
              }
              if(thekey=='b'){
                  song = minim.loadFile("B.wav");
                  song.play(0);
                  b_ = true;             
              }
              if(thekey=='c'){  
                  song = minim.loadFile("C.wav");
                  song.play(0);  
                  c1_ = true;                      
              }
              if(thekey=='d'){  
                  song = minim.loadFile("D.wav");
                  song.play(0);  
                  d_ = true;                      
              }
              if(thekey=='e'){  
                  song = minim.loadFile("E.wav");
                  song.play(0);  
                  e_ = true;                      
              }
              if(thekey=='f'){  
                  song = minim.loadFile("F.wav");
                  song.play(0);       
                  f_ = true;                     
              }
              if(thekey=='g'){
                  song = minim.loadFile("G.wav");
                  song.play(0);  
                  g_ = true;                      
              }
              if(thekey=='h'){  
                  song = minim.loadFile("CHi.wav");
                  song.play(0);  
                  c2_ = true;
              }          
          }
          else{ // otherwise we choose blackKeys
    
              char thekey= blackkeys[var-8];
              println("KEY: " +thekey);
              
              if(thekey=='C'){
                  song = minim.loadFile("C#.wav");
                  song.play(0);
                  cs_ = true;                           
              }
              if(thekey=='D'){ 
                  song = minim.loadFile("D#.wav");
                  song.play(0);
                  ds_ = true;                 
              }
              if(thekey=='F'){
                  song = minim.loadFile("F#.wav");
                  song.play(0);
                  fs_ = true;
              }
              if(thekey=='G'){                     
                  song = minim.loadFile("G#.wav");
                  song.play(0);
                  gs_ = true;           
              }
              if(thekey=='A'){
                  song = minim.loadFile("A#.wav");
                  song.play(0); 
                  as_ = true;              
              }
          }
          keyboardFlag = false; // need to press ENTER to load next key
    } // end if for random key choosing
  } // end if for training mode 
  
  // our second mode, composition
  else if(flag2 == true){
    
      // stopping background sound on intro screen
      bgSound.close(); 
      introScreenFlag = false;
  
      // initial user greeting/directions text 
      background(185, 122, 87);
      textSize(20);
      fill(300,265,220 );
      textSize(44);
      text("  :: FREESTYLE MODE :: ", 66,50);
      textSize(35);
      text("Play freely with keyboard presses or mouse clicks", 10, 125);   
      text("** Click on the Treble clef to the right to compose! **", 10, 247);
      image(composePic, 940, 180, 120, 120);
      textSize(15);
      fill(0,0,255);
      text("Click below to go back! ", 1000, 830);
      image(backPiano2, 1030, 850, 120, 120);
      fill(255);
      textSize(18);
      text("If unopened, press X to open key guide", 800,20);
      
      // loading piano and functionality
      createKeys();
      initialDisplay();
      clickSystem();
      
      // Composition mode
      if(mousePressed == true && mouseX>940 && mouseX<1060 && mouseY>180 && mouseY<300){
          flag4 = true;
      }
      if(flag4 == true){
        
          // set true such that keyPressed method below knows that we are in composition mode, thus any
          // key that we play that is on the piano will be pushed on to our composition stack 
          sc1 = true;
          sd = true;
          se = true;
          sf = true;
          sg = true;
          sa = true;
          sb = true;
          sc2 = true;
          scs = true;
          sds = true;
          sfs = true;
          sgs = true;
          sas = true;
          
          // greeting for composition mode
          background(255);
          fill(0);
          textSize(25);
          text("Welcome to composition mode, have fun!", 50, 50); 
          textSize(16);
          text("Press spacebar to save current piece in the program folder!", 50, 70); 
          fill(255,0,255);
          textSize(15);
          fill(0,0,255);
          text("Click below to go back! ", 1000, 830);
          image(backPiano2, 1030, 850, 120, 120);   
          fill(255);
          textSize(18);
          text("If unopened, press X to open key guide", 800,20);   
            
          // initial piano creation/display  
          createKeys();
          initialDisplay();
          clickSystem();
          
          // creates our music "sheet" with lines
          image(treble, 5, 150, 90, 160);   
          line(100,170,1080,170);
          line(100,200,1080,200);
          line(100,230,1080,230);
          line(100,260,1080,260);
          line(100,290,1080,290);
          
          // is our stack is not empty then we print the notes onto the sheet
          // using ellipses and noteheads created with lines by taking the elements off the stack
          if(st.isEmpty()==false){
              stack = st.getStack();
              
              // if the user presses delete or backspace, then we pop the last printed note and remove 
              // it from visualization and the stack
              if(deleteFlag == true){
                  st.pop();
                  deleteFlag = false;
              }
      
              // whatever the note is that the stack has will be crossreferenced with characters
              // and printed accordingly to its musical placement in Treble clef 
              // We also include sharps here if the note is a sharp key by adding a (#)
              for(int i=0; i<st.size(); i++){
                  if(stack[i] == "c1"){
                    ellipse(150+i*60, 320, 32,26);
                    line(120+i*60,320,180+i*60,320);
                    line(166+i*60, 320, 166+i*60, 220);
                  }
                  if(stack[i] == "d"){
                    ellipse(150+i*60, 305, 32,26);
                    line(166+i*60, 305, 166+i*60, 205);
                  }
                  if(stack[i] == "e"){
                    ellipse(150+i*60, 290, 32,26);
                    line(166+i*60, 290, 166+i*60, 190);
                  }
                  if(stack[i] == "f"){
                    ellipse(150+i*60, 275, 32,26);
                    line(166+i*60, 275, 166+i*60, 175);
                  }
                  if(stack[i] == "g"){
                    ellipse(150+i*60, 260, 32,26);
                    line(166+i*60, 260, 166+i*60, 160);
                  }
                  if(stack[i] == "a"){
                    ellipse(150+i*60, 245, 32,26);
                    line(166+i*60, 245, 166+i*60, 145);
                  }
                  if(stack[i] == "b"){
                    ellipse(150+i*60, 230, 32,26);
                    line(166+i*60, 230, 166+i*60, 130);
                  }
                  if(stack[i] == "c2"){
                    ellipse(150+i*60, 215, 32,26);
                    line(134+i*60, 215, 134+i*60, 315);
                  }
                  if(stack[i] == "cs"){
                    ellipse(150+i*60, 320, 32,26);
                    line(120+i*60,320,180+i*60,320);
                    line(166+i*60, 320, 166+i*60, 220);
                    textSize(26);
                    text("#",110+i*60,320);
                  }
                  if(stack[i] == "ds"){
                    ellipse(150+i*60, 305, 32,26);
                    line(166+i*60, 305, 166+i*60, 205);
                    textSize(26);
                    text("#",110+i*60,300);
                  }
                  if(stack[i] == "fs"){
                    ellipse(150+i*60, 275, 32,26);
                    line(166+i*60, 275, 166+i*60, 175);
                    textSize(26);
                    text("#",110+i*60,275);
                  }
                  if(stack[i] == "gs"){
                    ellipse(150+i*60, 260, 32,26);
                    line(166+i*60, 260, 166+i*60, 160);
                    textSize(26);
                    text("#",110+i*60,260);
                  }
                  if(stack[i] == "as"){
                    ellipse(150+i*60, 245, 32,26);
                    line(166+i*60, 245, 166+i*60, 145);
                    textSize(26);
                    text("#",110+i*60,240);
                  }
              }   
         
             // if user pressed spacebar, we take a screenshot of the window and save the file in the project folder 
             if(takePhoto == true){
                saveFrame("composition-##.jpg");
                takePhoto = false;
              }     
          }
      }     
      
       // get the coordinates of our application window
        int x = frame.getLocationOnScreen().x;
        int y = frame.getLocationOnScreen().y;
        
        if(openRef == true){
            robot.mouseMove(x-25, y+550);
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK); 
            openRef =false;
         }
      
      // back button
      if(mousePressed == true && mouseX>1030 && mouseX<1150 && mouseY>850 && mouseY<970){
          flag1 = false; // mode 1 is not open any more
          flag2 = false; // mode 2 is not open any more
          flag3 = false; // mode 3 is not open any more
          
          // only one mode at a time
          conflict1 = true; 
          conflict2 = true;
          conflict3 = true;
          play = 0; // 
      }
  }
  
  // our third mode, example mode
  else if (flag3 == true ){
            
    //stop background sound from intro
    bgSound.close(); 
    introScreenFlag = false;
     
    // initial greeting text for user
    background(200,20,255);
    fill(300,265,220 );
    textSize(44);
    text("  :: EXAMPLE MODE :: ", 66,50);
    textSize(32);
    text(" Press ENTER, step away from computer, and follow mouse to learn", 78,145);
    textSize(30);
    fill(0);
    text(" TWINKLE TWINKLE LITTLE STAR", 370,255);
    fill(255,0,255);
    textSize(15);
    fill(0,0,255);
    text("Click below to go back! ", 1000, 830);
    image(backPiano3, 1030, 850, 120, 120);   
    
    // initial load of piano
    createKeys();
    initialDisplay();
    clickSystem();

    // get the coordinates of our application window
    int x = frame.getLocationOnScreen().x;
    int y = frame.getLocationOnScreen().y;
    
    fill(255);
    textSize(18);
    text("Press Z on Keyboard to open a reference ", 805, 45); 
    fill(255);
    textSize(18);
    text("If unopened, press X to open key guide", 800,20);
    
    // automatically opens twinkle twinkle image from desktop, 
    // NOTE: must be next to upper left corner of application window to work automatically 
    if(openFile == true){
        robot.mouseMove(x-25, y+20);
        robot.mousePress(InputEvent.BUTTON1_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
        robot.mousePress(InputEvent.BUTTON1_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_MASK); 
        openFile =false;
    }
    
   // if ENTER is pressed, then play twinkle twinkle little star
   if(keyboardFlag == true){
        openFile = false; // twinkle twinkle reference on desktop should not be opened yet
        clickSystem();

       // plays song, moves mouse on screen automatically to key that should be pressed to learn example
        song = minim.loadFile("C.wav"); 
        robot.mouseMove(x+312, y+900); // mouse move relative to our application window
        song.play(0);
        delay(1000); // stop a bit between each note
        
        song = minim.loadFile("C.wav");
        robot.mouseMove(x+312, y+935);  
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("G.wav");
        robot.mouseMove(x+638,y+900); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("G.wav");   
        robot.mouseMove(x+638,y+935);
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("A.wav");
        robot.mouseMove(x+721,y+900);
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("A.wav");
        robot.mouseMove(x+721,y+935);
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("G.wav");
        robot.mouseMove(x+638,y+900); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("F.wav");
        robot.mouseMove(x+555,y+900); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("F.wav");
        robot.mouseMove(x+555,y+935); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("E.wav");
        robot.mouseMove(x+479,y+900); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("E.wav");
        robot.mouseMove(x+479,y+935); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("D.wav");
        robot.mouseMove(x+397,y+900); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("D.wav");
        robot.mouseMove(x+397,y+935); 
        song.play(0);
        delay(1000);
        
        song = minim.loadFile("C.wav");
        robot.mouseMove(x+310,y+900); 
        song.play(0);
        delay(1000);
        
        keyboardFlag = false;// wait for next ENTER press
    }
    
    // opens keyboard reference from desktop,
    // NOTE: file must be about halfway of the window height and right next to left edge of window
    if(openRef == true){  
          robot.mouseMove(x-25, y+550);
          robot.mousePress(InputEvent.BUTTON1_MASK);
          robot.mouseRelease(InputEvent.BUTTON1_MASK);
          robot.mousePress(InputEvent.BUTTON1_MASK);
          robot.mouseRelease(InputEvent.BUTTON1_MASK); 
          openRef =false;
    }
    
    // back button to main screen
    if(mousePressed == true && mouseX>1030 && mouseX<1150 && mouseY>850 && mouseY<970){
        flag1 = false;
        flag2 = false;
        flag3 = false;
        conflict1 = true; 
        conflict2 = true;
        conflict3 = true;
        play = 0;
    }
  }
  
  // if in no other mode, then we should be at this main screen
  else{
        // this flag tells us that we are in the intro screen
        introScreenFlag = true;
        
        background(bg); // image background
        
        // greeting text
        textSize(80);
        fill(255);
        text("Piano Master ", 370, 135); 
        fill(300,265,220 );
        textSize(44);
        text("  Master the fundamentals of piano playing by: ", 68,200);
        textSize(34);
        text(" - training your ear to identify pitches", 168,250);
        text(" - composing your own musical piece", 168,320);
        text(" - learning how to play Twinkle Twinkle Little Star", 168,390);
        fill(249,241,220 );
        textSize(32);
        text("Click a Mode Above", 420, 720); 
        textSize(25);
        text("By: Mohammad Khan & Yifan Lu", 680, 960); 
       
        // creates each cylinder below and assigns wallpaper to each respectively
        pushMatrix();
        shader(texShader);  
        translate(200, 500);
        rotateY(-angle);  
        shape(can);  
        popMatrix();
        
        pushMatrix();
        shader(texShader);  
        translate(600, 500);
        rotateY(-angle);  
        shape(can2); 
        popMatrix();
        
        pushMatrix();
        shader(texShader);  
        translate(1000, 500);
        rotateY(-angle);  
        shape(can3); 
        popMatrix();
        
        angle += 0.05; // rotates our cylinders
        
        // only plays song once, on first iteration!
        if(play == 0){
            bgSound = minim.loadFile("FurElise.mp3");
            bgSound.play();
          }
        play++; 
        
       }
       
       // helped for debugging purposes
       //print(mouseX + ", ");
       //println(mouseY);
}

// makes our key objects using the two classes 
void createKeys(){
  
     c1 = new WhiteKey(displacement,565, 80, 410, 9);
     d = new WhiteKey(displacement+80*1,565, 80, 410, 9);
     e = new WhiteKey(displacement+80*2,565, 80, 410, 9);
     f = new WhiteKey(displacement+80*3,565, 80, 410, 9);
     g = new WhiteKey(displacement+80*4,565, 80, 410, 9);
     a = new WhiteKey(displacement+80*5,565, 80, 410, 9);
     b = new WhiteKey(displacement+80*6,565, 80, 410, 9);
     c2 = new WhiteKey(displacement+80*7,565, 80, 410, 9);
     
     cs = new BlackKey(displacement+47, 565, 50, 273,9);
     ds = new BlackKey(displacement+62+80*1, 565, 50, 273,9);
     fs = new BlackKey(displacement+47+80*3, 565, 50, 273,9);
     gs = new BlackKey(displacement+53+80*4, 565, 50, 273,9);
     as = new BlackKey(displacement+62+80*5, 565, 50, 273,9);
}

// displays each key object to screen, white and black
void initialDisplay(){
  
     fill(255);
     c1.display();
     d.display();
     e.display();
     f.display();
     g.display();
     a.display();
     b.display();
     c2.display();
    
     fill(0);
     cs.display();
     ds.display();
     fs.display();
     gs.display();
     as.display();
}

// click system allows us to check if a key is pressed or clicked to play sound and display interaction change (color)
// also allows us to keep track if user is getting points in training mode
void clickSystem(){
    
      // display method allows us to show key click without overlapping with other keys
      if(c1.isClicked() == true || c1.pressed == true){
          c1.changeColor();
          fill(0);
          cs.display();
          song = minim.loadFile("C.wav");
          song.play();
          
          // if the right key is played we increment and get a point!
          if(c1_ == true){
              increment++;
          }
          
          // if in composition mode, push this note onto stack so we can print it!
          if(sc1 == true && st.size()<16){
            st.push("c1");
          }
      }
      if(d.isClicked() == true || d.pressed == true){
          d.changeColor();
          fill(0);
          cs.display();
          ds.display();
          song = minim.loadFile("D.wav");
          song.play();
          if (d_ == true){
            increment++;
          }
          if(sd == true && st.size()<16){
            st.push("d");
          }
      }
      if(e.isClicked() == true || e.pressed == true){
          e.changeColor();
          fill(0);
          ds.display();
          song = minim.loadFile("E.wav");
          song.play();
          if(e_ == true){
            increment++;
          }
          if(se == true && st.size()<16){
            st.push("e");
          }
      }
      if(f.isClicked() == true || f.pressed == true){
          f.changeColor();
          fill(0);
          fs.display();
          song = minim.loadFile("F.wav");
          song.play();
          if( f_ == true){
            increment++;
          }
          if(sf == true && st.size()<16){
            st.push("f");
          }
      }
      if(g.isClicked() == true || g.pressed == true){
          g.changeColor();
          fill(0);
          fs.display();
          gs.display();
          song = minim.loadFile("G.wav");
          song.play();
          if( g_ == true){
            increment++;
          }
          if(sg == true && st.size()<16){
            st.push("g");
          }
      }
      if(a.isClicked() == true || a.pressed == true){
          a.changeColor();
          fill(0);
          gs.display();
          as.display();
          song = minim.loadFile("A.wav");
          song.play();
          if(a_ == true){
            increment++;
          }
          if(sa == true && st.size()<16){
            st.push("a");
          }
      }
      if(b.isClicked() == true || b.pressed == true){
          b.changeColor();
          fill(0);
          as.display();
          song = minim.loadFile("B.wav");
          song.play();
          if(b_ == true){
            increment++;
          }
          if(sb == true && st.size()<16){
            st.push("b");
          }
      }
      if(c2.isClicked2() == true || c2.pressed == true){
          c2.changeColor();
          song = minim.loadFile("CHi.wav");
          song.play();
          if(c2_ == true){
            increment++;
          }
          if(sc2 == true && st.size()<16){
            st.push("c2");
          }
      }
      
      if(cs.isClicked() == true || cs.pressed == true){ 
          cs.changeColor();
          song = minim.loadFile("C#.wav");
          song.play();
          
          if( cs_ == true){
            increment++;
          }
          if(scs == true && st.size()<16){
            st.push("cs");
          }
      }
      if(ds.isClicked() == true || ds.pressed == true){
          ds.changeColor();
          song = minim.loadFile("D#.wav");
          song.play();
          if(ds_ == true){
            increment++;
          }
          if(sds == true && st.size()<16){
            st.push("ds");
          }
      }
      if(fs.isClicked() == true || fs.pressed == true){
          fs.changeColor();
          song = minim.loadFile("F#.wav");
          song.play();
          if(fs_ == true){
            increment++;
          }
          if(sfs == true && st.size()<16){
            st.push("fs");
          }
      } 
      if(gs.isClicked() == true || gs.pressed == true){
          gs.changeColor();
          song = minim.loadFile("G#.wav");
          song.play();
          if(gs_ == true){
            increment++;
          }
          if(sgs == true && st.size()<16){
            st.push("gs");
          }
      }
      if(as.isClicked() == true || as.pressed == true){
          as.changeColor();
          song = minim.loadFile("A#.wav");
          song.play() ;
          if(as_ == true){
            increment++;
          }
          if(sas == true && st.size()<16){
            st.push("as");
          }
      }
}

// this tracks if any keyboard interaction takes place, also registers booleans to be used in clickSystem call
void keyPressed() {
  
  if(introScreenFlag == false){
      if (key == 'a') {
          c1.pressed = true;
      } 
      if (key == 's') {
          d.pressed = true;
      } 
      if (key == 'd') {
          e.pressed = true;
      } 
      if (key == 'f') {
          f.pressed = true;
      } 
      if (key == 'g') {
         g.pressed = true;
      }
      if (key == 'h') {
         a.pressed = true;
      }
      if (key == 'j') {
         b.pressed = true;
      }
      if (key == 'k') {
         c2.pressed = true;
      }
      if (key == 'w') {
          cs.pressed = true;
      } 
      if (key == 'e') {
         ds.pressed = true;
      }
      if (key == 'y') {
         fs.pressed = true;
      }
      if (key == 'u') {
         gs.pressed = true;
      }
      if (key == 'i') {
         as.pressed = true;
      }
      if(key== ENTER){
        keyboardFlag=true;
      }
      if(key== 'z'){
        openFile=true;
      }
       if(key== 'x'){
        openRef=true;
      }
      if( key == BACKSPACE){
         deleteFlag = true;
      }
      if( key == ' '){
          takePhoto = true;
      }
     clickSystem(); 
  }
}

// can render, obtained from shader Processing tutorials
PShape createCan(float r, float h, int detail, PImage tex) {
      textureMode(NORMAL);
      textureWrap(REPEAT); 
      PShape sh = createShape();
      sh.beginShape(QUAD_STRIP);
      sh.noStroke();
      sh.texture(tex);
      for (int i = 0; i <= detail; i++) {
          float angle = TWO_PI / detail;
          float x = sin(i * angle);
          float z = cos(i * angle);
          float u = float(i) / detail;
          sh.normal(x, 0, z);
          sh.vertex(x * r, -h/2, z * r, u, 0);
          sh.vertex(x * r, +h/2, z * r, u, 1);    
      }
      sh.endShape(); 
      return sh;
}

