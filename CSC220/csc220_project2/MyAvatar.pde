/**
 *  MyAvatar is my Avatar-derived class that displays & moves a mobile
 *  MyAvatar. You must write your own Avatar-derived class. You can delete
 *  class MyAvatar or use it as a starting point for your re-named class.
 *  Document what your class adds or changes at the top of the class
 *  declaration like this.
 **/
class MyCat extends CollisionDetector {
    /* The data fields store the state of the Avatar. */
    protected int legdist = 0 ; // You can initialize to a constant here.
    MyCat(int avx, int avy, int avz, float spdx, float spdy, float spdz, float avscale) {
        super(avx,avy,avz,spdx,spdy,spdz,avscale,0,0,0);
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
        lights(); //adds shadows and stuff
        directionalLight(255, 255, 255, 0, 0, -1); //added a directional light so they are lit up from the front
        // Draw the avatar.
        push(); // STUDENT *MUST* use push() & translate first in display().
        translate(myx, myy, myz);
        scale(myscale);
        
        //this is supposed to be a cat if you couldn't tell
        
        noStroke();
        fill(255, 215, 0); // Orange color
        box(50, 30, 80); //body
        
        // Head
        translate(0, -10, 40);
        sphere(30);
    
        // Eyes
        fill(255); 
        translate(10, -5, 22.5);
        sphere(8); //white part of eye
        fill(0); 
        translate(0, 0, 5);
        sphere(4); //pupil
        translate(-20, 0, -5);
        fill(255); 
        sphere(8); //white part of eye
        fill(0); 
        translate(0, 0, 5);
        sphere(4); //pupil
    
        // Ears
        fill(0); 
        translate(0, -12, -10); //2 black rectangles sticking out of head(ears)
        box(10, 20, 5);
        translate(20, 0, 0);
        box(10, 20, 5);
    
        // Legs
        translate(10, 55, -92.5); //4 legs connected to the corners of the body
        box(10, 30, 10);
        translate(-40, 0, 0);
        box(10, 30, 10);
        translate(0, 0, 70);
        box(10, 30, 10);
        translate(40, 0, 0);
        box(10, 30, 10);
    
        // Tail
        fill(0); 
        translate(-20, -30, -80); //tail sticking out of the middle of the backside of the body
        box(5, 5, 50);
        
        translate(0, -10, 113);
        for (int back = 0 ; back < 20 ; back++) {
            arc(0, 10 , 20 , 10 , 0, PI); // mouth
            translate(0,0,-1);  // next mouth is behind previous
        }
        
        pop(); // STUDENT *MUST* use pop() last in display().
    }
    // The move() function updates the Avatar object's state.
    void move() {
        // get ready for movement in next frame.
        myx = round(myx + speedX) ;
        myy = round(myy + speedY) ;
        myz = round(myz + speedZ);
        legdist = (legdist+1) % 20 ;
        detectCollisions();
    }
    int [] getBoundingBox() {
        int [] result = new int[6];
        result[0] = myx-round(30*myscale) ; // left extreme of left arm
        result[1] = myy - round(40*myscale); // top of hat
        result[2] = myz - round(70*myscale);  // back of head
        result[3] = myx + round(30*myscale); // max of right leg & arm
        result[4] = myy + round(42*myscale) ; // bottom of legs
        result[5] = myz + round(72*myscale);  // front of head
        return result ;
    }
}
