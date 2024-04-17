/************************************************************
/* Authors: Dr. Parson & Skyler Romanuski
/*          Modified by Dr. Schwesinger spring 2024
/* Course: CSC220 Object-Oriented Multimedia Programming
/* Sketch name:  csc220_project2
/*    makes all Avatar-derived classes 3D.
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
// GLOBALS ADDED FOR 3D FURNITURE:
int minimumZ, maximumZ ; // initialized in setup.

// Assignment 1 GLOBAL VARIABLES are for the collection of Avatar objects.
// All Avatar state variables go inside of Avatar-derived subclasses.
Avatar avatars [] ;   // An array holding multiple Avatar objects.
int backgroundColor = 255 ;  // Wraps from 255 back to 0.
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
PShape customPShape = null ;
PImage customPImage = null ;  // Leave this at null if you don't texture.

void setup() {
    // setup() runs once when the sketch starts, initializes sketch state.
    size(1500, 1000, P3D);  // STUDENT may change size or use fullScreen(P3D).
                           // fullScreen(P3D);
    frameRate(60);  // default 60, newer Macs need this after size()
    background(backgroundColor);
    maximumZ = height / 2 ;  // front of the scene
    minimumZ = - height / 2 ;  // back of the scene
    //link to image https://pixabay.com/vectors/circles-round-triangle-154261/
    customPImage = loadImage("TriangleTexture.png"); // load before makeCustomPShape(), USE YOUR OWN
                                                // STUDENT: If you decide not to texture your PShape, remove the
                                                // above loadImage call, allowing customPImage to be null.
                                                //customPShape = makeCustomPShape(customPImage);
    avatars = new Avatar [ 30 ] ;  // reduced from 50 to reduce CPU load
    avatars[0] = new MyCat(width/4, height/4, 0, 3, 3, 2, 5);
    // See constructors in their classes below to interpret parameters.
    int cyan = color(0, 255, 255, 255);  // Red, Green, Blue, Alpha
                                         // By positioning based on system variables *width* and *height*, as opposed to
                                         // using fixed location numbers, your sketch will work with any display size.
                                         // NOTE THE CONSTRUCTORS NOW TAKE A Z COORDINATE, AND Z SPEED IN SOME CASES.
    avatars[1] = new Furniture(width/2, 5, 0, width-20, 10, maximumZ-minimumZ-20, cyan);  // 10 pixels wide boundary is impenetrable
    avatars[2] = new Furniture(width/2, height-5, 0, width-20, 10, maximumZ-minimumZ-20,cyan);
    avatars[3] = new Furniture(5, height/2, 0, 10, height-20, maximumZ-minimumZ-20, cyan);
    avatars[4] = new Furniture(width-5, height/2, 0, 10, height-20, maximumZ-minimumZ-20, cyan);
    avatars[5] = new MyCat(3*width/4, 3*height/4, 0, 9, 7, 8, 2);
    int magenta = color(255, 0, 255, 255);
    final int barlength = 200 ;
    avatars[6] = new Furniture(barlength/2, height/2, 0, barlength, 10, maximumZ-minimumZ, magenta);  // 10 pixels wide boundary is impenetrable
    avatars[7] = new Furniture(width-barlength/2, 2*height/3, 0, barlength, 10, maximumZ-minimumZ, magenta);
    avatars[8] = new Furniture(width/3, barlength/2, 0, 10, barlength, maximumZ-minimumZ, magenta);
    avatars[9] = new Furniture(width/3, height-barlength/2, 0, 10, barlength, maximumZ-minimumZ, magenta);
    color orange = color(255,184,0,255);
    avatars[10] = new Paddle(width/2, height/2, 0, barlength, 10, (maximumZ-minimumZ), 0, .02, orange);
    avatars[11] = new Paddle(width/2, height/2, 0, barlength, 10, (maximumZ-minimumZ), 90, -.03, orange);
    avatars[12] = new VectorAvatar(int(random(0,width)), int(random(0,height)), 0, 3, 4, round(random(2,5)), 1, customPImage);
    for (int i = 13 ; i < avatars.length-1 ; i++) { // STUDENT BE CAREFUL TO START i AT *YOUR* NEXT OPEN SLOT!
        int zspeed = round(random(-5,5));
        if (zspeed == 0) { zspeed = 1 ; }
        avatars[i] = new MyCat(int(random(0,width)), int(random(0, height)),
                int(random(minimumZ, maximumZ))/2,
                round(random(1,5)), round(random(-5,-1)), zspeed, .25);
    }
    // ALPHA IS A LITTLE NON-FUNCTIONAL IN 3D SKETCHES
    // P3D makes me plot a translucent layer in the right order relative to other objects,
    // which in this sketch is *after*. If you plot a non-255 alpha layer before another,
    // the 3D clipping internals in Processing hides objects on the other side of an
    // alpha < 255 layer when your camera POV goes behind it!!!
    int translucentRedForBackWall = color(255,0,0,100);  // alpha (opacity) is final parameter
    avatars[avatars.length-1] = new Furniture(width/2, height/2, minimumZ, width, height, 1, translucentRedForBackWall);
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
        avatars[i].display();
    }
    if (showBoundingBox) {
        // Do this in a separate loop so we can do the initial part once.
        rectMode(CORNER);
        noFill();
        stroke(0);
        strokeWeight(1);
        /* THIS WAS THE 2D CODE
           for (Avatar avt : avatars) {
        // For testing bounding box
        int [] bb = avt.getBoundingBox();
        rect(bb[0], bb[1], bb[2]-bb[0], bb[3] - bb[1]);
           }
           */
        for (Avatar avt : avatars) {
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
            avatars[i].shuffle();
        }
    } else if (key == '!') {
        for (Avatar a : avatars) {
            a.forceshuffle();
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
