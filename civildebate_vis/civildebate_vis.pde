import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;
import java.util.*;
import de.looksgood.ani.*;
import org.json.*;
import fullscreen.*; 

FullScreen fs; 
//import simpleML.*;

int startingTime;
boolean loadOnce = true;

MySQL msql;
DbData dbData;
ArrayList<DbData> cachedData;
DbQueries dbQueries;
UI ui;
Comment comment;
Bar_Graph graph;

Ani one_aAni;
Ani one_bAni;
Ani one_cAni;
Ani f_inAni;
Ani f_in_1Ani;
Ani f_in_2Ani;

PImage logo;
PImage a,b,c;
PImage photo;
PImage star;
PFont font_question;
PFont font_questionOfTheWeek;
PFont font_answer;
PFont font_comment;
PFont font_comment_sub;
PFont font_comment_header;
PFont font_vote_count;
PFont font_idea_constructive;
HashMap<String, PVector> coordinates;

//HTMLRequest dataRequest, choiceRequest;

int roundTimer = 0;

final static int ROUNDTIME = 10000;
int last = 0;

final static String HOST = "http://ec2-75-101-223-231.compute-1.amazonaws.com";

//ArrayList<String> usernames;

void setup() { 
  size(1024,768, OPENGL);
  
  startingTime = millis();
  last = startingTime;
  
  smooth();
  //frameRate(10);
  Ani.init(this);
  coordinates = new HashMap<String, PVector>();
  
  cachedData = new ArrayList<DbData>();
  
  logo = loadImage("logo.png");
  a = loadImage("a.png");
  b = loadImage("b.png");
  c = loadImage("c.png");
  
  star = loadImage("star.png");
   
  font_question = createFont("Georgia Bold", 28, true);
  font_questionOfTheWeek = createFont("ITCFranklinGothicStd-BkCp", 17, true); 
  font_answer = createFont("Georgia", 17, true); 
  font_comment = createFont("Georgia Italic", 20, true);
  font_comment_sub = createFont("ITCFranklinGothicStd-BkCp", 15, true);  
  font_comment_header = createFont("ITCFranklinGothicStd-BkCp", 17, true);  
  font_vote_count = createFont("ITCFranklinGothicStd-BkCp", 26, true);
  font_idea_constructive = createFont("ITCFranklinGothicStd-BkCp", 20, true);

  // Database connection  
  //String user = "vis";
  //String pass = "ualize";
  //String database = "gdw_dev";

  //msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
      
  dbQueries = new DbQueries(msql);
  dbData = dbQueries.getData(this, cachedData);
  ui = new UI();
  graph = new Bar_Graph();
  comment = new Comment();
  World.init(this);

  background(0);
  
  newChoice();   
 // World.draw(this, dbData, coordinates);
  ui.display(this, dbData);
  comment.wrap_text(this);
  comment.ani_1(this);
  graph.ani(this);
  
   
  
} 
 
void draw() { 
  
  background(0);
  println(frameRate);
  int now = millis();
  int dt = now - last;
  last = now;
  
  roundTimer += dt;
  
  if (millis() - startingTime > ROUNDTIME-2000 && loadOnce == true) {
      comment.ani_o(this);
    graph.anio(this); 
    loadOnce = false;
  }
  
  if (millis() - startingTime > ROUNDTIME) {
    reload();
    loadOnce = true;
    startingTime = millis();
  }
  World.draw(this, dbData, coordinates, roundTimer);
  ui.display(this, dbData); 
  graph.plot(this, dbData); 
  comment.show(this, dbData,coordinates);
} 

void reload() {
  newChoice();   
  comment.ani_1(this);
  comment.wrap_text(this);
  graph.ani(this); 
}    
  
void mousePressed() {
  reload();
}

void newChoice() {   
  roundTimer = 0;  
  
 // dataRequest = new HTMLRequest(this,"http://ec2-75-101-223-231.compute-1.amazonaws.com/main/vote/vis_data/");
 // dataRequest.makeRequest();
  
  dbData = dbQueries.getData(this, cachedData);
  dbQueries.getNewChoice(this, dbData, cachedData);
  
  cachedData.add(dbData);
  
  if(cachedData.size() > 10)
  {
  	Collections.shuffle(cachedData);
  	cachedData.remove(0);
  }
  
  World.generateView(this, dbData, coordinates);
  
  if(dbData.choice_user_imageUrl != null && dbData.choice_user_imageUrl != "null")
  	photo = loadImage(HOST + dbData.choice_user_imageUrl);
  else
  	photo = loadImage(HOST + "/dev/media/profile_images/avatar.gif");
  photo.resize(83, (83 * photo.height)/photo.width);
}
