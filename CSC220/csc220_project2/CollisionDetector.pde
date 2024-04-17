/**
 *  An abstract class provides helper functions and data fields required by
 *  all subclasses. Abstract class CollisionDetector provides location and
 *  scaling and rotation data fields that subclasses use. It also provides
 *  helper functions, notably detectCollisions() for collision detection, that
 *  are used by all subclasses. The keyword *protected* means that only subclasses
 *  can use protected data & methods. The keyword *private* means that only the
 *  defining class can use them, and *public* means that any class can use them.
 **/
abstract class CollisionDetector implements Avatar {
    protected int myx, myy, myz ;    // x,y,z location of this object
    protected float myscale ;   // scale of this object, 1.0 for no scaling
    protected float speedX ;    //  speed of motion, negative for left.
    protected float speedY ;    //  speed of motion, negative for up.
    protected float speedZ ;    //  speed of motion, negative for away from front.
    float myrotZ = 0.0 ; // subclasses may rotate & scale in other dimensions
    float rotZspeed = 0.0, sclspeed = 0.0 ; // subclasses may change myscale, myrotZ in move().
    // Testing shows that mobile shapes may push other mobile shapes
    // off of the screen, depending on order of collision detection.
    // Some Avatar classes may want their displays to wander around outside.
    // Data field xlimit and ylimit test for that.
    // See java.lang.Integer in https://docs.oracle.com/javase/8/docs/api/index.html
    protected int xlimitleft = Integer.MIN_VALUE ;  // no limit by default
    protected int ylimittop = Integer.MIN_VALUE ;  // no limit by default
    protected int xlimitright = Integer.MAX_VALUE ;  // no limit by default
    protected int ylimitbottom = Integer.MAX_VALUE ;  // no limit by default
    protected int zlimitmin = minimumZ ;  // default for drawing
    protected int zlimitmax = maximumZ ;  // default for drawing
                                          // The constructor initializes the data fields.
    CollisionDetector(int avx, int avy, int avz, float spdx, float spdy, float spdz,
            float avscale, float scalespeed, float rotation, float rotatespeed) {
        myx = avx ;
        myy = avy ;
        myz = avz ;
        speedX = spdx ;
        speedY = spdy ;
        speedZ = spdz ;
        myscale = avscale ;
        sclspeed = scalespeed ;
        myrotZ = rotation ;
        rotZspeed = rotatespeed ;
    }
    void shuffle() {
        // default is to do nothing; override this in derived class.
    }
    void forceshuffle() {
        // default is to change location; add to this in derived class.
        myx = round(random(10, width-10));  // Put it somewhere on the display.
        myy = round(random(10, height-10));
        myz = round(random(minimumZ/4, maximumZ/4)); // don't go too far out
    }
    int getX() {
        return myx ;
    }
    int getY() {
        return myy ;
    }
    int getZ() {
        return myz ;
    }
    // Check this object against every other Avatar object for a collision.
    // Also make sure it doesn't wander outside the x and y limit values
    // set by the constructor. Putting detectCollisions() in this abstract class
    // eliminates the need to put it into multiple derived class move() functions,
    // which can simply call this function.
    protected void detectCollisions() {
        int [] mine = getBoundingBox();
        for (Avatar a : avatars) {
            if (a == this) {
                continue ; // this avatar always overlaps with itself
            }
            int [] theirs = a.getBoundingBox();
            if (overlap(this,a)) {
                if (mine[0] >= theirs[0] && mine[0] <= theirs[3]) {
                    // my left side is within them, move to the right
                    speedX = abs(speedX);
                    myx += 2*speedX ;  // jump away a little extra
                } else if (mine[3] >= theirs[0] && mine[3] <= theirs[3]) {
                    // my right side is within them, move to the left
                    speedX = - abs(speedX);
                    myx += 2*speedX ;
                }
                // Above may have eliminated the overlap, check before proceeding.
                mine = getBoundingBox();
                if (overlap(this,a)) {
                    // Do equivalent check for vertical overlap.
                    if (mine[1] >= theirs[1] && mine[1] <= theirs[4]) {
                        speedY = abs(speedY); // my top, send it down
                        myy += 2*speedY ;
                    } else if (mine[4] >= theirs[1] && mine[4] <= theirs[4]) {
                        speedY = - abs(speedY); // my bottom, send it up
                        myy += 2*speedY ;
                    }
                }
                // Z test added for assignment 2 3D.
                mine = getBoundingBox();
                if (overlap(this,a)) {
                    // Do equivalent check for vertical overlap.
                    if (mine[2] >= theirs[2] && mine[2] <= theirs[5]) {
                        speedZ = abs(speedZ); 
                        myz += 2*speedZ ;
                    } else if (mine[5] >= theirs[2] && mine[5] <= theirs[5]) {
                        speedZ = - abs(speedZ);
                        myz += 2*speedZ ;
                    }
                }
            }
        }
        // Testing shows that mobile shapes may push other mobile shapes
        // off of the screen or thru Avatars, depending on order of collision detection.
        // Some Avatar classes may want their displays to wander around outside the display.
        // Data fields xlimit and ylimit test for that.
        if (xlimitleft != Integer.MIN_VALUE && myx <= xlimitleft && speedX < 0) {
            speedX = - speedX ;
            myx = xlimitleft + 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF LEFT " + speedX);
            // Too many print statements, restrict to the bigger Avatars.
            // I usually comment out print statements until I am sure the bug is gone.
        }
        if (xlimitright != Integer.MAX_VALUE && myx >= xlimitright && speedX > 0) {
            speedX = - speedX ;
            myx = xlimitright - 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF RIGHT " + speedX);
        }
        if (ylimittop != Integer.MIN_VALUE && myy <= ylimittop && speedY < 0) {
            speedY = - speedY ;
            myy = ylimittop + 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF TOP " + speedY);
        }
        if (ylimitbottom != Integer.MAX_VALUE && myy >= ylimitbottom && speedY > 0) {
            speedY = - speedY ;
            myy = ylimitbottom - 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF BOTTOM " + speedY);
        }
        if (myz <= zlimitmin && speedZ < 0) {
            speedZ = - speedZ ;
            myz = zlimitmin + 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF BACK " + speedY);
        }
        if (myz >= zlimitmax && speedZ > 0) {
            speedZ = - speedZ ;
            myz = zlimitmax - 1 ;
            // if (myscale >= 1) println("DEBUG WENT OFF FRONT " + speedY);
        }
    }
}
