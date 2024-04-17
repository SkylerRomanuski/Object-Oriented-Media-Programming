// All STUDENT instructions are in this tab. TEST AFTER EACH STUDENT STEP!!!
// STUDENT AVATAR & any extra variables for it go in STUDENT tab unless otherwise noted.
// This is due via D2L Assignment 3 at ???.

// STUDENT 1 (10%) Copy your Avatar class (nothing else) into this tab and add constructor
// calls in the setup() function in the main tab within this loop.
  //for (int i = avatars.length/2-2 ; i < avatars.length ; i++) {
  //    // STUDENT 1 construct your avatars in this loop.
  //}
// Test that your avatar displays and moves properly before STEP 2.
int MyCatScaleStep = 0 ;
int MyCatTimeDelaySlot = 0 ;
class MyCat extends CollisionDetector {
    /* The data fields store the state of the Avatar. */
    int channel = 10 ;
    int mypitch = 0 ;
    float mydelay = 0 ;
    float [] delaySeconds = {.1, .15, .25};
    int instrument = 121 ; // http://midi.teragonaudio.com/tutr/gm.htm
    MyCat(int avx, int avy, int avz, float spdx, float spdy, float spdz, float avscale) {
        super(avx,avy,avz,spdx,spdy,spdz,avscale,0,0,0);
        // Call the base class constructor to initialize its data fields,
        // then initialize this class' data fields.
        xlimitright = width ;
        ylimitbottom = height ; // limit off-screen motion to
        xlimitleft = 0 ;    // one width or height off the display
        ylimittop = 0 ;    // in either direction
      int [] myscale = scales[2];  // major scale
      mypitch = myscale[MyCatScaleStep] + 48  ;
      // major scale, next note in scale, halfway up keyboard
      MyCatScaleStep = (MyCatScaleStep + 1) % myscale.length ;
      mydelay = delaySeconds[MyCatTimeDelaySlot];   //STUDENT IGNORE DELAY
      instrument += MyCatTimeDelaySlot ;
       //You can come up with only one OR more than 1 instrument for your avatar.
      MyCatTimeDelaySlot = (MyCatTimeDelaySlot + 1) % delaySeconds.length ;
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
        Set<Avatar> colliders = detectCollisions();
        if (colliders.size() > 0) {
          sendMIDI(ShortMessage.PROGRAM_CHANGE, channel, instrument, 0);
          int volumeAdjust = 7 ;
          sendMIDI(ShortMessage.CONTROL_CHANGE, channel, volumeAdjust, 127);
          int balanceControl = 8 ;
          int balanceLocation = int(constrain(map(myx, 0, width, 0, 127),0,127));  // 64 is centered in stereo field
          sendMIDI(ShortMessage.CONTROL_CHANGE, channel, balanceControl, balanceLocation);
          int modWheel = 1;
          int modValue = int(constrain(map(myy, 0, height-1, 0, 127), 0, 127)); //used mod wheel control change MIDI effect in the y direction
          sendMIDI(ShortMessage.CONTROL_CHANGE, channel, modWheel, modValue);

          int reverb = 91;
          int reverbValue = int(constrain(map(myz, minimumZ, maximumZ, 0, 127),0,127)); //used "effect" or reverb control change MIDI effect in the z direction
          sendMIDI(ShortMessage.CONTROL_CHANGE, channel, reverb, reverbValue);
          
          sendMIDI(ShortMessage.NOTE_ON, channel, mypitch, 127);
          // See http://midi.teragonaudio.com/tech/midispec.htm
        }
        for (Avatar other : colliders) {
          float probability = random(0, 100);
          if (probability < 31) { // changed the probability of implosion from 60% to 31%
            other.mow();
          }
        }
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

// STUDENT 2 (10%) The constructor parameters should not need to change from Assignment 2.
// There are no new arguments. The MIDI instrument, channel, and other MIDI properties are
// defined inside my Professor class and will be inside your class after it displays.
// Class Professor is in tab Parson. Here are the MIDI data fields at the top of the class.
// You can come up with only one OR more than 1 instrument for your avatar.

//int ProfessorScaleStep = 0 ;
//int ProfessorTimeDelaySlot = 0 ;
//class Professor extends CollisionDetector {
//  /* The data fields store the state of the Avatar. */
//  protected int legdist = 0 ; // You can initialize to a constant here.
//  int channel = 0 ;
//  int mypitch = 0 ;
//  float mydelay = 0 ;
//  float [] delaySeconds = {.1, .15, .25}; IGNORE THE DELAY
//  I stopped using the delay and switched to making sound upon collisions.
//  int instrument = 106 ; // http://midi.teragonaudio.com/tutr/gm.htm

// and in the constructor code:

    //int [] myscale = scales[2];  // major scale
    //mypitch = myscale[ProfessorScaleStep] + 48  ;
    //// major scale, next note in scale, halfway up keyboard
    //ProfessorScaleStep = (ProfessorScaleStep + 1) % myscale.length ;
    //mydelay = delaySeconds[ProfessorTimeDelaySlot];   STUDENT IGNORE DELAY
    //instrument += ProfessorTimeDelaySlot ;
    // You can come up with only one OR more than 1 instrument for your avatar.
    //ProfessorTimeDelaySlot = (ProfessorTimeDelaySlot + 1) % delaySeconds.length ;
    
// I used two global variables ProfessorScaleStep and ProfessorTimeDelaySlot defined
// just outside the class to vary the note (mypitch) instrument, and timing
// (mydelay) for each newly constructed Professor object. Normally a Java "class static"
// variable inside the class would have only 1 value shred by all objects of that class,
// but the Processing framework disallows class static variables for framework
// implementation reasons, so I put them outside the class.

// Your Avatar MUST use channel 10 (I am using 0 and 1 and reserving the others),
// a range of instruments away from my 106 and its neighbors (see
// // http://midi.teragonaudio.com/tutr/gm.htm ) or explore with ConcentricCirclesInterval sketch.

// STUDENT 3 (50%) All of my Professor's MIDI function calls are inside its move() function.
// Note that detectCollisions() now returns a java.util.Set object containing
// all of the colliding Avatar objects, if any, including bales of Globey objects.
// Use this code from detectCollisions()'s return value to sonify collisions.
// Use your own new or added CONTROL_CHANGEs or other MIDI messages, e.g., 2 notes at a time.

    //Set<Avatar> colliders = detectCollisions();
    //if (colliders.size() > 0) {
    //  sendMIDI(ShortMessage.PROGRAM_CHANGE, channel, instrument, 0);
    //  int volumeAdjust = 7 ;
    //  sendMIDI(ShortMessage.CONTROL_CHANGE, channel, volumeAdjust, 127);
    //  int balanceControl = 8 ;
    //  int balanceLocation = int(constrain(map(myx, 0, width, 0, 127),0,127));  // 64 is centered in stereo field
    //  sendMIDI(ShortMessage.CONTROL_CHANGE, channel, balanceControl, balanceLocation);
    //  sendMIDI(ShortMessage.NOTE_ON, channel, mypitch, 127);
    //  // See http://midi.teragonaudio.com/tech/midispec.htm
    //}
    //for (Avatar other : colliders) {
    //  float probability = random(0, 100);
    //  if (probability < 60) { // mow 60% of them
    //    other.mow();
    //  }
    //}
    
    // 3a. CHANGE the probability if mow()ing a Globey from 60% to something else. Play around with values.
    // 3b. Add a CONTROL_CHANGE MIDI effect that you can hear, see
    // http://midi.teragonaudio.com/tech/midispec.htm and experiment with ConcentricCirclesInterval sketch.
    // Take a listen to modulation wheel (controller 1) and chorus (controller 93) Note that unlike the
    // instrument numbers, these start at 0, i.e., mod wheel is 1, bank select is 0. Make it a mapped
    // function of y location relative to [0, height-1] or another avatar varying variable.
    // 3c. Add a second CONTROL_CHANGE MIDI effect that you can hear. Make it a mapped function
    // of z location relative to minimumZ and maximumZ or another avatar varying variable.
    
 // STUDENT 4 (30%) Make an imploding Globey similar to a video I will post. 
 // Here is what I did for the video:
 // 4a. changed this in Globey's mow() function:
  // void mow() {
  //  avatars[avatarsIndex] = null ;
  //  GlobeyCount = constrain(GlobeyCount-1, 0, GlobeyCount);
  //  // println("DEBUG GlobeyCount GlobeyMAX", GlobeyCount, GlobeyMax);
  //  if (GlobeyCount == 0) {
  //    sendMIDI(ShortMessage.NOTE_OFF, channel, pitch, 0);
  //  }
  //}
  // TO THIS:
  //void mow() {
  //  mowCounter += 1 ;
  //}
  // I initialized the "int mowCounter = 0" code in the top of class Globey.
 
 
  // 4b. The move() function in Globey now does the following pseudo-code:
  //  If the mowCounter is greater than 0
  //      Add 1 to mowCounter
  //      If mowScaleXYZ is a value very close to 0.0 (it may never reach 0).
  //        Do the steps previously in Globey.mow(), i.e., null this object's avatars[] entry 
  //        and send the NOTE_OFF if the decrement GlobeyCount <= 0.
  
  //  4c. In Globey.display, immediately after translate, if the mowCounter is greater than 0,
  //      scale(mowScaleXYZ), where mowScaleXYZ is initialized to 1.0 in the constructor.
  //      Then, still within the "if the mowCounter is greater than 0" scope,
  //      decrement mowScaleXYZ by some tiny but vsible amount. This will shrink the sphere.
  //      See step 4b above for when mowScaleXYZ approaches 0. I played around with shrinkage
  //      decerements and the boundary for sphere disappearance in step 4b.
  //      THE SCALE MUST MAKE THE GLOBEY SHRINK ***SLOWLY***, NOT EXPLODE!!!
  //      Basically, you want the scale in this step to approach 0 slowly, and when it is
  //      close to 0 (invisible in at least 1 dimension), do the step 4.b removal with NOTE_OFF.
  //      You should leave the bounding box for the sphere full size as it shrinks,
  //      in order to keep a higher probability of collision.
  
  // 4d. In the Globey tab change this line of code in makeglobePShape():
  //     globePImage = loadImage("clover.png");
  //     to load a .jpg or .png supplied by you. Make sure to include that image
  //     file in your project directory and turn it in to D2L with ALL YOUR CODE .pde files,
  //     preferrabbly as a regular .zip file. 
  //     Then do the following as given in makeglobePShape():
  // STUDENT set the texture on this PShape to globePImage.
  // See calls to setTexture(t) in 
  // https://faculty.kutztown.edu/parson/fall2022/CSC220FA2022DemoSome3D.txt
  // If you use an image off the web with no copyright restriction, cite its URL in a command.
