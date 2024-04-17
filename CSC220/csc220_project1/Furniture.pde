//////////////////////////////////////////////////////////////////////////////
// Furniture concrete class

/**
 *  Class Furniture implements immobile obstacles as rectangles.
 *  It adds fields for object width, height, and color.
**/
class Furniture extends CollisionDetector {
  /* The data fields store the state of the Avatar. */
  protected int mywidth, myheight, mycolor ;
  // Save the the problems of writing a new display function
  // by implementing no-op rotation and scaling here,
  // subclasses can use them.
  // rot is in degrees.
  // The constructor initializes the data fields.
  Furniture(int avx, int avy, int w, int h, int c) {
    super(avx,avy,0,0,1.0,0,0,0);
    mywidth = w ;
    myheight = h ;
    mycolor = c ;
  }
  // The display() function simply draws the Avatar object.
  // The move() function updates the Avatar object's state.
  void display() {
    // Draw the avatar.
    push(); // STUDENT *MUST* use push() & translate first in display().
    translate(myx, myy);
    if (myrot != 0.0) {
      rotate(radians(myrot));
    }
    if (myscale != 1.0) {
      scale(myscale);
    }
    fill(mycolor);
    stroke(mycolor);
    strokeWeight(1);
    ellipse(0,0,mywidth,myheight);  // 0,0 is the center of the object. made and ellipse instead of a rectangle
    pop(); // STUDENT *MUST* use pop() last in display().
  }
  // The move() function updates the Avatar object's state.
  // Furniture is immobile, so move() does nothing.
  void move() {
  }
  int [] getBoundingBox() {
    int [] result = rotateBB(-mywidth/2, -myheight/2, mywidth/2, myheight/2, myrot,
      myscale, myscale, myx, myy);
    return result ;
  }
}
