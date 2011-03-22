public class DbData
{
   public final static int NUM_ANSWERS = 3;
   
   public int question_id                 = 0;
   public String question_text            = "";
   public String answer_text[];
   public String choice_userName          = "";
   public String choice_userImageUrl      = "";
   public int choice_answerNumber         = 0;
   public int numPositiveRatingsPerAnswer[];
   public int numTotalChoicesPerAnswer[];
   public int numTotalChoices             = 0;
   
   public DbData() {
      numPositiveRatingsPerAnswer      = new int[NUM_ANSWERS];
      numTotalChoicesPerAnswer         = new int[NUM_ANSWERS];
      answer_text             = new String[NUM_ANSWERS];
      
      for(int i = 0; i < NUM_ANSWERS; i++)
            answer_text[i] = "";
   }
}
