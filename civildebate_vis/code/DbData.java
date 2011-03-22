public class DbData
{
   final static int NUM_ANSWERS = 3;
   
   String question_text          = "";
   String answer_text            = "";
   String choice_userName        = "";
   String choice_userImageUrl    = "";
   int choice_answerNumber       = 0;
   int numPositiveRatings[];
   int numTotalChoices[];
   
   public DbData() {
      numPositiveRatings      = new int[NUM_ANSWERS];
      numTotalChoices         = new int[NUM_ANSWERS];
   }
}
