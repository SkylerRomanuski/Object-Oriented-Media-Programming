//////////////////////////////////////////////////////////////////////////////
// Paddle concrete class

/**
 *  Paddle extends class Furniture into a mobile, rotating rectangle.
**/
class Paddle extends Furniture {
  // Call base class constructor to initialize its fields,
  // then initialize fields added by this class (none presently),
  // and let limits on off-screen excursions.
  Paddle(int avx, int avy, int w, int h, float rotatespeed, int c) {
    super(avx, avy, w, h, c);
    rotspeed = rotatespeed ;
    xlimitright = 2 * width ;
    ylimitbottom = 2 * height ;
    xlimitleft = - width ;    // one width or height off the display
    ylimittop = - height ;    // in either direction
  }
  void move() {
    // Extend base class move by adding rotation.
    myrot += rotspeed ;
    while (myrot >= 360) {
      myrot -= 360 ;
    } 
    while (myrot < 0) {
      myrot += 360;
    }
    super.move(); // Do the base class move for those parts.
  }
}
