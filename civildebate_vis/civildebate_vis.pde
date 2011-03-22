import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import processing.core.*;


MySQL msql;
DbData dbData;
DbQueries dbQueries;

//ArrayList<String> usernames;

void setup() { 
  
	size(1024,768, OPENGL);
	smooth();
	 
	 // Database connection  
	String user = "vis";
    String pass = "ualize";
    String database = "gdw_dev";

/*
    msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
      
    DbQueries dbQueries = new DbQueries(msql);
	 
	dbData = dbQueries.getData();
	
	print(dbData.toString());
*/
  	load_QA(); 
  	World.init(this);
  	World.generateView(this, dbData);
} 
 
void draw() { 
	background(0);
	
	
	
	World.draw(this, dbData);
	
	//UI.draw(this, dbData);
	
}

void load_QA() {
  PFont font = createFont("Arial", 14, true);
  fill(0);
 
}  