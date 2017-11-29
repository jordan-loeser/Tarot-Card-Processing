//////////////////////////////////////////////////////////////////////////
//                       //                                             //
//   -~=Manoylov AC=~-   //           Fibonacci In Fibonacci            //
//                       //                                             //
//////////////////////////////////////////////////////////////////////////
//                                                                      //
// Controls                                                             //
//    mouse                                                             //
//       leftClick: redraw with another image                           //
//       rightClick: on/off some of randomization                       //
//////////////////////////////////////////////////////////////////////////
//                                                                      //
// Contacts:                                                            //
//    http://manoylov.tumblr.com/                                       //
//    https://codepen.io/Manoylov/                                      //
//    https://www.openprocessing.org/user/23616/                        //
//    https://www.facebook.com/epistolariy                              //
//////////////////////////////////////////////////////////////////////////

/* @pjs preload="head.png; */

float px, py, r, degree;
float minWeight = 1;
float maxWeight = 4;
float currWeight;
float spacing = maxWeight+2;
float goldenRatio = ((sqrt(5) + 1 ) / 2);
int iter = 0;
boolean smallChaos = false;
PImage img;
boolean fibDone = false;

PGraphics pg; // Variable to draw off screen

void calcPointPos(float x, float y, float r, float graden) {
  px = x + cos(radians(graden))*(r/2);
  py = y + sin(radians(graden))*(r/2);
    if(smallChaos){
    px = x + random(maxWeight)+ cos(radians(graden))*(r/2);
    py = y + random(maxWeight)+ sin(radians(graden))*(r/2);
  }
}