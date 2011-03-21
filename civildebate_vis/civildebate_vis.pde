import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import java.util.*;

MySQL msql;

String question = "";
String[] answer = {"","",""};
int totalVotes;

void setup() { 
  
  size(1024,768);
  smooth();
  
  // Database connection  
  String user = "vis";
  String pass = "ualize";
  String database = "gdw";
  //bildwelt?useUnicode=true&characterEncoding=UTF-8
  msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );

  // Fetch Question from DB  
  if (msql.connect()) {
    msql.query( "SELECT * FROM vote_question LIMIT 0, 1;" );
    while(msql.next()) {           
      question = msql.getString("text");    
    }
  } else println("Connection Failed");
    
  // Fetch Answers from DB  
  if (msql.connect()) {
    msql.query( "SELECT * FROM vote_answer LIMIT 0, 3;" );
    int answerCount = 0;
    while(msql.next()) {           
      answer[answerCount] = msql.getString("text");      
      answerCount += 1;
    }
  } else println("Connection Failed");
  
  
  // Fetch Total No. of votes from DB  
  if (msql.connect()) {
    msql.query( "SELECT COUNT(*) FROM vote_choice;");
    while(msql.next()) {           
      totalVotes = msql.getInt(1);      
    }
  } else println("Connection Failed");  
  
  /*
  if (msql.connect()) {
    ArrayList<PImage> images = new ArrayList<PImage>();	
    msql.query( "SELECT username, image FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id;" );
    while(msql.next()) {      
      //println( msql.getString("username"));
      //println( msql.getString("image"));
      String imgurl = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/" + msql.getString("username") + ".jpg"; 
      if(msql.getString("image").contains("images")) {
	  PImage img = loadImage(imgurl);
	  images.add(img);
      }      	
      // http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/<name>/.jpg 		
    }     
    int x = 0;
    for (PImage im : images) {
      image(im, x, 0);
      x += 100;
    }
  } else println("Connection Failed");
  */
  
  load_QA(); 
} 
 
void draw() { 
	
}

void load_QA() {
  PFont font = createFont("Arial", 14, true);
  fill(0);
  text(question, 100, 60);
  text(answer[0], 100, 160);
  text(answer[1], 100, 260);  
  text(answer[2], 100, 360);
  text("Total Votes: "+totalVotes, 100, 460);   
}  
