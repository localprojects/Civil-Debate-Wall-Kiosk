import TUIO.*;
import java.util.*;
TuioProcessing tuioClient;

 int ht = 1350
 ;

import processing.video.*;
Capture myCapture;

import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import org.json.*;
import java.util.*;

MySQL msql;
DbData dbData;
DbQueries dbQueries;

String request = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/twilio/allChoices/";
String request_latest = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/twilio/latestChoice/";
String image_path = "data/";

PFont fontSlide;

int startingTime;
int startingTime_capture;

boolean show_video = false;

// TUIO
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;
// -----
PImage slide[];
PImage sil;
PImage just_captured;

float touchX = 0.0;
float touchMiniX = 0.0;
int selectedSlide = 0;
int touchPrev = 0;

PVector lastPos;
int dragging = -1;

// global for big slide
boolean turnRight = false;
boolean turnLeft = false;
int picLowerLimit;
int picUpperLimit;

int prevPic;
int currentPic;
int nextPic;
int picIncrement = 3;
String[] txt_display = new String[3]; 
boolean image1_exists;
boolean image2_exists;
boolean image3_exists;
boolean image_freeze_exists;
// Ani
import de.looksgood.ani.*;
Ani aniX;

PImage vote_1, vote_2, vote_3, vote_4, vote_5;
PImage vote_1_small, vote_2_small, vote_3_small, vote_4_small, vote_5_small;
PImage sticker, scoreboard_circle, base;

HashMap<String, PImage> images;
     
PFont font_25;
PFont font_12, font_18, font_15;

PVector iconCoords[] = new PVector[5];
PVector draggedIconPos[] = new PVector[5];

void setup()
{
  size(768,1366); // 400 600// 600 x 337
  noStroke();
  fill(0);
  loop();
  frameRate(30);
  
  slide = new PImage[3];
  lastPos = new PVector(0,0);
  images = new HashMap<String, PImage>();
  
  iconCoords[0] = new PVector(130, 1215);
  iconCoords[1] = new PVector(250, 1215);
  iconCoords[2] = new PVector(390, 1215);
  iconCoords[3] = new PVector(510, 1215);
  iconCoords[4] = new PVector(630, 1215);
  
  for(int i =0; i < 5; i++)
    draggedIconPos[i] = new PVector(0,0);
 
      vote_1 = loadImage("vote_1.png");
     
      vote_2 = loadImage("vote_2.png");
      
      vote_3 = loadImage("vote_3.png");
      
      vote_4 = loadImage("vote_4.png");
     
      vote_5 = loadImage("vote_5.png");
      

  String[] jsondata = loadStrings(request);
  String[] jsondataLatest = loadStrings(request_latest);

  if(jsondata == null || jsondataLatest == null) {
    exit();
    return;
  }

  dbQueries = new DbQueries(msql);
  dbData = dbQueries.getData(this, jsondata);
  dbQueries.getNewChoice(this, dbData, jsondataLatest);

  dbData.latest_id_in_comp = dbData.latest_id_from_web;

  //println(dbData.total_comments);

  for(int j = 0; j < dbData.total_comments; j++) {
    println(dbData.id[j]);
    println(dbData.txt[j]);
  }

  picLowerLimit = dbData.id[0];
  picUpperLimit = dbData.id[dbData.total_comments-1];
  currentPic = dbData.id[picIncrement];
  startingTime = millis();
  
  
      font_25 = loadFont("ArialMT-25.vlw"); 
      font_12 = loadFont("Gautami-12.vlw");
      font_18 = loadFont("ArialMT-18.vlw");
      font_15 = loadFont("ArialMT-15.vlw");

  // TUIO 
  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Arial", 18);
  scale_factor = height/table_size;
  tuioClient  = new TuioProcessing(this, 3334);

  prevPic = dbData.id[picIncrement-1];
  nextPic = dbData.id[picIncrement+1];


  
  File image1 = new File(image_path + prevPic+".png");
  image1_exists = image1.exists();

  File image2 = new File(image_path + currentPic+".png");
  image2_exists = image2.exists();

  File image3 = new File(image_path + nextPic+".png");
  image3_exists = image3.exists();  

  if(image1_exists == true) slide[0] = loadImage(prevPic+".png");
  else slide[0] = loadImage("avatar.png");

  if(image2_exists == true) slide[1] = loadImage(currentPic+".png");
  else slide[1] = loadImage("avatar.png");

  if(image3_exists == true) slide[2] = loadImage(nextPic+".png");
  else slide[2] = loadImage("avatar.png");
  

  fontSlide = loadFont("Serif-28.vlw");

  Ani.init(this);
  aniX = Ani.to(this, 1.0, "touchX", -0);

  myCapture = new Capture(this, 1555,1166, 20);
  myCapture.crop(393, 0, 768, 1366);
  
  //sil = loadImage("");
}

void load_image() {
  
    File image1a = new File(image_path + prevPic+".png");
    image1_exists = image1a.exists();
    if(currentPic != picLowerLimit) {
      if(image1_exists == true) slide[0] = loadImage(prevPic+".png");
      else slide[0] = loadImage("avatar.png");
    }

    File image2a = new File(image_path + currentPic+".png");
    image2_exists = image2a.exists();
    if(image2_exists == true) slide[1] = loadImage(currentPic+".png");
    else slide[1] = loadImage("avatar.png");

    File image3a = new File(image_path + nextPic+".png");
    image3_exists = image3a.exists();  
    if(currentPic != picUpperLimit) {
      if(image3_exists == true) slide[2] = loadImage(nextPic+".png");
      else slide[2] = loadImage("avatar.png");
    }
  
}  

void reload() {
  String[] jsondata = loadStrings(request);
  if(jsondata == null)  println("request failed. falling back to cached data.");
  else {
    println("requesting new data..."); 
    dbQueries.getData(this, jsondata);    
    dbData.latest_id_in_comp = dbData.latest_id_from_web;
    picUpperLimit = dbData.id[dbData.total_comments-1];
    println("picUpperLimit = "+picUpperLimit);
  }
}

void reload_latest() {

  String[] jsondataLatest = loadStrings(request_latest);  
  if(jsondataLatest == null)  println("request failed. falling back to cached data.");
  else {
    println("requesting new data...");   
    dbQueries.getNewChoice(this, dbData, jsondataLatest);


    println("dbData.latest_id_from_web = "+dbData.latest_id_from_web);
    println("dbData.latest_id_in_comp = "+dbData.latest_id_in_comp);

    if(dbData.latest_id_from_web > dbData.latest_id_in_comp) {      
      dbData.latest_id_in_comp = dbData.latest_id_from_web;
      show_video = true;
      startingTime_capture =  millis();
    }
  }
}


void captureEvent(Capture myCapture) {
  myCapture.read();
}

void draw()
{
  background(0);

  if ((millis() - startingTime) > 5000 && show_video == false) {

    reload();
    reload_latest();    

    startingTime = millis();
      
  }  

  // TUIO
  //textFont(font,18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  Vector tuioObjectList = tuioClient.getTuioObjects();
  for (int i=0;i<tuioObjectList.size();i++) {
    TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);
  }

  Vector tuioCursorList = tuioClient.getTuioCursors();
  for (int i=0;i<tuioCursorList.size();i++) {
    TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
    Vector pointList = tcur.getPath();
    if (pointList.size()>0) {
      stroke(0,0,255);
      TuioPoint start_point = (TuioPoint)pointList.firstElement();
      for (int j=0;j<pointList.size();j++) {
        TuioPoint end_point = (TuioPoint)pointList.elementAt(j);
        start_point = end_point;
      }
    }
  }

  // Our Code Starts here

  if(aniX.isPlaying()) {
  }   
  else if(turnLeft == true && picIncrement < dbData.total_comments-1) {

    turnLeft = false;
    picIncrement += 1;
    currentPic = dbData.id[picIncrement];
    
    for(int i = -1; i < 2; i++)
    { 

      int num = picIncrement+i;
      
      if(images.containsKey(dbData.id[num]))
        slide[i] = images.get(dbData.id[num]);
      else
      {
        File image1 = new File(image_path + dbData.id[num]+".png");
        boolean exists = image1.exists();
        if( (i == -1 && currentPic != picLowerLimit) || (i == 1 && currentPic != picUpperLimit) || i ==0) 
        {
          if(exists == true) slide[i+1] = loadImage(dbData.id[num]+".png");
          else slide[i+1] = loadImage("avatar.png");
          images.put(""+prevPic, slide[i+1]);
        }
      }
      
    }
    
    touchX = 0;
    
  }  

  else if(turnRight == true && picIncrement > 0) {

    turnRight = false;
    picIncrement -= 1;
    currentPic = dbData.id[picIncrement];
    
    for(int i = -1; i < 2; i++)
    { 

      int num = picIncrement+i;
      if(num < 0) num = 0;
      
      if(images.containsKey(dbData.id[num]))
        slide[i] = images.get(dbData.id[num]);
      else
      {
        File image1 = new File(image_path + dbData.id[num]+".png");
        boolean exists = image1.exists();
        if( (i == -1 && currentPic != picLowerLimit) || (i == 1 && currentPic != picUpperLimit) || i ==0) 
        {
          if(exists == true) slide[i+1] = loadImage(dbData.id[num]+".png");
          else slide[i+1] = loadImage("avatar.png");
          images.put(""+prevPic, slide[i+1]);
        }
      }
      
    }

    touchX = 0;
  }     


  // TEXT LOADING
  if(currentPic != picLowerLimit) txt_display[0] = dbData.txt[picIncrement-1];
  else txt_display[0] = "";

  txt_display[1] = dbData.txt[picIncrement];

  if(currentPic < picUpperLimit) txt_display[2] = dbData.txt[picIncrement+1];
  else txt_display[2] = "";


  //println("picIncrement = "+picIncrement);

  textFont(fontSlide, 32);

  fill(255);
  
  if(currentPic != picLowerLimit) {
    //tint(205,112,84,185);
    image(slide[0],touchX-768,200,768,1166);
   // filter(GRAY);
    noTint();
    text("\""+txt_display[0]+"\"",touchX-768+50,40, 650, 170);
  }
  //tint(205,112,84,185);
  image(slide[1],touchX,200,768,1166);
 // filter(GRAY);
  noTint();
  text("\""+txt_display[1]+"\"",touchX+50,40, 650, 170);
  //text("The question concerns a 'thorough education', yet both the 'yes' and the 'no' answers concern preparation for jobs. Not the same thing!",touchX+50,40, 650, 170);

  if(currentPic != picUpperLimit) {
    tint(205,112,84,185);
    image(slide[2],touchX+768,200,768,1166);
    noTint();
    text("\""+txt_display[2]+"\"",touchX+768+50,40, 650, 170);
  }
  
  noFill();

// interface

      noStroke();
      fill(25);
      rect(0, (ht -135), 768, 150);

      if(dragging == 0)
        image(vote_1, draggedIconPos[0].x, draggedIconPos[0].y);
      else
        image(vote_1, 160, (ht -125));

      if(dragging == 1)
        image(vote_2, draggedIconPos[1].x, draggedIconPos[1].y);
      else
        image(vote_2, 274, (ht -110));

      if(dragging == 2)
        image(vote_3, draggedIconPos[2].x, draggedIconPos[2].y);
      else
        image(vote_3, 408, (ht -116));

      if(dragging == 3)
        image(vote_4, draggedIconPos[3].x, draggedIconPos[3].y);
      else
        image(vote_4,  535, (ht -102));

      if(dragging == 4)
        image(vote_5, draggedIconPos[4].x, draggedIconPos[4].y);
      else
        image(vote_5, 637, (ht -114));

      textFont(font_25); 
      String s = "Drag a sticker to vote";
      textAlign(CENTER);
      fill(255);
      text(s, 35, ht-100, 80, 150);//, 1150, 610, 150, 150);
      
      textFont(font_15); 
      textAlign(CENTER);
      fill(255);
      text("Bright Idea!", 192, ht);
      text("I Agree!", 319, ht);
      text("Well Said!", 450, ht);
      text("Good Point!", 565, ht);   
      text("I disagree!",  680, ht); 



  // SHOW VIDEO

  if(show_video == true) {
    //translate(width,0);
    //rotate(1.570);
    fill(29,29,27);
    rect(0,0,768,200);
    noFill();
    image(myCapture, 0, 200, 768, 1166);
    fill(255);
    text("Please align yourself.",260,100);
    text("SKIP PICTURE",260,600);
    
    int te = millis() - startingTime_capture;
    te = te-10000;
    te = te * -1;
    String te_str;
    te_str = str(te);
    //te_str = ;
    if(te>999) text(te_str.charAt(0), 20,400);
    noFill();
    
    
    // Place Siluotte here
    
    fill(29,29,27,50);
    rect(50,300,200,200);
    noFill();
    if ((millis() - startingTime_capture) > 10000) {
      String temp_save_name = "data/"+str(dbData.latest_id_from_web)+".png";
      myCapture.save(temp_save_name);
      //saveFrame(temp_save_name);
      freeze();
      show_video = false;
      String[] jsondata = loadStrings(request);
      dbQueries.getData(this, jsondata);
      picLowerLimit = dbData.id[0];
      picUpperLimit = dbData.id[dbData.total_comments-1];
      
      int temptemp = 4;
      
      for(int q=0;q<dbData.total_comments;q++) {
        if(dbData.id[q] == dbData.latest_id_from_web) temptemp = q;     
      }
      
      picIncrement = temptemp; // dbData.total_comments-1;
      currentPic = dbData.id[picIncrement];
      prevPic = dbData.id[picIncrement-1];
      nextPic = dbData.id[picIncrement+1];
      startingTime = millis();
     
      load_image();
      
      println("dbData.total_comments"+dbData.total_comments);
    }
  }


  if(keyPressed) {
    if (key == 'b' || key == 'B') {
      String temp_save_name = "data/"+str(dbData.latest_id_from_web)+".png";
      myCapture.save(temp_save_name);
    }
    if (key == 'w' || key == 'W') {
      show_video = false;
    }
    if (key == 'q' || key == 'Q') {
      show_video = true;
      startingTime_capture =  millis();
    }

  }
  
  
  // draw debug info
  color(255, 0, 0);
  ellipseMode(CENTER);
  ellipse(lastPos.x, lastPos.y, 20, 20);
  
}


void freeze() {
   String tem = str(dbData.latest_id_from_web)+".png";
   
   File image_freeze = new File(tem);
   image_freeze_exists = image_freeze.exists();
   
   if(image_freeze_exists == true) just_captured = loadImage(tem);
   else just_captured = loadImage("avatar.png");
  
   image(just_captured, 0, 200, 768, 1166);
   
   delay(2000);
}

void addTuioObject(TuioObject tobj) {
}

void removeTuioObject(TuioObject tobj) {
}

void updateTuioObject (TuioObject tobj) {
}

void addTuioCursor(TuioCursor tcur) {
  
  if(show_video == false) {
    touchPrev = tcur.getScreenX(width);
    
    lastPos.x = tcur.getScreenX(width);
    lastPos.y = tcur.getScreenY(height);
    
    int icon = insideIcon(lastPos);
    
    if(icon != -1)
    {
       startDrag(icon); 
    }
  }
  else {
    
    if(tcur.getScreenY(height) > 0) {
      
      freeze();
      show_video = false;
      String[] jsondata = loadStrings(request);
      dbQueries.getData(this, jsondata);
      picLowerLimit = dbData.id[0];
      picUpperLimit = dbData.id[dbData.total_comments-1];
      
      int temptemp = 4;
      
      for(int q=0;q<dbData.total_comments;q++) {    
        if(dbData.id[q] == dbData.latest_id_from_web) temptemp = q;  
      }
      
      picIncrement = temptemp;
      currentPic = dbData.id[picIncrement];
      prevPic = dbData.id[picIncrement-1];
      nextPic = dbData.id[picIncrement+1];
      startingTime = millis();
      
      load_image();
         
    }  
    
  }


}

void updateTuioCursor (TuioCursor tcur) {
  if(show_video == false && dragging == -1) {
    int diff;   
    diff = tcur.getScreenX(width) - touchPrev;
    touchX = diff;   
  }
  
  lastPos.x = tcur.getScreenX(width);
  lastPos.y = tcur.getScreenY(height);
  
  if(dragging != -1)
  {
     draggedIconPos[dragging] = lastPos; 
  }
  
 // println(lastPos.x + " / " + lastPos.y);
}

void removeTuioCursor(TuioCursor tcur) {

  if(show_video == false) {
    if(tcur.getScreenX(width) < 300 && picIncrement < dbData.total_comments-1) {    
      aniX = Ani.to(this, 1.0, "touchX", -768);  
      turnLeft = true;
    }
    else if(tcur.getScreenX(width) > 468  && picIncrement > 0) {
      aniX = Ani.to(this, 1.0, "touchX", 768);
      turnRight = true;
    }  
    else {
      aniX = Ani.to(this, 1.0, "touchX", 0);
    }
  }
  
  if(dragging != -1)
    stopDrag(dragging);
  
  lastPos.x = 0;
  lastPos.y = 0;
  
}

void refresh(TuioTime bundleTime) { 
  redraw();
}

int insideIcon(PVector pos)
{
  
   for(int i = 0; i < 5; i++)
  {
     PVector c1 = iconCoords[i];
     PVector c2 = ( i < 4 ? iconCoords[i+1] : new PVector(width, 1215) );
     
     if(pos.x > c1.x && pos.x < c2.x && pos.y > c1.y && pos.y < height)
     {
        return i; 
     }
  } 
  
  return -1;
}

void startDrag(int icon)
{
   dragging = icon; 
}

void stopDrag(int icon)
{
   dragging = -1; 
}

