import de.bezier.data.sql.*;
import com.mysql.jdbc.*;


public class DbQueries
{
   public MySQL msql;
   
   public DbQueries(MySQL _msql)
   {
      msql = _msql;
   }
   
   public void getData()
   {
      
      DbData dbData = new DbData();
      
      if (msql.connect()) {

        // Fetch Question from DB  
         msql.query( "SELECT * FROM vote_question LIMIT 0, 1;" );
         while(msql.next()) {           
              dbData.question_text = msql.getString("text"); 
              dbData.question_id = msql.getInt("id");    
         }
         
        // Fetch Answers from DB  
         msql.query( "SELECT * FROM vote_answer LIMIT 0, 3;");
         int answerCount = 0;
         while(msql.next() && answerCount < DbData.NUM_ANSWERS) {   
              dbData.answer_text[answerCount] = msql.getString("text");      
              answerCount += 1;
         }
       
       
        // Fetch Total No. of votes from DB  
         msql.query( "SELECT COUNT(*) FROM vote_choice WHERE question_id = " + dbData.question_id + ";");
         while(msql.next()) {           
              dbData.numTotalChoices = msql.getInt(1);      
         }
         
         ArrayList<int> allChoices = new ArrayList<int>(); 
         msql.query( "SELECT id FROM vote_choice WHERE question_id = " + dbData.question_id + ";");
         while(msql.next()) {
           allChoices.add(msql.getInt("id"));
         }
         
         Collection.shuffle(allChoices);
         
         msql.query( "SELECT answer_id, comment_text, username, first_name, last_name, image, c.user_id FROM vote_choice c JOIN (SELECT username, first_name, last_name, image, user_id FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id) u on c.user_id = u.user_id WHERE c.id = "+allChoices.get(0)+";");
         while(msql.next()) {
           dbData.choice_user_userName = msql.getString("username";
              dbData.choice_user_firstName = "";
              dbData.choice_user_lastName = "";
              dbData.choice_user_imageUrl = "";
         }

         msql.query( "SELECT username, image FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id;" );
         while(msql.next()) {      
              dbData.choice_user_userName = msql.getString("username");
              dbData.choice_user_firstName = msql.getString("first_name");
              dbData.choice_user_lastName = msql.getString("last_name");
              dbData.choice_user_imageUrl = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/" + msql.getString("username") + ".jpg"; 
           //if(msql.getString("image").contains("images")) {
          //PImage img = loadImage(imgurl);
          //images.add(img);
         }       
           // http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/<name>/.jpg     
    
     }
      
      return dbData;
   }
}
