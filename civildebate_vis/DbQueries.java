

import de.bezier.data.sql.*;
import com.mysql.jdbc.*;
import java.util.*;
import processing.core.*;
import org.json.*;

public class DbQueries
{
   public static int NUM_ANSWERS = 3;   
   public MySQL msql;   
   public DbQueries(MySQL _msql) {
      msql = _msql;
   }   
   public void getNewChoice(PApplet canvas, DbData dbData, ArrayList<DbData> cachedData)
   {
      /*
      ArrayList<Integer> allChoices = new ArrayList<Integer>(); 
      msql.query( "SELECT id FROM vote_choice WHERE question_id = " + dbData.question_id + ";");
      while(msql.next()) {
        allChoices.add(msql.getInt("id"));
      }
      
      Collections.shuffle(allChoices);
      int curChoice = allChoices.get(0);
      //answer_id, comment_text, username, first_name, last_name, image, c.user_id
      msql.query( "SELECT * FROM vote_choice c JOIN " +
                     "(SELECT username, first_name, last_name, image, user_id FROM auth_user a JOIN vote_debatefacebookprofile s on a.id=s.user_id) u " +
                  "on c.user_id = u.user_id WHERE c.id = "+curChoice+";");
      
      while(msql.next()) {
         dbData.choice_user_userName = msql.getString("username");
         try {
            dbData.choice_user_firstName = msql.getString("first_name");
            dbData.choice_user_lastName = msql.getString("last_name");
            if(msql.getString("image").contains("images"))
               dbData.choice_user_imageUrl = "http://ec2-75-101-223-231.compute-1.amazonaws.com/main/static/profile_images/" + msql.getString("username") + ".jpg"; 
         } catch(Exception e) {
            e.printStackTrace();
         }
         
      }
      
      msql.query("SELECT * FROM vote_answer a JOIN vote_choice c on a.id = c.answer_id WHERE c.id = " + curChoice + ";");
      while(msql.next()) {
         try {
            dbData.choice_answer_id = msql.getInt("answer_id");
            dbData.choice_answer_number = msql.getInt("number");
            dbData.choice_comment_text = msql.getString("comment_text");
         } catch(Exception e) {
            e.printStackTrace();
         }
      }
      
      for(int i = 0; i < NUM_ANSWERS; i++)
      {
         int curAnswerNum = i + 1;        
         if(curAnswerNum == dbData.choice_answer_number)
            continue;         
         msql.query("select count(*) from vote_rating r JOIN (auth_user u, vote_choice c, vote_answer a) on " +
               "(r.user_id = u.id and u.id = c.user_id and c.answer_id = a.id) " +
               "where r.choice_id = "+curChoice+" and rating =  1 and c.question_id = "+ dbData.question_id +" and a.number = "+curAnswerNum+";");
         while(msql.next()) {
            try {
               dbData.numPositiveRatingsPerAnswer[i] = msql.getInt(1);
            } catch(Exception e) {
               e.printStackTrace();
            }
         }
      }
      */
      try {
         String request = "http://www.civildebatewall.com/vote/vis_choice/"+dbData.question_id+"/";
         JSONObject json = new JSONObject(canvas.join(canvas.loadStrings(request), ""));
         
         dbData.choice_user_firstName = json.getString("user_firstname");
         dbData.choice_user_lastName = json.getString("user_lastname");
         dbData.choice_user_gender = json.getString("user_gender");
         dbData.choice_answer_id = json.getInt("answer_id");
         dbData.choice_answer_number = json.getInt("answer_number");
         dbData.choice_comment_text = json.getString("answer_comment_text");
         dbData.choice_constructiveness_rank = json.getInt("constructiveness_rank");
         
         dbData.choice_user_imageUrl = null;
         try {
            dbData.choice_user_imageUrl = json.getString("user_imgurl");
         } catch(Exception e) {
            canvas.println("no image for user " + dbData.choice_user_firstName + " " + dbData.choice_user_lastName);
         }
         
         JSONArray positivePerAnswer = json.getJSONArray("positive_ratings_per_answer");
         
         for(int i = 0; i < positivePerAnswer.length(); i++)
         {
            dbData.numPositiveRatingsPerAnswer[i] = positivePerAnswer.getInt(i);
         }
      } catch (Exception e) {
         canvas.println(e.toString());
    //     Collections.shuffle(cachedData);
   //      dbData = cachedData.get(0);
      }
   }
   
   public DbData getData(PApplet canvas, ArrayList<DbData> cachedData)
   {      
      DbData dbData = new DbData();    
      
      /*
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
         
         for(int i = 0; i < NUM_ANSWERS; i++)
         {
            int curAnswerNum = i + 1;            
            msql.query("select count(*) from vote_choice c JOIN vote_answer a ON c.answer_id = a.id where c.question_id = "+dbData.question_id+" and a.number = "+curAnswerNum+";");
            while(msql.next()) {
               try {
                  dbData.numTotalChoicesPerAnswer[i] = msql.getInt(1);
               } catch(Exception e) {
                  e.printStackTrace();
               }
            }
         }
          
    
     }
     */
      
      try {
         String request = "http://www.civildebatewall.com/vote/vis_data/";
         JSONObject json = new JSONObject(canvas.join(canvas.loadStrings(request), ""));
         JSONObject question = json.getJSONObject("question");
         JSONArray answers = json.getJSONArray("answers");
         int totalvotes = json.getInt("totalvotes");
         
         dbData.question_text = question.getString("text"); 
         dbData.question_id = question.getInt("id");
         
         
         for(int i = 0; i < answers.length(); i++)
         {
            JSONObject answer = answers.getJSONObject(i);
            dbData.answer_text[i] = answer.getString("text");
            dbData.numTotalChoicesPerAnswer[i] = answer.getInt("numchoices");
         }
         
         dbData.numTotalChoices = totalvotes;
      }
      catch (JSONException e) {
         canvas.println(e.toString());
   //      Collections.shuffle(cachedData);
    //     dbData = cachedData.get(0);
      }
      
      
     return dbData;
   }
}
