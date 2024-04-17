/**
 *  Paddle extends class Furniture into a mobile, rotating rectangle.
 **/
class Paddle extends Furniture {
    // Call base class constructor to initialize its fields,
    // then initialize fields added by this class (none presently),
    // and let limits on off-screen excursions.
    // Paddle changed from assignment 1 to grow and shrink in its rotated major direction,
    // rotation is fixed to 0 or 90 degrees in one direction, and it grows to width & shrinks to 1 in that direction.
    Paddle(int avx, int avy, int avz, int w, int h, int depth, float rotateamount, 
            float scalingspeed, int c) {
        super(avx, avy, avz, w, h, depth, c);
        myrotZ = rotateamount ;
        sclspeed = scalingspeed ;
        xlimitright = 2 * width ;
        ylimitbottom = 2 * height ;
        xlimitleft = - width ;    // one width or height off the display
        ylimittop = - height ;    // in either direction
        if (myrotZ != 0 && myrotZ != 90) {
            println("ERROR, Paddle is rotated invalid amount: " + rotateamount);
            myrotZ = 0 ;
        }
    }
    void move() {
        myscale += sclspeed ;
        int pixwidth = round(myscale * mywidth) ;
        if ((pixwidth <= 0 && sclspeed < 0) || (pixwidth >= width && sclspeed > 0)) {
            sclspeed = - sclspeed ;
        }
        super.move(); // in case it is ever implemented
    }
    void display() { // redefined from Furniture to scale only in X, rotate around Z
                     // Draw the avatar.
        push(); // STUDENT *MUST* use push() & translate first in display().
        translate(myx, myy, myz);
        if (myrotZ != 0.0) {
            rotateZ(radians(myrotZ));
        }
        if (myscale != 1.0) {
            scale(myscale,1,1);  // scale only in X vector
        }
        fill(mycolor);
        stroke(mystroke); // 2D REWORK to see edges stroke(mycolor);
        strokeWeight(10);
        // 2D REWORK rect(0,0,mywidth,myheight);  // 0,0 is the center of the object.
        box(mywidth, myheight, mydepth);
        pop(); // STUDENT *MUST* use pop() last in display().
    }
    // Customize display() and getBB() for scaling in only 1 direction.
    int [] getBoundingBox() {
        int [] result = new int[6];
        if (myrotZ == 0) {
            result[0] = round(myx-(myscale*mywidth)/2) ; // left extreme of box
            result[1] = myy - myheight/2; // top of box
            result[2] = myz - mydepth/2; // back of box
            result[3] = round(myx+(myscale*mywidth)/2) ; // left extreme of box
            result[4] = myy + myheight/2; // bottom of box
            result[5] = myz + mydepth/2; // back of box
        } else {
            result[1] = round(myy-(myscale*mywidth)/2) ; // ROTATED BY 90
            result[0] = myx - myheight/2; 
            result[2] = myz - mydepth/2; 
            result[4] = round(myy+(myscale*mywidth)/2) ; 
            result[3] = myx + myheight/2; 
            result[5] = myz + mydepth/2; 
        }
        return result ;
    }
}
