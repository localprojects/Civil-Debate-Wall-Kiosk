import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;

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


    msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
      
    dbQueries = new DbQueries(msql);
    dbData = dbQueries.getData();
  	World.init(this);
  	
  	newChoice();
} 
 
void draw() { 
	background(0);
	
	
	
	World.draw(this, dbData);
	
	//UI.draw(this, dbData);
	
} 

void mousePressed()
{
	println("NEW CHOICE");
	newChoice();
}

void keyPressed()
{
	println("KEY");
	
	if(key == 'n')
	{
		println("NEW CHOICE");
		newChoice();	
	}	
}

void newChoice()
{
	dbQueries.getNewChoice(dbData);
	print(dbData.toString());
	World.generateView(this, dbData);
}