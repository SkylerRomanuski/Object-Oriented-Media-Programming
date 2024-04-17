/** VectorAvatar is my Avatar-derived class that displays & moves a custom
 * vector PShape. STUDENT must update getBoundingBox() to work with their
 * PShape.
 **/
class VectorAvatar extends CollisionDetector {
    /* The data fields store the state of the Avatar. */
    float rotXspeed = .04 ;
    float rotYspeed = .05 ;
    float myrotX = 0, myrotY = 0 ;
    PShape customPShape = null;
    VectorAvatar(int avx, int avy, int avz, float spdx, float spdy, float spdz, float avscale, PImage img) {
        super(avx,avy,avz,spdx,spdy,spdz,avscale,0,0,0);
        // Call the base class constructor to initialize its data fields,
        // then initialize this class' data fields.
        xlimitright = width ;
        ylimitbottom = height ; // limit off-screen motion to
        xlimitleft = 0 ;    // one width or height off the display
        ylimittop = 0 ;    // in either direction
        rotZspeed = .03 ;
        customPShape = makeCustomPShape(img);
    }
    void shuffle() {
        forceshuffle(); // always do it.
    }
    // The display() function simply draws the Avatar object.
    // The move() function updates the Avatar object's state.
    void display() {
        // Draw the avatar.
        push(); // STUDENT *MUST* use push() & translate first in display().
        translate(myx, myy, myz);
        scale(myscale);
        rotateX(myrotX);
        rotateY(myrotY);
        rotateZ(myrotZ);
        shape(customPShape, 0, 0);
        pop(); // STUDENT *MUST* use pop() last in display().
    }
    // The move() function updates the Avatar object's state.
    void move() {
        // get ready for movement in next frame.
        myx = round(myx + speedX) ;
        myy = round(myy + speedY) ;
        myz = round(myz + speedZ);
        myrotX += rotZspeed ;
        myrotY += rotYspeed ;
        myrotZ += rotZspeed ;
        detectCollisions();
    }
    int [] getBoundingBox() {
        // These limits do not account for rotation, but the
        // Pyramid PShape is -100 to +100 in all 3 dimensions.
        // You may have to adjust this to work with your PShape.
        int [] result = new int[6]; // customPShape.depth does not work.
        /*
           println("DEBUG customPShape width,height,depth: " + customPShape.width + ","
           + customPShape.height + "," + customPShape.depth);
           */
        result[0] = round(myx - 100 * myscale) ; //round(myx-myscale*customPShape.width/2.0);
        result[1] = round(myy - 200 * myscale) ; //round(myy-myscale*customPShape.height/2.0);
        result[2] = round(myz - 100 * myscale) ; //round(myz-myscale*customPShape.depth/2.0);
        result[3] = round(myx + 100 * myscale) ; //round(myx+myscale*customPShape.width/2.0);
        result[4] = round(myy + 200 * myscale) ; //round(myy-myscale*customPShape.width/2.0);
        result[5] = round(myz + 100* myscale) ; // round(myz-myscale*customPShape.depth/2.0);
        return result ;
    }

    // D. Parson's makeCustomPShape vectors taken from Shape3DDemo
    /*
     *  Make and return a custom 3D PShape created using vertex() calls,
     *  for use in Avatar-derived class VectorAvatar. The textureimg
     *  parameter may be null; when it is non-null, use it to texture
     *  at least one of the planar sides of the returned PShape. If the
     *  STUDENT decides not to texture, remove the loadImage call at the
     *  top of the project2.pde, allowing textureimg to be null.
     */
    private PShape makeCustomPShape(PImage textureimg) {
        // STUDENT NOTE: Even though
        // https://processing.org/reference/vertex_.html
        // shows use of 3D coordinates combined with texture:
        // vertex(x, y, z, u, v), that did not work for my
        // 3D planar surfaces like the initial base that varies
        // the Z value. Intuitively, the limitation makes sense,
        // since texturing images are 2D, and varying the Z
        // coordinate can create a non-planar shape, even though
        // mine are all planar. I switched to vertex(x, y, u, v)
        // for the textured planar surface in the else clause below,
        // then used rotateX and translate to move it into position
        // within the GROUP PShape.

        PShape left = createShape();  // Al of the other planar sides use the Z coordinate.
        left.beginShape();
        left.vertex(0, 100, 100);     
        left.vertex(0, -100, 0); 
        left.vertex(-100, 100, -100);  
        left.vertex(0, 100, 100);     
        left.endShape();
        left.setFill(color(28,255,0));
        PShape right = createShape();
        right.beginShape();
        right.vertex(0,100,100);
        right.vertex(0,-100,0);
        right.vertex(100,100,-100);
        right.vertex(0,100,100);;
        right.endShape();
        right.setFill(color(255,170,20));
        PShape back = createShape();
        back.beginShape();
        back.vertex(-100,100,-100);
        back.vertex(100,100,-100);
        back.vertex(0,-100,0);
        back.vertex(-100,100,-100);
        back.endShape();
        back.setFill(color(255,255,0));
        PShape leftBottom = createShape();  //continued off of the given triangular pyramid to make a hexahedron(6 sides)
        if (textureimg == null) {
          leftBottom.beginShape();
          leftBottom.vertex(0, 100, 100);      
          leftBottom.vertex(0, 300, 0);     
          leftBottom.vertex(-100, 100, -100);  
          leftBottom.vertex(0, 100, 100);      
          leftBottom.endShape();
          leftBottom.setFill(color(0,0,255));
        }
        else {
          int imgwidth = round(textureimg.width);  
          int imgheight = round(textureimg.height); // used a texture
          leftBottom.beginShape();
          leftBottom.vertex(0, 100, 100, 0, imgheight);      
          leftBottom.vertex(0, 300, 0, imgwidth/2, 0);     
          leftBottom.vertex(-100, 100, -100, imgwidth, imgheight);  
          leftBottom.vertex(0, 100, 100, 0, imgheight);      
          leftBottom.endShape();
          leftBottom.setTexture(textureimg);
        }

        PShape rightBottom = createShape();
        rightBottom.beginShape();
        rightBottom.vertex(0,100,100);    //added a bottom triangle to the right triangle
        rightBottom.vertex(0,300,0);
        rightBottom.vertex(100,100,-100);
        rightBottom.vertex(0,100,100);;
        rightBottom.endShape();
        rightBottom.setFill(color(0,202,255));
        PShape backBottom = createShape();
        backBottom.beginShape();
        backBottom.vertex(-100,100,-100);    //added a bottom triangle to the back triangle
        backBottom.vertex(100,100,-100);
        backBottom.vertex(0,300,0);
        backBottom.vertex(-100,100,-100);
        backBottom.endShape();
        backBottom.setFill(color(255,0,209));
        PShape custom = createShape(GROUP);
        //custom.addChild(base);
        custom.addChild(left);
        custom.addChild(right);
        custom.addChild(back);
        custom.addChild(leftBottom);     //added them to the custom shape
        custom.addChild(rightBottom);
        custom.addChild(backBottom);
        custom.translate(100,100,0); // trial-and-error, slide into centered position
        return custom ;
    }
}
