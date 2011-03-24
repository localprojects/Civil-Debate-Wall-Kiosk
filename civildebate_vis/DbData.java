public class DbData
{
   public final static int NUM_ANSWERS = 3;
   
   public int question_id = 0;
   public String question_text = "";
   
   public int answer_id = 0;
   public String answer_text[];
   
   public String choice_user_userName = "";
   public String choice_user_firstName = "";
   public String choice_user_lastName = "";
   public String choice_user_imageUrl = "";
   
   public int choice_answer_id = 0;
   public int choice_answer_number = 0;
   public String choice_comment_text = "";
   
   public int numPositiveRatingsPerAnswer[];
   public int numTotalChoicesPerAnswer[];
   public int numTotalChoices = 0;
   
   public DbData() {
      numPositiveRatingsPerAnswer = new int[NUM_ANSWERS];
      numTotalChoicesPerAnswer = new int[NUM_ANSWERS];
      answer_text = new String[NUM_ANSWERS];      
      for(int i = 0; i < NUM_ANSWERS; i++) answer_text[i] = "";
   }
   
   public String toString() {      
      String s = "";
      s += question_id + "\n";
      s += question_text + "\n";
      s += answer_id + "\n";
      s += answer_text[0] + "/" + answer_text[1] + "/" + answer_text[2] + "\n";
      s += choice_user_userName + "\n";
      s += choice_user_firstName + "\n";
      s += choice_user_lastName + "\n";
      s += choice_user_imageUrl + "\n";
      s += choice_answer_id + "\n";
      s += choice_answer_number + "\n";
      s += choice_comment_text + "\n";
      s += numPositiveRatingsPerAnswer[0] + "/" + numPositiveRatingsPerAnswer[1] + "/" + numPositiveRatingsPerAnswer[2] + "\n";
      s += numTotalChoicesPerAnswer[0] + "/" + numTotalChoicesPerAnswer[1] + "/" + numTotalChoicesPerAnswer[2] + "\n";
      s += numTotalChoices + "\n";      
      return s;
   }
}
