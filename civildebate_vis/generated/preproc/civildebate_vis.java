import processing.core.*; 
import processing.xml.*; 

import de.bezier.data.sql.*; 
import com.mysql.jdbc.*; 
import processing.core.*; 
import processing.opengl.*; 
import javax.media.opengl.*; 

import com.mysql.jdbc.profiler.*; 
import com.mysql.jdbc.integration.jboss.*; 
import com.mysql.jdbc.jdbc2.optional.*; 
import com.mysql.jdbc.util.*; 
import com.mysql.jdbc.integration.c3p0.*; 
import com.mysql.jdbc.log.*; 
import org.gjt.mm.mysql.*; 
import com.mysql.jdbc.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class civildebate_vis extends PApplet {







MySQL msql;
DbData dbData;
DbQueries dbQueries;

//ArrayList<String> usernames;

public void setup() { 
  
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
 
public void draw() { 
	background(0);
	
	
	
	World.draw(this, dbData);
	
	//UI.draw(this, dbData);
	
} 

public void mousePressed()
{
	println("NEW CHOICE");
	newChoice();
}

public void keyPressed()
{
	println("KEY");
	
	if(key == 'n')
	{
		println("NEW CHOICE");
		newChoice();	
	}	
}

public void newChoice()
{
	dbQueries.getNewChoice(dbData);
	print(dbData.toString());
	World.generateView(this, dbData);
}
    static public void main(String args[]) {
        PApplet.main(new String[] { "--bgcolor=#ECE9D8", "civildebate_vis" });
    }
}
