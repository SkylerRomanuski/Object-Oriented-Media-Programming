/************************************************************
/* Authors: Dr. Parson & Skyler Romanuski
/*          Modified by Dr. Schwesinger spring 2024
/* Course: CSC220 Object-Oriented Multimedia Programming
/* Assignment: 1.
/* Sketch name: csc220_project1
/*    moved classes into different files
/*    New avatar class is called "Batman"
/*    changed the furniture class to change the rectangle into and ellipse
/*    created Paddle2 class which is a second paddle the moves in the opposite direction
/*    This 2D sketch puts the mobile avatar in a mostly-immobile
/*    2D room, where each wall or piece of furniture is a 2D avatar,
/*    and at least one furniture surface moves. It illustrates
/*    the use of a Java interface, inheritance, an abstract base class
/*    containing helper functions & fields, and also simple collision
/*    detection using bounding boxes. Initial draft September 12, 2018.
 *********************************************************/
 
/*  KEYBOARD COMMANDS:
/*  'b' toggles display of bounding boxes for debugging, initially on
/*  'f' toggles freezing of display in draw() off / on.
/*  '~' applies shuffle() to each Avatar object, repositioning the mobile ones.
/*  '!' applies forceshuffle() to each Avatar object, repositioning all of them.
*/

// The only GLOBAL VARIABLES are for the collection of Avatar objects.
// All Avatar state variables go inside of Avatar-derived subclasses.
Avatar avatars [] ;   // An array holding multiple Avatar objects.
int backgroundColor = 255 ;  // White on gray scale.
boolean showBoundingBox = true ;  // toggle with 'b' key
boolean isFrozen = false ; // toggle with 'f' key to freeze display

void setup() {
  // setup() runs once when the sketch starts, initializes sketch state.
  size(1500, 800); // YOU may change size.
  // fullScreen();  // P2D uses the grahics cards for some of the calculations, blocks Zoom
  frameRate(60);  // needs to be set here for newer Macs
  background(backgroundColor);
  avatars = new Avatar [ 30 ] ;
  avatars[0] = new Professor(width/4, height/4, 2, 3, 2, 0, 0, 0.5); //big professor
  // See constructors in their classes below to interpret parameters.
  //color red = color(255, 0, 0);  // Red, Green, Blue, Alpha
  // By positioning based on system variables *width* and *height*, as opposed
  // to using fixed location numbers, your sketch will work with any display
  // size.
  color grey = color(150, 150, 150);
  color darkGrey = color (100, 100, 100);
  color black = color(0, 0, 0);
  color yellow = color(255, 244, 21);
  //avatars[1] = new Furniture(width/2,height/2, 100, 150, cyan);
  avatars[1] = new Furniture(width/2, 5, width*2, 10, darkGrey);  // 10 pixels wide boundary is impenetrable
  avatars[2] = new Furniture(width/2, height-5, width*2, 10, darkGrey);
  avatars[3] = new Furniture(5, height/2, 10, height*2, darkGrey);
  avatars[4] = new Furniture(width-5, height/2, 10, height*2, darkGrey);
  avatars[5] = new Furniture(1300, 150, 200, 200, grey);   // i made da moon bc it's gotham 
  avatars[6] = new Furniture(1350, 115, 45, 45, darkGrey); // i made da moon bc it's gotham 
  avatars[7] = new Furniture(1250, 145, 45, 45, darkGrey); // i made da moon bc it's gotham 
  avatars[8] = new Furniture(1300, 200, 45, 45, darkGrey); // i made da moon bc it's gotham 
  avatars[9] = new Furniture(300, 650, 25, 300, yellow); //post at the bottem left
  avatars[12] = new Professor(3*width/4, 3*height/4, 2, 1, 1, 0, 0, 0); //medium professor
  //int magenta = color(255, 0, 255, 255);
  final int barlength = 200 ;
  //avatars[6] = new Furniture(barlength/2, height/2, barlength, 10, magenta);  // 10 pixels wide boundary is impenetrable
  //avatars[7] = new Furniture(width-barlength/2, 2*height/3, barlength, 10, magenta);
  //avatars[8] = new Furniture(width/3, barlength/2, 10, barlength, magenta);
  //avatars[9] = new Furniture(width/3, height-barlength/2, 10, barlength, magenta);
  //color orange = color(255,184,0,255);
  avatars[10] = new Paddle(width-150, height-150, barlength, 100, .25, black); //paddle in the bottem right
  avatars[11] = new Paddle2(width/4, height/4, barlength, 50, 50, black); //paddle in the top right
  for (int i = 12 ; i < avatars.length ; i++) { //small professors
   avatars[i] = new Professor(int(random(0,width)), int(random(0, height)),
      round(random(1,5)), round(random(-5,-1)), .25, 0, 0, 10);
  }
  rectMode(CENTER);  // I make them CENTER by default. rectMode is otherwise CORNER.
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  if (isFrozen) {
    return ; // toggle 'f' key to freeze/unfreeze display.
  }
  // draw() is run once every frameRate, every 60th of a sec by default.
  background(backgroundColor);  // This erases the previous frame.
  rectMode(CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);
  // Display & move all avatars in a for loop.
  for (int i = 0 ; i < avatars.length ; i++) {
    // Reinitialize these modes in case an Avatar changed them.
    rectMode(CENTER);
    ellipseMode(CENTER);
    imageMode(CENTER);
    shapeMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(0);
    noFill();
    strokeWeight(1);
    avatars[i].move();  // Move before display so the bounding boxes are correct.
    avatars[i].display();
  }
  if (showBoundingBox) {
    // Do this in a separate loop so we can do the initial part once.
    // Putting it here for debugging avoids having to do it in the Avatar.display()s.
    rectMode(CORNER);
    noFill();
    stroke(0);
    strokeWeight(1);
    for (Avatar avt : avatars) {
      // For testing bounding box
      int [] bb = avt.getBoundingBox();
      rect(bb[0], bb[1], bb[2]-bb[0], bb[3] - bb[1]);
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
  } else if (key == '~') {
    for (int i = 0 ; i < avatars.length ; i++) {
      avatars[i].shuffle();
    }
  } else if (key == '!') {
    for (Avatar a : avatars) {
      a.forceshuffle();
    }
  }
}

/** overlap checks whether two objects' bounding boxes overlap
**/
boolean overlap(Avatar avatar1, Avatar avatar2) {
  int [] bb1 = avatar1.getBoundingBox();
  int [] bb2 = avatar2.getBoundingBox();
  // If bb1 is completely above, below,
  // left or right of bb2, we have an easy reject.
  if (bb1[0] > bb2[2]      // bb1_left is right of bb2_right
  || bb1[1] > bb2[3]   // bb1_top is below bb2_bottom, now reverse them
  || bb2[0] > bb1[2]   // bb2_left is right of bb1_right
  || bb2[1] > bb1[3]   // bb2_top is below bb1_bottom, now reverse them
  ) {
    return false ;
  }
  // In this case one contains the other or they overlap.
  return true ;
}

/**
 *  Helper function supplied by Dr. Parson, student can just call it.
 *  rotatePoint takes the unrotated coordinates local to an object's 0,0
 *  reference location and rotates them by angleDegrees in degrees. Applying it
 *  to global coordinates rotates around the global 0,0 reference point in the
 *  LEFT,TOP corner of the display. x, y are the unrotated coords. Return value
 *  is 2-element array of the rotated x,y values.
**/
double [] rotatePoint(double x, double y, double angleDegrees) {
  double [] result = new double [2];
  double angleRadians = Math.toRadians(angleDegrees);
  // I have kept local variables as doubles instead of floats until the last
  // possible step. I was seeing rounding errors in the displayed BBs when they
  // are scaled when using floats. Using doubles for these calculations appears
  // to have eliminated those occasionally noticeable errors.
  // SEE: https://en.wikipedia.org/wiki/Rotation_matrix
  double cosAngle = (Math.cos(angleRadians)); // returns a double
  double sinAngle = (Math.sin(angleRadians));
  result[0] = (x * cosAngle - y * sinAngle) ;
  result[1] = (x * sinAngle + y * cosAngle);
  // println("angleD = " + angleDegrees + ", cos = " + cosAngle + ", sin = " + sinAngle + ", x = " + x + ", y = "
    // + y + ", newx = " + result[0] + ", newy = " + result[1]);
  return result ;
}
/**
 *  Helper function supplied by Dr. Parson, student can just call it. rotateBB
 *  takes the (leftx, topy) and (rightx, bottomy) extents of an unrotated
 *  bounding box and determines the leftmost x, uppermost y, rightmost x, and
 *  bottommost y of the rotated BB, and returns these rotated extents in a
 *  4-element array of coodinates. rotateBB needs to rotate every corner of the
 *  original bounding box in turn to find the rotated bounding box as min and
 *  max values for X and Y.
 *  Parameters:
 *    leftx, topy and rightx, bottomy are the original, unrotated extents.
 *    angle is the angle of rotation in degrees.
 *    scaleXfactor and scaleYfactor are the scalings of the shape with the BB.
 *    referencex,referencey is the "center" 0,0 point within the shape
 *    being rotated, with is also the reference point of the BB, in global coord.
 *  Return 4-element array holds the minx,miny and maxx,maxy rotated extents.
 *  See http://faculty.kutztown.edu/parson/fall2019/RotateBB2D.png
**/
int [] rotateBB(double leftx, double topy, double rightx, double bottomy,
  double angle, double scaleXfactor, double scaleYfactor, double referencex, double referencey) {
  int [] result = new int [4];
  leftx = leftx * scaleXfactor ;
  rightx = rightx * scaleXfactor ;
  topy = topy * scaleYfactor ;
  bottomy = bottomy * scaleYfactor ;
  double [] ul = rotatePoint(leftx, topy, angle); // rotate each of the 4 corners
  double [] ll = rotatePoint(leftx, bottomy, angle);
  double [] ur = rotatePoint(rightx, topy, angle);
  double [] lr = rotatePoint(rightx, bottomy, angle);
  double minx = Math.min(ul[0], ll[0]);// find minx,miny and max,maxy from all 4
  minx = Math.min(minx, ur[0]);
  minx = Math.min(minx, lr[0]);
  double maxx = Math.max(ul[0], ll[0]);
  maxx = Math.max(maxx, ur[0]);
  maxx = Math.max(maxx, lr[0]);
  double miny = Math.min(ul[1], ll[1]);
  miny = Math.min(miny, ur[1]);
  miny = Math.min(miny, lr[1]);
  double maxy = Math.max(ul[1], ll[1]);
  maxy = Math.max(maxy, ur[1]);
  maxy = Math.max(maxy, lr[1]);
  // scale by this shapes scale 
  result[0] = (int)Math.round(referencex + minx) ; // left extreme
  result[1] = (int)Math.round(referencey + miny); // top
  result[2] = (int)Math.round(referencex + maxx); // right side
  result[3] = (int)Math.round(referencey + maxy); // bottom
  return result ;
}
