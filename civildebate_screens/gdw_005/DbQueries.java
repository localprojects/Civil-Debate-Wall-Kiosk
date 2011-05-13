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
   
   public void getNewChoice(PApplet canvas, DbData dbData, String[] jsondataLatest)
   {
      try {         
         JSONObject json = new JSONObject(canvas.join(jsondataLatest, ""));
         JSONObject phone_number = json.getJSONObject("phone_number"); 
         canvas.println("Latest ID is "+phone_number.getString("id"));
         dbData.latest_id_from_web = phone_number.getInt("id");
         
         
         
      } catch (Exception e) {
          canvas.println(e.toString());
      }    
   }
   
   public DbData getData(PApplet canvas, String[] jsondata)
   {      
      DbData dbData = new DbData();       
      try {
        //canvas.println(jsondata);
         JSONArray jsonarray = new JSONArray(canvas.join(jsondata, ""));
         dbData.total_comments = jsonarray.length();
         canvas.println("dbData.total_comments priting from getData() "+dbData.total_comments);
         
         for(int i = 0; i < jsonarray.length(); i++)
         {
           JSONObject phone_number = jsonarray.getJSONObject(i).getJSONObject("phone_number");
           JSONObject choice = jsonarray.getJSONObject(i).getJSONObject("choice");
           dbData.id[i] = phone_number.getInt("id");          
           dbData.txt[i] = choice.getString("comment_text");
         }
      }
      catch (JSONException e) {
         canvas.println(e.toString());
      }
      
     return dbData;
   }
}
