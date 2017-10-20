import processing.video.*;

Movie movie;
Movie back;

PImage [] reference = new PImage[2];
PImage target;

boolean colourCorrecting = false; 
int currentReference = -1;

float [] m, sd;

void setup() {
  size( 1280, 720 );
  movie = new Movie(this, "output.mp4");
  
  //a,b
  back = new Movie(this, "BG.mp4");
  
  //c
  //back = new Movie(this, "Mountains-FullHD.mp4");
  
  reference[0] = loadImage("spectrum-blue-green.png");
  reference[1] = loadImage("spectrum-green-red.png");
  
  //a
  //target  = createImage(reference[0].width, reference[0].height, RGB);
  
  //b,c
  target  = createImage(160, 90, ARGB);
  
  movie.loop();
  back.loop();
}


void draw() {
    if (movie.available()) {
    back.read();
    image(back, 0, 0, 640, 360);
    movie.read();
    if (colourCorrecting) {
      applyScalingsFromTo(reference[currentReference], target);
    }
  }
  image(reference[0], 0, 360);
  image(reference[1], 640, 360);
  
  //a
  //image(target, 640, 0); target.set(0, 0, back);
   
  //b,c
  image(back, 640, 0, 640, 360);
   
  
  
  PImage newImage = createImage( movie.width, movie.height, ARGB );
  image( newImage, 100, 100, 160, 90 );
  
  //a
  //image( newImage, 740, 100, 160, 90 );
  
  
  movie.loadPixels();
  newImage = createImage( movie.width, movie.height, ARGB );
  for (int x = 0; x < movie.width; x ++ ) {
    for (int y = 0; y < movie.height; y ++ ) {
      int loc = x + y*movie.width; 
      color fgColor = movie.pixels[loc]; 
      color bgColor = color(23, 163, 76, 0);
      
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1,g1,b1,r2,g2,b2);
     
      if (diff > 95) {
        newImage.pixels[loc] = fgColor;
      } else {   
        newImage.pixels[loc] = color( 0, 0, 0, 0 );
      }
    }
  }
  
   image( newImage, 100, 100, 160, 90 );
   //a
   //image( newImage, 740, 100, 160, 90 );
   
   //b,c
   image(target, 740, 100);
   target.set(0, 0, newImage);
   
   println(movie.frameRate);
}

void mousePressed() {
  colourCorrecting = true;
  currentReference = (currentReference + 1 ) % 2;
}