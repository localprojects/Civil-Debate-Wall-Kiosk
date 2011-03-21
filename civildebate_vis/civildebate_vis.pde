import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import java.util.*;

MySQL msql;

void setup() { 
  size(1024,768); 
  String user = "vis";
  String pass = "ualize";
  String database = "gdw";
//bildwelt?useUnicode=true&characterEncoding=UTF-8
  println("bla");
  msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
    
  if (msql.connect()) {
    ArrayList<PImage> images = new ArrayList<PImage>();	
    msql.query( "SELECT username, image FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id;" );
    while(msql.next()) {
      println( msql.getString("username"));
      println( msql.getString("image"));
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
  }
  else {
      println("Connection Failed");
  }
} 
 
void draw() { 
	
} 
