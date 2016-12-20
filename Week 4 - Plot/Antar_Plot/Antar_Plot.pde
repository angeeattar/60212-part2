import processing.pdf.*;
boolean bRecordingPDF;
int pdfOutputCount = 0; 
int myRandomSeed = 5; // golan's favorite number
float snuggle = 1.7;
float lineCount = 50;
float R = 115;
float xs[];
float ys[];

class circ {
  float x;
  float y;
  float r;
  void render() {
    ellipse (x, y, r*2, r*2);
  }

  circ(float inx, float iny, float inr) {
    x = inx; 
    y = iny; 
    r = inr;
  }
}

ArrayList<circ> myCircs; 

void setup() {
  size(800, 800);
  bRecordingPDF = false;

  myCircs = new ArrayList<circ>();
  float x = random(width);
  float y = random(height);
  float r = R;
  circ aCirc = new circ(x, y, r);

  myCircs.add(aCirc);

  xs = new float[10]; 
  ys = new float[10];
  populateCircArray();
}

void keyPressed() {
  // When you press a key, it will initiate a PDF export
  if (key == ' ') {
    myRandomSeed = millis(); 
    populateCircArray();
  } else if (key == 'p') {
    bRecordingPDF = true;
  }
}

void draw() {
  
  randomSeed(myRandomSeed); 
  background(255); // this should come BEFORE beginRecord()
  if (bRecordingPDF) {
    String uniqueStamp = day() + "_" + hour() + "_" + minute() + "_" + second(); 
    //beginRecord(PDF, "Antar_" + pdfOutputCount + ".pdf");
    beginRecord(PDF, "Antar_" + uniqueStamp + ".pdf");
  }

  //--------------------------
  noFill();
  int nCircs = myCircs.size();
  for (int i = 0; i < nCircs; i++) {
    circ aCirc = myCircs.get(i);
    //aCirc.render();
    drawBeanInCirc(aCirc);
  }
  findColour();

  //--------------------------
  if (bRecordingPDF) {
    endRecord();
    bRecordingPDF = false;
    saveFrame("Antar_" + pdfOutputCount + ".png");
    pdfOutputCount++;
  }
}
void findColour() {
  for (int i=0; i<lineCount; i++) {
    int rx = (int)random(0, width);
    int ry = (int)random(0, height);
    //int rx = mouseX;
    //int ry = mouseY;
    color c = get(rx, ry);
    if (c == -8996) {
      noFill();
      line(rx, ry, rx+random(-10, 10), ry+random(-10, 10) ); //hairy beans
      //pushMatrix() ;
      //translate(rx, ry);
      //rotate ( radians(random(360))); 
      //ellipse(0, 0, random(10, 50), random(10, 60) ); //spotted beans
      //popMatrix();
    }
  }
}

void populateCircArray() {
  myCircs.clear(); 
  for (int i=0; i<100000; i++) {
    float probex = random(width);
    float probey = random(height);
    int nCircs = myCircs.size();
    boolean bTooClose = false;

    // Check probex and proby against every previous circle 
    // to make sure it's not too close to any of them. 
    for (int c=0; c<nCircs; c++) {
      circ cthCirc = myCircs.get(c);
      float d = dist(probex, probey, cthCirc.x, cthCirc.y);
      float vertR = R + probey;
      float horzR = R + probex;
      if (d < (snuggle*R)) {
        bTooClose = true;
      }
    }

    // Check that probex and probey are not too close to the borders.
    if ((probex < R) || (probex > (width - R)) || (probey < R) || (probey > (height -R))) {
      bTooClose = true; // we're too close to the edge
    }

    if (bTooClose == false) {
      circ newCirc = new circ(probex, probey, R);
      myCircs.add(newCirc);
    }
  }
}


void drawBeanInCirc(circ aCirc) {
  float bx = aCirc.x;
  float by = aCirc.y;

  float magnify = aCirc.r;
  float x = 0;
  float y = 0;
  int nPoints = 5; 

  for (int i=0; i<nPoints; i++) {
    float t = map(i, 0, nPoints, 0, TWO_PI); // creating spokes
    float r = random(0.45, 1.0); 
    x = magnify * r*cos(t);
    y = magnify * r*sin(t); 
    xs[i] = x; // storing spokes
    ys[i] = y;
    noFill();
  }
  pushMatrix();
  translate(bx, by);

  float originX = bx;
  float originY = by;

  bx = 400;
  by= 400;

  beginShape();
  float frac = 0.5; 

  vertex(xs[0], ys[0]);

  for (int i=0; i<nPoints; i++) {

    float x0 = xs[i]; 
    float y0 = ys[i]; 

    float dx0 = 0-ys[i]*frac; 
    float dy0 =  xs[i]*frac; 

    float x1 = x0 + dx0; 
    float y1 = y0 + dy0; 

    float x3 = xs[(i+1)%nPoints];
    float y3 = ys[(i+1)%nPoints];

    float dx3 =   ys[(i+1)%nPoints]*frac; 
    float dy3 = 0-xs[(i+1)%nPoints]*frac; 

    float x2 = x3 + dx3; 
    float y2 = y3 + dy3;


    fill(255, 220, 220);
    bezierVertex(x1, y1, x2, y2, x3, y3);
  }

  endShape(CLOSE);

  popMatrix();
}