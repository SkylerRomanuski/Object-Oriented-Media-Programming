/**
 *  Class Furniture implements immobile obstacles as rectangles.
 *  It adds fields for object width, height, and color.
 **/
class Furniture extends CollisionDetector {
    /* The data fields store the state of the Avatar. */
    protected int mywidth, myheight, mydepth, mycolor, mystroke ;
    // Save the the problems of writing a new display function
    // by implementing no-op rotation and scaling here,
    // subclasses can use them.
    // rot is in degrees.
    // The constructor initializes the data fields.
    Furniture(int avx, int avy, int avz, int w, int h, int depth, int c) {
        super(avx,avy,avz,0,0,0,1.0,0,0,0);
        mywidth = w ;
        myheight = h ;
        mydepth = depth ;
        mycolor = c ;
        // Extract RGB from mycolor & set nystroke to its opposite.
        mystroke = color(255-red(mycolor), 255-green(mycolor), 255-blue(mycolor));
    }
    // The display() function simply draws the Avatar object.
    // The move() function updates the Avatar object's state.
    void display() {
        // Draw the avatar.
        push(); // STUDENT *MUST* use push() & translate first in display().
        translate(myx, myy, myz);
        if (myrotZ != 0.0) {
            rotateZ(radians(myrotZ));
        }
        if (myscale != 1.0) {
            scale(myscale);
        }
        fill(mycolor);
        stroke(mystroke); // 2D REWORK to see edges stroke(mycolor);
        strokeWeight(10);
        // 2D REWORK rect(0,0,mywidth,myheight);  // 0,0 is the center of the object.
        box(mywidth, myheight, mydepth);
        pop(); // STUDENT *MUST* use pop() last in display().
    }
    // The move() function updates the Avatar object's state.
    // Furniture is immobile, so move() does nothing.
    void move() {
    }
    int [] getBoundingBox() {
        int [] result = new int[6];
        result[0] = myx-mywidth/2 ; // left extreme of box
        result[1] = myy - myheight/2; // top of box
        result[2] = myz - mydepth/2; // back of box
        result[3] = myx + mywidth/2; // right of box
        result[4] = myy + myheight/2; // bottom of box
        result[5] = myz + mydepth/2; // back of box
        return result ;
    }
}
