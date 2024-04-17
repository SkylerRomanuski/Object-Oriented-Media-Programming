//////////////////////////////////////////////////////////////////////////////
// Avatar interface

/**
 *  An *interface* is a specification of methods (functions) that subclasses
 *  must provide. It provides a means to specify requirements that plug-in
 *  derived classes must provide. This interface Avatar specifies functions for
 *  both mobile & immobile objects that interact in this sketch.
**/
interface Avatar {
    /**
   *  Avatar-derived class must have one or more variable data fields, at a
   *  minimum for the x,y location, where 0,0 is the middle of the display
   *  area.
 **/

 /** Derived classes provide a constructor that takes some parameters. **/

 /**
  *  Write a display function that starts like this:

    push();
    translate(x, y);

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
   *  getBoundingBox returns an array of 4 integers where elements
   *  [0], [1] tell the upper left X,Y coordinates of the bounding
   *  box, and [2], [3] tell the lower right X,Y. This function
   *  always returns a rectangular bounding box that contains the
   *  entire avatar. Coordinates are those in effect when display() or
   *  move() are called from the draw() function,
  **/
  int [] getBoundingBox();
  /** Return the X coordinate of this avatar, center. **/
  int getX();
  /** Return the Y coordinate of this avatar's center. **/
  int getY();
  /** Randomize parts of a *mobile* object's space, including x,y location. **/
  void shuffle() ;
  /** Randomize parts of *every* object's space, including x,y location. **/
  void forceshuffle();
}
