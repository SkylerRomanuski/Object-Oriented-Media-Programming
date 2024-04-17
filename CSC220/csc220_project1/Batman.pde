//////////////////////////////////////////////////////////////////////////////
// Professor concrete class

/**
 *  Professor is my Avatar-derived class that displays & moves a mobile
 *  Professor. You must write your own Avatar-derived class. You can delete
 *  class Professor or use it to interact with your Avatar-derived class.
**/
class Professor extends CollisionDetector {
  /* The data fields store the state of the Avatar. */
  protected int legdist = 0 ; // You can initialize to a constant here.
  Professor(int avx, int avy, float spdx, float spdy, float avscale, float scalespeed, float rotation, float rotatespeed) {
    super(avx,avy,spdx,spdy,avscale,scalespeed, rotation, rotatespeed);
    // Call the base class constructor to initialize its data fields,
    // then initialize this class' data fields.
    xlimitright = width ;
    ylimitbottom = height ; // limit off-screen motion to
    xlimitleft = 0 ;    // one width or height off the display
    ylimittop = 0 ;    // in either direction
  }
  void shuffle() {
    forceshuffle(); // always do it.
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
    fill(10, 10, 10); 
    ellipse(0, 0, 266.25, 156.5); //well defined 0,0 refrence point, this is also the outer black ring of the logo
    fill(255, 244, 21);
    ellipse(0, 0, 252, 144); //this is the yellow ellipse
    fill(10, 10, 10);
    ellipse(0, 0, 232, 125); //inner black ellipse
    fill(255, 244, 21);
    noStroke();
    quad(-15 , -70, -5, -45,5 ,-45 , 15 , -70); //cutout for batmans head
    arc(-32, -65, 40, 85, 0, PI-.15, OPEN); //arc on the left of batmmans head
    arc(32, -65, 40, 85, 0, PI+.15, OPEN); //arc on the right of batmans head
    arc(-20, 65, 40, 75, PI, 2*PI, OPEN); //first arc on the bottom of batman on the left
    arc(20, 65, 40, 75, PI, 2*PI, OPEN); //first arc on the bottom of batman on the right
    arc(-55, 65, 55, 75, PI+.4, 2*PI, OPEN); //second arc on the bottom of batman on the left
    arc(55, 65, 55, 75, PI, 2*PI-.3, OPEN); //second arc on the bottom of batman on the right
    pop(); // STUDENT *MUST* use pop() last in display().
  }
  // The move() function updates the Avatar object's state.
  void move() {
    // get ready for movement in next frame.
    myx = round(myx + speedX) ;
    myy = round(myy + speedY) ;
    myrot += rotspeed ;
    while (myrot >= 360) {
      myrot -= 360 ;
    } 
    while (myrot < 0) {
      myrot += 360;
    }
    
    detectCollisions();
  }
  int [] getBoundingBox() {
    int [] result = rotateBB(-xlimitleft/2 - 129, -ylimittop/2 - 75, xlimitright/5 - 169, ylimitbottom/5 - 86, myrot, myscale, myscale, myx, myy);
    return result ;
  }
}
