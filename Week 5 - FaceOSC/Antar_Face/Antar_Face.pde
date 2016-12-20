// a template for receiving face tracking osc messages from
// Kyle McDonald's FaceOSC https://github.com/kylemcdonald/ofxFaceTracker
//
// 2012 Dan Wilcox danomatika.com
// for the IACD Spring 2012 class at the CMU School of Art
//
// adapted from from Greg Borenstein's 2011 example
// http://www.gregborenstein.com/
// https://gist.github.com/1603230
//
import oscP5.*;
OscP5 oscP5;

// num faces found
int found;
float[] rawArray;

//which point is selected
int highlighted;

//-------------------------- ORB CLASS
float proximity = random(2, 2.5);

class Orb {

  float x;
  float y;
  float r;

  float angle = 0.1;
  float offSet = 400;
  float scalar = 40;
  float speed = 0.05;
  float move = 0;

  Orb (float orbX, float orbY, float orbR, float orbA) {
    y = orbY;
    x = orbX;
    r = orbR;
    angle = orbA;
  }

  void update() {
    move = (y + sin(angle) * scalar);
    angle+=speed;
    //y = move;
    r = noseChinD*.5;
    speed = smileD*.005;
  }

  void render() {
    //translate(x, (height*0.5)+y);
    pushMatrix();
    translate(x, move);
    //noFill();
    fill(255, 255, 255);
    noStroke();
    //stroke(255);
    sphere(r);
    popMatrix();
  }
}
ArrayList<Orb> allOrbs; 
float templeD;
float noseChinD;
float smileD;
float noseX;
float noseY;


void setup() {
  size(800, 800, P3D);
  frameRate(30);

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "rawData", "/raw");

  //-------------------------------------ORB SETUP
  allOrbs = new ArrayList<Orb>();
  float x = random(width);
  float y = random(height*.15);
  float r = random(20, 75);
  float a = random(0.1, 0.7);
  Orb anOrb = new Orb(x, y, r, a);

  allOrbs.add(anOrb);
}

void draw() {  
  background(0);
  //stroke(0);
  noStroke();


  if (found > 0) {
    for (int val = 0; val < rawArray.length -1; val+=2) {
      if (val == highlighted) { 
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      //fill(223);
      //ellipse(rawArray[val], rawArray[val+1], 8, 8); 
      //text("Use Left and Right arrow keys to cycle through points", 20, 20);
      //text( "current index = [" + highlighted + "," + int(highlighted + 1) + "]", 20, 40);
    }
    templeD = dist(rawArray[0], rawArray[1], rawArray[32], rawArray[33]);
    noseChinD = dist(rawArray[16], rawArray[60], rawArray[32], rawArray[61]);
    smileD = dist(rawArray[96], rawArray[108], rawArray[97], rawArray[109]);

    noseX = rawArray[60];
    noseY = rawArray[61];
  }

  //------------------------DRAW ORB
  turnTheLightsOn();
  camera(noseX, noseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  int nOrbs = allOrbs.size();
  for (int i = 0; i < nOrbs; i++) {
    Orb anOrb = allOrbs.get(i);
    anOrb.update();
    anOrb.render();
  }
}

void turnTheLightsOn() {
  //spotLight(255, 255, 255, width/2, height/2, 800, 0, 0, -1, PI/4, 2);
  spotLight(templeD, 0, 0, width/2, height, 800, 0, 0, -1, PI/4, 2); // red spot light
  spotLight(0, 0, 255-(.5*templeD), width/2, 0, 800, 0, 0, -3, PI/4, 2); // blue spot light
}

void createOrbs() {
  allOrbs.clear(); 
  for (int i=0; i<100000; i++) {
    float probex = random(width);
    float probey = random(height);
    float probeR = noseChinD*.5;
    float probeA = random(0.1, 3);
    int nOrbs = allOrbs.size();
    boolean bTooClose = false;

    // Check probex and proby against every previous circle 
    // to make sure it's not too close to any of them. 
    for (int c=0; c<nOrbs; c++) {
      Orb cthOrb = allOrbs.get(c);
      float d = dist(probex, probey, cthOrb.x, cthOrb.y);
      if (d < (proximity * probeR)) {
        bTooClose = true;
      }
    }

    // Check that probex and probey are not too close to the borders.
    if ((probex < probeR) || (probex > (width - probeR)) || (probey < probeR) || (probey > (height -probeR))) {
      bTooClose = true; // we're too close to the edge
    }

    if (bTooClose == false) {
      Orb newOrb = new Orb(probex, probey, probeR, probeA);
      allOrbs.add(newOrb);
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    highlighted = (highlighted + 2) % rawArray.length;
  }
  if (keyCode == LEFT) {
    highlighted = (highlighted - 2) % rawArray.length;
    if (highlighted < 0) {
      highlighted = rawArray.length-1;
    }
  }
  if (key == ' ') {
    createOrbs();
  }
}

/////////////////////////////////// OSC CALLBACK FUNCTIONS//////////////////////////////////

public void found(int i) {
  println("found: " + i);
  found = i;
}

public void rawData(float[] raw) {
  println("raw data saved to rawArray");
  rawArray = raw;
}