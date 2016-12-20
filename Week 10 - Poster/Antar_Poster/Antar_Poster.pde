import processing.pdf.*;
import geomerative.*;
boolean bRecordingPDF;
int pdfOutputCount = 0; 

PFont univers;
PFont space;
String text =  "StudioforCreativeInquiry";

RFont f;
RShape grp;
RShape grp1;
RPoint[] points;
RPoint[] points1;

int myRandomSeed = 5;

boolean go;

///////  SPIRAL
float r;
float theta;
float a;
float n;
float inc;
float coil;

///////  GLITCH
int step;
int Xoff, Yoff;
int startGlitch;
int endGlitch;
int count;

////// GRADIENT

int gradientX1;
int gradientY1;
int gradientX2;
int gradientY2;

color c1, c2;
int cH1, cH2;
int colourOff;


////// INTERACTION
float titleX1;
float titleX2;
float titleY1;
float titleY2;
color c;
int colourOpp;


void setup() {

  size(600, 900);

  bRecordingPDF = false;

  RG.init(this);

  noStroke();
  smooth(); 
  colorMode(RGB, 255, 255, 255);
  background(255);

  //////  TYPOGRAPHY
  space = createFont("assets/SpaceMono-Regular.ttf", 12);
  univers = createFont("assets/UniversLTStd-BoldCn.otf", 16);
  textFont(space);
  text = text.toUpperCase();

  grp = RG.getText("INTERACTIVITY", "DIN_Alternate_Bold.ttf", 72, CENTER);
  grp1 = RG.getText("& COMPUTATION", "DIN_Alternate_Bold.ttf", 72, CENTER);
}

void keyPressed() {
  // When you press a key, it will initiate a PDF export
  if (key == ' ') {
    cH1 = int(random(40, 300));

    gradientX1 = int(random(0, 200));
    gradientY1 = int(random(0, 200));
    gradientX2 = int(random(500, 600));
    gradientY2 = int(random(700, 800));

    colourOff = (int(random(40, 60)));
    colourOpp = (int(random(100, 200)));

    count = int(random(2, 5));
    step = int(random(10, 100));

    titleX1 = random(1.8, 2.5);
    titleY1 = random(.7, 3);
    titleX2 = titleX1 + random(-0.3, 0.5);
    titleY2 = titleY1 + random(0.1, 0.4);
  } 
  //if (key == 'g') {
  //stroke()
  //grid();
  //}
  if (key == 'p') {
    bRecordingPDF = true;
  }
}

void draw() {

  if (bRecordingPDF) {
    beginRecord(PDF, "Antar_" + pdfOutputCount + ".pdf");
  }
  myRandomSeed = millis(); 
  background(255);

  //spiral();
  //star();
  //rotateLetter();
  //title();

  colourPicker();

  interaction(grp, points, titleX1, titleY1, c1);
  interaction(grp1, points1, titleX2, titleY2, c2);

  for (int i=0; i<count; i++) {
    glitch();
  }
  //
  if (bRecordingPDF) {
    endRecord();

    saveFrame("Antar_" + pdfOutputCount + ".tif");
    pdfOutputCount++;
    bRecordingPDF = false;
  }
}


void glitch() {
  startGlitch = int(random(height-step));
  endGlitch = startGlitch+step;
  for (int row=0; row<height; row++) {
    for (int col=0; col<(width); col++) {
      if (row > startGlitch && row < endGlitch) {
        pushMatrix();
        Xoff = int(random(1, 10));
        Yoff = int(random(1, 100));
        int colourX = col+Xoff;
        int colourY = row+Yoff;
        if (colourX>=width) colourX = col-Xoff;
        if (colourY>=height) colourY = row-Yoff;
        color colour = get ( colourX, colourY );
        stroke(colour); 
        strokeWeight(1); 
        //strokeCap(ROUND);
        point(col, row); 
        //set(col, row, colour);
        updatePixels();
        popMatrix();
      }
    }
  }
}


void colourPicker() {
  colorMode(HSB, 360, 100, 100);
  //randomSeed(myRandomSeed);
  if ((cH1 % 2)== 0) {
    cH2 = cH1-colourOff;
  } else {
    cH2 = cH1+colourOff;
  }

  c1 = color(cH1, 80, 90);
  c2 = color(cH2, 80, 90);

  //setGradient(x, y, w, h, c1, c2);
  setGradient(gradientX1, gradientY1, gradientX2, gradientY2, c1, c2);
}

void setGradient(int x, int y, float w, float h, color c1, color c2) {
  //noFill();
  for (int j = 0; j <= height; j++) {
    float inter = map(j, 0, height, 0, 1);
    color c = lerpColor(c2, c1, inter);
    stroke(c);
    line(0, j, width, j);
  }
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}

void interaction(RShape grp, RPoint[] points, float x, float y, color cB) {
  pushMatrix();

  translate(width/x, y*height/4);

  // Draw the group of shapes
  noFill();
  noStroke();
  RG.setPolygonizer(RG.ADAPTATIVE);
  grp.draw();

  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(map((random(0, 1)), (random(0, 1)), height, 3, 200));
  points = grp.getPoints();

  // If there are any points
  if (points != null) {
    for (int i=0; i<points.length; i++) {
      float pointX = points[i].x + random(-1, 1);
      float pointY = points[i].y + random(-1, 1);
 
      c = cB-colourOpp; 

      fill(c);
      stroke(c);
      ellipse(pointX, pointY, 1, 1);
    }
  }
  popMatrix();
}