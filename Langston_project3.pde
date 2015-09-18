//Constants
import ddf.minim.*;
Minim minim;
AudioSnippet snip;
int nextTime = 1000;
int programState = 0;  // When program is in state 0 the star is moving back and forth at top of screen. When state is 1 the star is dropping 
PImage backgroundImage;
PFont f;
int score = 0;
String scoreString;
float gravity = 0.2;
Star mainStar;
ScoreArc mainScorer;
Bumper[] bumpers = new Bumper[10];


class Star {
  PImage starImage;
  String starImageFile = "star.png";
  float xPos, yPos;
  float xSpeed, ySpeed;
  
  Star() {
     starImage = loadImage(starImageFile); 
     xSpeed = 0;
  }
  
  void display()
  {
    imageMode(CENTER);
    image(starImage, xPos, yPos, 65, 65);
  }
  
  void start() {
    yPos = 100;
    xPos = 200+(625/2)+(625/2)*sin(frameCount/90.0);
    
    if (mousePressed)
      programState = 1;
  }
  
  void drop() {
    ySpeed += gravity;
    
    for(int i=0; i < bumpers.length; i++)
    {
      float dx = xPos - bumpers[i].xPos;
      float dy = yPos - bumpers[i].yPos;
      float distance = sqrt(dx*dx + dy*dy);
      
      
      if (distance < 40)
      {
        xSpeed = dx * .14;
        ySpeed = dy * .14;
      }
      
      
    }
    
    // Moves star
    xPos += xSpeed;
    yPos += ySpeed;
    
    // Calculates the score
    float distanceToScorer = sqrt(pow(xPos-mainScorer.xPos, 2) + pow(yPos-mainScorer.yPos, 2));
    if (distanceToScorer < 70)
      score += 1;
    
    // Catches the star at bottom of screen
    if(yPos > 800)
    {
      xSpeed = 0;
      ySpeed = 0;
      programState = 0;
    }
  }

  
}


class Bumper {
  float xPos, yPos;
  float width, height;
  
  Bumper(float xPosition, float yPosition)
  {
     xPos = xPosition;
     yPos = yPosition;
     width = 63;
     height = 63;
  }
  
  void display()
  {
    ellipse(xPos, yPos, width, height);
  }
  
}

class ScoreArc {
  float xPos, yPos;
  float width, height;
  
  ScoreArc()
  {
    xPos = 510;
    yPos = 750;
    width = 100;
    height = 100;
  }
  
  void display()
  {
    arc(xPos, yPos, width, height, PI, TWO_PI);
  }
}



void setup() {
  
  size(1024, 768);
  backgroundImage = loadImage("StarDropperBackground.jpg");
  minim = new Minim(this);
  snip = minim.loadSnippet("arcade_music.mp3");
  snip.loop();
  mainStar = new Star();
  mainScorer = new ScoreArc();
  ellipseMode(CENTER);
  f = createFont("Arial",32,true);
  bumpers[0] = new Bumper(515, 394);
  bumpers[1] = new Bumper(513, 239);
  bumpers[2] = new Bumper(209, 238);
  bumpers[3] = new Bumper(210, 395);
  bumpers[4] = new Bumper(815, 238);
  bumpers[5] = new Bumper(815, 394);
  bumpers[6] = new Bumper(364, 314);
  bumpers[7] = new Bumper(363, 477);
  bumpers[8] = new Bumper(678, 314);
  bumpers[9] = new Bumper(677, 478);
  

}

void draw() {
  imageMode(CORNER);
  image(backgroundImage, 0, 0);
  textFont(f, 32);
  fill(0);
  scoreString = "Score: " + score;
  text(scoreString, 470, 600);
  noStroke();
  noFill();
  mainScorer.display();
  for(int i=0; i < bumpers.length; i++)
  {
    bumpers[i].display();
  }
  fill(255);
  if (programState == 0)
  {
    mainStar.start();
    mainStar.display();
  }
  else if (programState == 1)
  {
    mainStar.drop();
    mainStar.display();
  }

}
void state(){
  if(keyPressed == true && key == 'b'){
    mainStar.xPos += random(-10,10);
    mainStar.yPos += random(-10,10);
  }
}
void stop() {
  snip.close();
  minim.stop();
  super.stop();
}
