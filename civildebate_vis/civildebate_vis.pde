import de.bezier.data.sql.*;
import com.mysql.jdbc.*;


MySQL msql;
DbData dbData;
DbQueries dbQueries;

//ArrayList<String> usernames;

void setup() { 
  
	size(1024,768);
	smooth();
	 
	 // Database connection  
	String user = "vis";
    String pass = "ualize";
    String database = "gdw_dev";
       //bildwelt?useUnicode=true&characterEncoding=UTF-8
    msql = new MySQL( this, "ec2-75-101-223-231.compute-1.amazonaws.com:3306", database, user, pass );
      
    DbQueries dbQueries = new DbQueries(msql);
	 
	dbData = dbQueries.getData();
	// println(dbData.question_text);
	 //usernames = new ArrayList<String>();
  
	 
  	
  	load_QA(); 
} 
 
void draw() { 
	
}

void load_QA() {
  PFont font = createFont("Arial", 14, true);
  fill(0);
 
}  