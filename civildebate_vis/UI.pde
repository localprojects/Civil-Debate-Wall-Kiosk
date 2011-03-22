class UI { 
  String UI_question;
  String UI_answer1;
  String UI_answer2;
  String UI_answer3;
  int UI_total_votes;
  
  UI(String question, String answer1, String answer2, String answer3, int total_votes) { 
    UI_question = question;
    UI_answer1 = answer1;
    UI_answer2 = answer2;
    UI_answer3 = answer3;
    UI_total_votes = total_votes;
  }

  void display() {
    stroke(0);
    PFont font = createFont("Arial", 14, true);
    fill(0);
    text(UI_question, 100, 60);
    text(UI_answer1, 100, 160);
    text(UI_answer2, 100, 260);  
    text(UI_answer3, 100, 360);
    text("Total Votes: "+UI_total_votes, 100, 460);         
  }
}

