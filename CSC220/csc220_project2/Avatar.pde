/**
 *  An *interface* is a specification of methods (functions) that
 *  subclasses must provide. It provides a means to specify requirements
 *  that plug-in derived classes must provide.
 *  This interface Avatar specifies functions for both mobile & immobile
 *  objects that interact in this sketch. Added 3D getBoundingBox() for assn2.
 **/
interface Avatar {
    /**
     *  Avatar-derived class must have one or more variable
     *  data fields, at a minimum for the myx,myy,myz location,
     *  where 0,0,0 is the Avatar's reference point after translate(myx, myy, myz).
     **/
    /** Derived classes provide a constructor that takes some parameters. **/
    /**
     *  Write a display function that starts like this:

     pushMatrix();
     translate(myx, myy, myz);

     and ends like this:

     pop();

     with all display code inside the function.
     Write this in your derived class, not here in Avatar.

     In addition to translate, the display() code in your class must use
     one or more of scale (with 1 or 2 arguments), rotate,
     shearX, or shearY. You can also manipulate variables for color & speed.
     See my example classes for ideas. 
     **/
    void display();
    /** Write move() to update variable fields inside the object.
     *  Write this in your derived class, not here in Avatar. **/
    void move();
    /**
     *  getBoundingBox returns an array of 6 integers where elements
     *  [0],[1],[2] have the minimum X,Y,Z coordinates respectively, and
     *  [3],[4],[5] have the maximum X,Y,Z coordinates respectively.
     *  This function always returns a cuboid bounding box that contains the
     *  entire avatar. Coordinates are those in effect when display() or
     *  move() are called from the draw() function,
     **/
    int [] getBoundingBox();
    /** Return the X coordinate of this avatar, center. **/
    int getX();
    /** Return the Y coordinate of this avatar's center. **/
    int getY();
    /** Return the Z coordinate of this avatar's center. **/
    int getZ();
    /** Randomize parts of a *mobile* object's space, including x,y,z location. **/
    void shuffle() ;
    /** Randomize parts of *every* object's space, including x,y,z location. **/
    void forceshuffle();
}
