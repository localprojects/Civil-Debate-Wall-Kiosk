public class DbData
{
   
   public int total_comments = 0;

         public int[] id = new int[100];
         public String[] txt = new String[100];   
         public int latest_id_from_web;
         public int latest_id_in_comp;
   
   public DbData() {
   
   }
   
   public String toString() {  
    
      String s = "";
      /*
      s += question_id + "\n";
      s += question_text + "\n";      
      */
      return s;
   }
}
