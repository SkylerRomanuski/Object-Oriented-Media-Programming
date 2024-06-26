/************************************************************
/* Authors: Dr. Parson & Skyler Romanuski
/* Creation Date: 10/16/2023
/* Due: via D2L Assignment 3 at ???.
/* Course: CSC220 Object-Oriented Multimedia Programming
/* Professor Name: Dr. Parson
/* Assignment: 3.
/* Sketch name: CSC220F23Assn3_MIDI 
/*    (derived from CSC220F23Assn3_MIDI and CSC220F22Assn2_3D).
/*    CSC220F20Assn2_3D makes all Avatar-derived classes 3D.
/*    Assigment 2 in a new world with MIDI sound and lawn cutting..
/*    SUMMARY OF STUDENT REQUIREMENTS ARE IN THE STUDENT TAB.
/*    Save a working copy of this sketch as CSC220F23Assn3_MIDI WITH YOUR NAME at the top.
/*
 *********************************************************/
 
/*  KEYBOARD COMMANDS:
/*  'b' toggles display of bounding boxes for debugging, initially on
/*  'f' toggles freezing of display in draw() off / on.
/*  'v' toggles isImmobile to inhibit/enable calls to Avatar.move();
/*  'm' toggles issmear mode for no-erase painting.
/*  '~' applies shuffle() to each Avatar object, repositioning the mobile ones.
/*  '!' applies forceshuffle() to each Avatar object, repositioning all of them.
/*  'p' sets perspective projection; 'o' sets orthographic
 *  'u' when held down moves camera up in Z direction slowly
 *  'U' when held down moves camera up in Z direction quickly
 *  'd' when held down moves camera down in Z direction slowly
 *  'D' when held down moves camera down in Z direction quickly
 *  'n' when held down moves camera up in Y direction slowly
 *  'N' when held down moves camera up in Y direction quickly
 *  's' when held down moves camera down in Y direction slowly
 *  'S' when held down moves camera down in Y direction quickly
 *  'e' when held down moves camera right in X direction slowly
 *  'E' when held down moves camera right in X direction quickly
 *  'w' when held down moves camera left in X direction slowly
 *  'W' when held down moves camera left in X direction quickly
 *  'x' when held down rotates image positive degrees around x
 *  'X' when held down rotates image negative degrees around x
 *  'y' when held down rotates image positive degrees around y
 *  'Y' when held down rotates image negative degrees around y
 *  'z' when held down rotates image positive degrees around z
 *  'Z' when held down rotates image negative degrees around z
 *  'R' resets to original camera point of view
 *  SPACE BAR held down moves camera x,y to mouseX*2-width, mouseY*2-height
*/

import java.util.Set ;
import java.util.HashSet ;
// GLOBALS ADDED FOR 3D FURNITURE:
int minimumZ, maximumZ ; // initialized in setup.

// Assignment 1 GLOBAL VARIABLES are for the collection of Avatar objects.
// All Avatar state variables go inside of Avatar-derived subclasses.
Avatar avatars [] ;   // An array holding multiple Avatar objects.
int backgroundColor = color(0,255,255) ;  // cyan sky.
boolean showBoundingBox = true ;  // toggle with 'b' key
boolean isFrozen = false ; // toggle with 'f' key to freeze display
boolean isImmobile = false ; // toggle with 'f' key to freeze display

// Variables for camera manipulation:
float xeye, yeye, zeye ;    // locations of the camera's eye in 3D space
// Next 3 variables rotate the world from the camera's point of view.
float worldxrotate = 0.0, worldyrotate = 0.0, worldzrotate = 0.0 ;
// Some basic symbolic constants.
final float degree = radians(1.0), around = radians(360.0);
boolean isortho = false ;  // 'o' sets to true, 'p' to false for perspective
boolean issmear = false ;  // true when painting, 'm' toggles this
PShape customPShapeParson = null ;
PImage customPImageParson = null ;  // Leave this at null if you don't texture.
PImage globePImage = null ;
PShape globePShape = null ;

void setup() {
  // setup() runs once when the sketch starts, initializes sketch state.
  size(1500, 1100, P3D);  // STUDENT may change size or use fullScreen(P3D).
  // fullScreen(P3D);
  frameRate(60);  // default 60, newer Macs need this after size()
  background(backgroundColor);
  maximumZ = height / 2 ;  // front of the scene
  minimumZ = - height / 2 ;  // back of the scene
  customPImageParson = loadImage("TriTexture.jpg"); // load before makecustomPShapeParsonParson(), USE YOUR OWN
  customPShapeParson = makecustomPShapeParsonParson(customPImageParson);
  avatars = new Avatar [ 1 ] ;  // reduced from 50 to reduce CPU load
  avatars[0] = new MyCat(width/4, height/4, 0, 2, 1, 1, 1);
  // See constructors in their classes below to interpret parameters.
  //int cyan = color(0, 255, 255, 255);  // Red, Green, Blue, Alpha
  // By positioning based on system variables *width* and *height*, as opposed to
  // using fixed location numbers, your sketch will work with any display size.
  // NOTE THE CONSTRUCTORS NOW TAKE A Z COORDINATE, AND Z SPEED IN SOME CASES.
  //avatars[1] = new MyCat(3*width/4, 3*height/4, 0, 2, 1, 1, 1);
  //avatars[1] = new VectorAvatar(int(random(0,width)), int(random(0,height)), 0, 3, 4, round(random(2,5)), 0.5);
  //avatars[3] = null ;  
  //for (int i = 4 ; i < avatars.length/2-2 ; i++) {
  //  int zspeed = round(random(-5,5));
  //  if (zspeed == 0) { zspeed = 1 ; }
  //  avatars[i] = new Professor(int(random(0,width)), int(random(0, height)),
  //    int(random(minimumZ, maximumZ))/2,
  //    round(random(1,5)), round(random(-5,-1)), zspeed, .75);
  //}
  //for (int i = avatars.length/2-2 ; i < avatars.length ; i++) {
  //  // STUDENT 1 construct your avatars in this loop.
  //  int zspeed = round(random(-5,5));
  //  if (zspeed == 0) { zspeed = 1 ; }
  //  avatars[i] = new MyCat(int(random(0,width)), int(random(0, height)),
  //    int(random(minimumZ, maximumZ))/2,
  //    round(random(1,5)), round(random(-5,-1)), zspeed, .75);
  //}
  rectMode(CENTER);  // I make them CENTER by default. rectMode is otherwise CORNER.
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);
  // Added 9/15/2018, put the camera above the middle of the scene:
  xeye = width / 2 ;
  yeye = height / 2 ;
  zeye = (height*2) /* / tan(PI*30.0 / 180.0) */ ;
}

void draw() {
  if (globePShape == null) {
    makeglobePShape();
    initMIDI();
  }
  // draw() is run once every frameRate, every 60th of a sec by default.
  if (isFrozen) {
    return ;
  }
  if (isortho) {
    ortho();
  } else {
    perspective();
  }
  if (! issmear) {
    background(backgroundColor);  // This erases the previous frame.
  }
  // END EXPERIMENTAL */
  rectMode(CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);
  moveCameraRotateWorldKeys(); // CAMERA ADDITION 9/15/2018, holding key repeats its action
  // Display & move all avatars in a for loop.
  for (int i = 0 ; i < avatars.length ; i++) {
    if (avatars[i] == null) {  // not yet constructed
      continue ; // resume at next i in this loop
    }
    // Reinitialze these modes in case an Avatar changed them.
    rectMode(CENTER);
    ellipseMode(CENTER);
    imageMode(CENTER);
    shapeMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(0);
    noFill();
    strokeWeight(1);
    if (! isImmobile) {
      avatars[i].move();  // Move before display so the bounding boxes are correct.
    }
    if (avatars[i] != null) {  // move may mow it down
      avatars[i].display();
    }
  }
  if (showBoundingBox) {
    // Do this in a separate loop so we can do the initial part once.
    rectMode(CORNER);
    noFill();
    stroke(255,0,0);
    strokeWeight(1);
    /* THIS WAS THE 2D CODE
    for (Avatar avt : avatars) {
      // For testing bounding box
      int [] bb = avt.getBoundingBox();
      rect(bb[0], bb[1], bb[2]-bb[0], bb[3] - bb[1]);
    }
    */
    for (Avatar avt : avatars) {
      if (avt == null) {
        continue ; // spot in array not populated
      }
      // For testing bounding box
      int [] bb = avt.getBoundingBox();
      line(bb[0], bb[1], bb[2], bb[3], bb[1], bb[2]); // across back top
      line(bb[0], bb[4], bb[2], bb[3], bb[4], bb[2]); // across back bottom
      line(bb[0], bb[1], bb[5], bb[3], bb[1], bb[5]); // across front top
      line(bb[0], bb[4], bb[5], bb[3], bb[4], bb[5]); // across front bottom
      line(bb[0], bb[1], bb[2], bb[0], bb[4], bb[2]); // down back left
      line(bb[3], bb[1], bb[2], bb[3], bb[4], bb[2]); // down back right
      line(bb[0], bb[1], bb[5], bb[0], bb[4], bb[5]); // down front left
      line(bb[3], bb[1], bb[5], bb[3], bb[4], bb[5]); // down front right
      line(bb[0], bb[1], bb[2], bb[0], bb[1], bb[5]); // into top left
      line(bb[3], bb[1], bb[2], bb[3], bb[1], bb[5]); // into top right
      line(bb[0], bb[4], bb[2], bb[0], bb[4], bb[5]); // into bottom left
      line(bb[3], bb[4], bb[2], bb[3], bb[4], bb[5]); // into bottom right
    }
  }
  rectMode(CENTER);  // back to defaults
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);
}

//  KEYBOARD COMMANDS documented at top of this sketch.
// System calls keyPressed when user presses a *key*.
// Examples of control characters like arrows in a later example.
void keyPressed() {
  if (key == 'b') {
    // toggle bounding boxes on/off
    showBoundingBox = ! showBoundingBox ;
  } else if (key == 'f') {
    isFrozen = ! isFrozen ;
  } else if (key == 'v') {
    isImmobile = ! isImmobile ;
  } else if (key == '~') {
    for (int i = 0 ; i < avatars.length ; i++) {
      if (avatars[i] != null) {
        avatars[i].shuffle();
      }
    }
  } else if (key == '!') {
    for (Avatar a : avatars) {
      if (a != null) {
        a.forceshuffle();
      }
    }
  } else if (key == 'R') { // Reset POV to starting point.
    xeye = width / 2 ;
    yeye = height / 2 ;
    zeye = (height*2) /* / tan(PI*30.0 / 180.0) */ ;
    worldxrotate = worldyrotate = worldzrotate = 0.0 ;
  } else if (key == 'o') {
    isortho = true ;
  } else if (key == 'p') {
    isortho = false ;
  } else if (key == 'm') {
    issmear = ! issmear ;
  }
}

/** 3D overlap checks whether two objects' bounding boxes overlap
**/
boolean overlap(Avatar avatar1, Avatar avatar2) {
  int [] bb1 = avatar1.getBoundingBox();
  int [] bb2 = avatar2.getBoundingBox();
  // If bb1 is completely above, below,
  // left or right of bb2, we have an easy reject.
  if (bb1[0] > bb2[3]      // bb1_left is right of bb2_right
  || bb1[1] > bb2[4]   // bb1_top is below bb2_bottom
  || bb1[2] > bb2[5]  // bb1_back is front of bb2_front
  || bb2[0] > bb1[3]   // bb2_left is right of bb1_right
  || bb2[1] > bb1[4]   // bb2_top is below bb1_bottom
  || bb2[2] > bb1[5]  // bb2_back is front of bb1_front
  ) {
    return false ;
  }
  // In this case one contains the other or they overlap.
  return true ;
}

/** Return 1 for non-negative num, -1 for negative. **/
int signum(float num) {
  return ((num >= 0) ? 1 : -1);
}

// Added 9/15/2018 to move camera and rotate world when these keys are held down.
void moveCameraRotateWorldKeys() {
  if (keyPressed) {
    if (key == 'u') {
      zeye += 10 ;
      // println("DEBUG u " + zeye + ", minZ: " + minimumZ + ", maxZ: " + maximumZ);
    } else if (key == 'U') {
      zeye += 100 ;
      // println("DEBUG U " + zeye + ", minZ: " + minimumZ + ", maxZ: " + maximumZ);
    } else if (key == 'd') {
      zeye -= 10 ;
      // println("DEBUG d " + zeye + ", minZ: " + minimumZ + ", maxZ: " + maximumZ);
    } else if (key == 'D') {
      zeye -= 100 ;
      // println("DEBUG D " + zeye + ", minZ: " + minimumZ + ", maxZ: " + maximumZ);
    } else if (key == 'n') {
      yeye -= 1 ;
    } else if (key == 'N') {
      yeye -= 10 ;
    } else if (key == 's') {
      yeye += 1 ;
    } else if (key == 'S') {
      yeye += 10 ;
    } else if (key == 'w') {
      xeye -= 1 ;
    } else if (key == 'W') {
      xeye -= 10 ;
    } else if (key == 'e') {
      xeye += 1 ;
    } else if (key == 'E') {
      xeye += 10 ;
    } else if (key == 'x') {
      worldxrotate += degree ;
      if (worldxrotate >= around) {
        worldxrotate = 0 ;
      }
    } else if (key == 'X') {
      worldxrotate -= degree ;
      if (worldxrotate < -around) {
        worldxrotate = 0 ;
      }
    } else if (key == 'y') {
      worldyrotate += degree ;
      if (worldyrotate >= around) {
        worldyrotate = 0 ;
      }
    } else if (key == 'Y') {
      worldyrotate -= degree ;
      if (worldyrotate < -around) {
        worldyrotate = 0 ;
      }
    } else if (key == 'z') {
      worldzrotate += degree ;
      if (worldzrotate >= around) {
        worldzrotate = 0 ;
      }
    } else if (key == 'Z') {
      worldzrotate -= degree ;
      if (worldzrotate < -around) {
        worldzrotate = 0 ;
      }
    } else if (mousePressed && key == ' ') {
      xeye = mouseX ;
      yeye = mouseY ;
    }
  }
  // Make sure 6th parameter -- focus in the Z direction -- is far, far away
  // towards the horizon. Otherwise, ortho() does not work.
  camera(xeye, yeye,  zeye, xeye, yeye,  zeye-signum(zeye-minimumZ)*maximumZ*2 , 0,1,0);
  if (worldxrotate != 0 || worldyrotate != 0 || worldzrotate != 0) {
    translate(width/2, height/2, 0);  // rotate from the middle of the world
    if (worldxrotate != 0) {
      rotateX(worldxrotate);
    }
    if (worldyrotate != 0) {
      rotateY(worldyrotate);
    }
    if (worldzrotate != 0) {
      rotateZ(worldzrotate);
    }
    translate(-width/2, -height/2, 0); // Apply the inverse of the above translate.
    // Do not use pushMatrix()-popMatrix() instead of the inverse translate,
    // because popMatrix() would discard the rotations.
  }
}
