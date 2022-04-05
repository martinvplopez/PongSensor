import processing.sound.*;
//import gifAnimation.*;
import processing.serial.*;


int D=20;

int size1 = 1200;
int size2 = 800;

int thresholdMin=345;
int thresholdMax=545;

int posX=size1/2;
int posY=size2/2;

int ancho=20;
int alto=80;

int movX=5;
int movY=int(random(-3,3));

int golPlayer1=0;
int golPlayer2=0;

int player1X= 50;
int player1Y= size2/2-30;

int player2X= size1 - 80;
int player2Y= size2/2 - 30;
  
String state = "INTRO";

SoundFile  sonido;
SoundFile  music;
SoundFile  sound2;

int count = 0;

Serial myPort;
String comPortString;

int val;
//GifMaker gif;
int gifCount = 0;



void setup(){
  size(1200,800);
  sonido = new SoundFile(this,"Alesis-Fusion-Bass-C3.wav");
  music = new SoundFile(this,"Casio-MT-45-Disco.wav");
  sound2 = new SoundFile(this,"Casio-CZ-5000-Synth-Bass-C1.wav");
  thread("music");

  myPort = new Serial(this,"COM5", 9600);
  myPort.bufferUntil('\n');
  
  //gif = new GifMaker(this, "pong.gif");
  //gif.setRepeat(0);
}

void gif(){
  if(gifCount % 5 == 0 ){
    //gif.addFrame();
    
  }
  if(gifCount > 1000){
     //gif.finish(); 
  }
  gifCount++;
}

void score(){ 
  background(0);
  posX=width/2;
  posY=height/2;
  ellipse(posX,posY,D,D); 
}


void draw(){
  
  switch(state){
    case "INTRO":
      intro();
      break;
    case "GAME":
      game();

      break;
    case "PAUSE":
      pause();
      break;
    case "VICTORY":
      victory();
      break;
  }
  key();

  //gif();
}

void intro(){
  background(0);
  textSize(60);
  text("WELCOME TO PONG REMASTERED!", width/2-500, height/2-300);
  textSize(15);
  text("DISCLAIMER: we didn't actually remaster anything", width/2-180, height/2-280);
  textSize(36);
  text("CONTROLS:", width/2-250, height/2-150);
  textSize(31);
  text("- Player1      W       S", width/2-180, height/2-100);
  text("- Player2      UP     DOWN", width/2-180, height/2-60);
  text("- Pause        TAB", width/2-180, height/2-20);
  textSize(36);
  text("RULES:", width/2-250, height/2+60);
  textSize(31);
  text("- The first to get to 7 POINTS wins", width/2-180, height/2+100);
  text("- That's literally all...", width/2-180, height/2+140);
  textSize(50);
  text("Press ENTER to start", width/2-250, height/2+300);
  
  
  
  
}



void pause(){
  
  rect(width/2-38, height/2-50, 30, 100);
  rect(width/2+8, height/2-50, 30, 100);
  
  
  textSize(50);
  text("Press ENTER to CONTINUE", width/2-320, height/2+150);
  
  
}

void victory(){
  background(0);
  textSize(100);
  if(golPlayer1 == 7){
    text("Player 1 WINS!",width/2-350, height/2-50);
  }else{
    text("Player 2 WINS!",width/2-350, height/2-50);
  }
  textSize(50);
  text("Press ENTER to return to the main menu", width/2-480, height/2+150);
  golPlayer1 = 0;
  golPlayer2 = 0;
  
}

void key() {
  if(keyPressed){
    if (key == CODED) {
      if (keyCode == UP) {
        if(player2Y > 0){
          player2Y = player2Y -8;
        }
      } else if (keyCode == DOWN) {
        if(player2Y < height - alto){
          player2Y = player2Y +8;
        }
      }
    }
     if(key == ENTER){
      if(state == "VICTORY"){
        state = "INTRO";
      }else if(state == "INTRO" || state == "PAUSE"){
        state = "GAME";
      }
     }
    if(key == TAB){
      state = "PAUSE";
    }
    
    if ((key == 'W') || (key == 'w')) {
      if(player1Y > 0){
        player1Y = player1Y -8;
      }
    } else  if ((key == 'S') || (key == 's')) {
      if(player1Y < height - alto){
        player1Y = player1Y +8;
      }  
    }
  }
}

void game(){
  background(0);
  ellipse(posX,posY,D,D);
  
  stroke(255);
  line(width/2, 0, width/2, height);

  //Donde se encuentra el jugador
  
  rect(player2X,player2Y,ancho,alto);
  
  
  rect(player1X,player1Y,ancho,alto);
  
  
  
  posX=posX+movX;
  posY=posY+movY;
  //verificando si hay choque
  if (posX>=width || posX<=0 || posY >=height || posY<=0 || (movX>0 && player2Y<=posY+D/2 && posY-D/2<=player2Y+alto && player2X<=posX+D/2 && posX-D/2<=player2X+ancho) || (movX<0 && player1Y<=posY+D/2 && posY-D/2<=player1Y+alto && player1X<=posX+D/2 && posX-D/2<=player1X+ancho))
  {
    if(posY >=height || posY<=0 ){
      movY=-movY;
      thread("rebote");
    }else if(posX>=width || posX<=0){
      if (movX > 0){
        movX=-movX - 1; 
      }else{
        movX=-movX + 1;      
      }
    }else{
      movY=-int(random(-3,3));
      thread("rebote");
      if (movX > 0){
        movX=-movX - 1; 
      }else{
        movX=-movX + 1;      
      }
    }
    
    

    if  (posX>=width)
    {
      thread ("Sound"); 
      golPlayer1=golPlayer1+1;
      movX = -5;
      score();
    }
    
    if  (posX<=0)
    {
      thread ("Sound"); 
      golPlayer2=golPlayer2+1;
      movX = 5;
      score();
      
    }
  }
  textSize(100);
  text(""+golPlayer2, width/2+270, 100);
  text(""+golPlayer1, width/2-330, 100);
  
  textSize(50);
  //if(golPlayer1 > 0 || golPlayer2 > 0){
  //  text("GULAAAZO", width/2-130, height-50);    
  //}
  if(golPlayer1 == 7 || golPlayer2 == 7){
    state = "VICTORY";
  } 
}

void mapping(){
  val=myPort.read();
  println(val);
  
}

void serialEvent(Serial cPort){
  comPortString = cPort.readStringUntil('\n');
    if (comPortString!= null){
      comPortString = trim(comPortString);
    }
    if(count == 10){
      count = 0;
//    println(comPortString);
    val = int(comPortString);
    println(val);
    if(val<=thresholdMin){
      player2Y=0;
    }else if(val>=thresholdMax){
      player2Y=height-alto;
    }else{
      player2Y = (val-thresholdMin)*(height/(thresholdMax-thresholdMin));
    }
   }
   count++;
}

void Sound(){
  sonido.amp(0.3);
  sonido.play();
}

void music(){
  music.amp(0.1);
  music.loop();
}

void rebote(){
  sound2.amp(0.05);
  sound2.play();
}
