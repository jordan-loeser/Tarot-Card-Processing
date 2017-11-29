/*
 * Play into the idea of fate and randomness. Computer generated "randomness" is interesting
 * because it is not actually random. Do the numbers mean more than just math?
 */
  
/* Audio Package */
import ddf.minim.*;
Minim minim;
AudioInput in;

/* Define Cards */
String[] majorArcana = {"The Fool", "The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Strength", "The Hermit", "Wheel of Fortune", "Justice", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World"};
String fortune;
boolean crazy = false;

/* Define Colors */
color[] neutralPalette = {#FFFBF9, #000000}; // Creme, Black
color[] brightPalete = {#F78B65, #F37F8C, #A9E9B9, #40DDD7}; // Orange, Pink, Grean, Blue
color[] initialPalette = {#F06891, #3E56EB, #F89553, #FE776F, #34D083, #32BDB7}; // Magenta, Lilac, Orange, Peach, Green, Turquoise    // TODO: Split into cool & warm?
color[][] colorPalettes = {initialPalette};
color[] palette;
color c1, c2, c3;

/* Initialize Variables */
int Y_AXIS = 1;
int X_AXIS = 2;
int frameWidth = 20;
PFont f;

// Setup the Artboard
void setup() {

  // Set up Canvas
  f = createFont("Open Sans", 18, true); // Arial, 16 point, anti-aliasing on
  size(500, 700);
  background(#FFFBF9);
  
  // Establish Randomness
  minim = new Minim(this);
  in = minim.getLineIn();
  delay(100);
  randomSeed(round(in.left.get(0)*100));
  
  // Chose Fortune
  fortune = majorArcana[ round(random(0, majorArcana.length - 1)) ];
  crazy = fortune.equals("Wheel of Fortune");
  
  // Image Initialize
  newPalette();
  pg = createGraphics(width, height);
  px = width/4; py = height/4;
  img = loadImage("head.jpg");
  drawFibonnaci();
  
  // Draw Initial Card
  constructCard();
}

void draw() {
  if(crazy) {
     newPalette(); // Create crazy colors on "Wheel of Fortune" card
  }
  constructCard();
  blendMode(MULTIPLY);
  image(pg, 0, 0);
  /*
  pushMatrix();
  translate(width, height);
  rotate(PI);
  image(img, 60, 60);
  popMatrix(); 
  blendMode(NORMAL);
  */
}

void drawFibonnaci() {
    pg.beginDraw();
    pg.blendMode(NORMAL);
    pg.stroke(c2);
    int i = 3000;
    fibDone = false;
    while(!fibDone && i > 0){ // for more speed
      degree = (iter * goldenRatio) * 360;
      r = sqrt(iter++) * spacing;
      calcPointPos(width/2, height/2, r, (degree % 360));
  
      color pix = img.get((int)px, (int)py);
      currWeight = map(brightness(pix), 255, 0, minWeight, maxWeight);
      pg.strokeWeight(currWeight);
      pg.point(px, py);
      if (abs(px-(width/2)) > (width/2) - 10 || px+10<= 0 || px+10 >= width || py-10 <= 0 || py+10 >= height ) { fibDone = true; }
      --i;
    }
    pg.endDraw();
    blendMode(NORMAL);
}

void newPalette() {
  /* Determine Colors */
  palette = colorPalettes[ round(random(0, colorPalettes.length - 1)) ];
  c1 = palette[ round(random(0, palette.length - 1)) ];
  c2 = palette[ round(random(0, palette.length - 1)) ];
  c3 = palette[ round(random(0, palette.length - 1)) ];
}

void constructCard() {
  createBackground();
  addTarot(fortune);
  drawCircularSoundwave();
  addFrame(frameWidth);
}

void createBackground() {
  /* Create Background */
  setGradient(0, 0, width, height/4, c1, c2, Y_AXIS);
  setGradient(0, height/4, width, height/2, c2, c3, Y_AXIS);
  setGradient(0, 3 * height/4, width, height/4, c3, c1, Y_AXIS);
  setCircleLinearGradient(width/2, height/2, 47*width/100, c3, c1, Y_AXIS);
}

void addTarot(String fortune) {
  textFont(f,18);
  fill(#FFFBF9);
  
  int x = frameWidth + 20;
  int y = frameWidth + 20;
  
  pushMatrix();
  translate(x,y);
  rotate(HALF_PI);
  text(fortune.toUpperCase(),0,0);
  popMatrix(); 
  
  x = width - frameWidth - 20;
  y = height - frameWidth - 20;
  
  pushMatrix();
  translate(x,y);
  rotate(-1 * HALF_PI);
  text(fortune.toUpperCase(),0,0);
  popMatrix(); 
}

void addFrame(int thickness) {
  strokeWeight(thickness);
  noFill();
  stroke(#FFFBF9);
  rect(thickness/2, thickness/2, width - thickness, height - thickness);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
  blendMode(NORMAL);
  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
  blendMode(NORMAL);
}

void setCircleLinearGradient(int x, int y, float radius, color c1, color c2, int axis ) {
  noFill();
  blendMode(NORMAL);
  if(x == 0) {
    x = width / 2;
  }
  if(y == 0) {
    y = height / 2;
  }
  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (float r = -PI/2; r <= PI/2; r+=0.005) {
      float inter = map(r, -PI/2, PI/2, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      strokeWeight(3);
      float xRad = cos(r)*radius;
      float yRad = sin(r)*radius;
      line(x+xRad, y+yRad, x-xRad, y+yRad);
    }
  }  

  else if (axis == X_AXIS) {  // Left to right gradient
    for (float r = 0; r <= PI; r+=0.005) {
      float inter = map(r, 0, PI, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      strokeWeight(3);
      float xRad = cos(r)*radius;
      float yRad = sin(r)*radius;
      line(x+xRad, y-yRad, x+xRad, y+yRad);
    }
  }
  blendMode(NORMAL);
}

void drawCircularSoundwave() {
  strokeWeight(3);
  blendMode(NORMAL);
  stroke(#FFFFFF);
  int x = width/2;
  int y = height/2;
  int bufferPiece = in.bufferSize() / 360;
  float amplitude = random(50,800);
  for(int deg = 0; deg < 180; deg++) {
      float radius = (40*width/100) + in.left.get(deg+bufferPiece) * amplitude;
      float rad = radians(deg);
      float nextRad = radians(deg+1);
      line(x + radius * cos(rad), y + radius * sin(rad), x + radius * cos(nextRad), y + radius * sin(nextRad));
      line(x - radius * cos(rad+PI), y + radius * sin(rad+PI), x - radius * cos(nextRad+PI), y + radius * sin(nextRad+PI));
  }
  blendMode(NORMAL);
}