import processing.core.*; 
import processing.xml.*; 

import de.bezier.data.sql.*; 
import com.mysql.jdbc.*; 
import java.util.*; 

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





// created 2005-05-10 by fjenett
// updated fjenett 20081129


MySQL msql;

public void setup(){ 
	size(1024,768); 
	
	String user     = "vis";
    String pass     = "ualize";
	
    // name of the database to use
    //
    String database = "gdw";
    // add additional parameters like this:
    // bildwelt?useUnicode=true&characterEncoding=UTF-8
	
    // connect to database of server "localhost"
    //
    println("bla");
    msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
    
    if ( msql.connect() )
    {
    	ArrayList images;
    	
        msql.query( "SELECT username, image FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id;" );
        while(msql.next())
        {
        	println( msql.getString("username") );
        	println( msql.getString("image") );
        	String imgurl = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/" + msql.getString("image"); 
        	if(msql.getString("image") != "")
        	{
        		PImage img = loadImage(imgurl);
        		images.add(img);
        	}
        	
        	// http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/<name>/.jpg
        		
        }
        
        int x = 0;
        for (PImage im : images)
        {
        	image(im, x, 0);
        	x += 100;
        }
    }
    else
    {
        // connection failed !
    }
} 
 
public void draw(){ 
	ellipse(50,50,80,80); 
} 
    static public void main(String args[]) {
        PApplet.main(new String[] { "--bgcolor=#ECE9D8", "civildebate_vis" });
    }
}
